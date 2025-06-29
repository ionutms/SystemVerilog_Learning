// circular_buffer_manager.sv - Fixed Version
module circular_buffer_manager #(
  parameter BUFFER_DEPTH = 8,
  parameter DATA_WIDTH   = 8
)(
  input  logic                    clk,
  input  logic                    reset_n,
  input  logic                    write_enable,
  input  logic                    read_enable,
  input  logic [DATA_WIDTH-1:0]   write_data,
  output logic [DATA_WIDTH-1:0]   read_data,
  output logic                    buffer_full,
  output logic                    buffer_empty,
  output logic [$clog2(BUFFER_DEPTH):0] occupancy_count
);

  // Internal memory pool
  logic [DATA_WIDTH-1:0] memory_pool [BUFFER_DEPTH];
  
  // Circular buffer pointers  
  logic [$clog2(BUFFER_DEPTH)-1:0] write_pointer;
  logic [$clog2(BUFFER_DEPTH)-1:0] read_pointer;
  logic [$clog2(BUFFER_DEPTH):0]   data_count;

  // Buffer management functions
  function automatic logic is_buffer_full();
    return (data_count == BUFFER_DEPTH);
  endfunction

  function automatic logic is_buffer_empty();
    return (data_count == 0);
  endfunction

  function automatic logic [$clog2(BUFFER_DEPTH)-1:0] next_pointer(
    input logic [$clog2(BUFFER_DEPTH)-1:0] current_pointer
  );
    return (current_pointer == ($clog2(BUFFER_DEPTH)'(BUFFER_DEPTH-1))) ? 
           ($clog2(BUFFER_DEPTH)'(0)) : current_pointer + 1;
  endfunction

  // Memory pool allocation logic
  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      write_pointer  <= '0;
      read_pointer   <= '0;
      data_count     <= '0;
    end else begin
      // Handle simultaneous operations first
      if (write_enable && read_enable && !is_buffer_empty() && !is_buffer_full()) begin
        // Simultaneous read and write - data count stays same
        memory_pool[write_pointer] <= write_data;
        write_pointer <= next_pointer(write_pointer);
        read_pointer <= next_pointer(read_pointer);
        // data_count remains unchanged
      end else begin
        // Handle write-only operation
        if (write_enable && !is_buffer_full() && !(read_enable && !is_buffer_empty())) begin
          memory_pool[write_pointer] <= write_data;
          write_pointer <= next_pointer(write_pointer);
          data_count <= data_count + 1;
        end
        
        // Handle read-only operation  
        if (read_enable && !is_buffer_empty() && !(write_enable && !is_buffer_full())) begin
          read_pointer <= next_pointer(read_pointer);
          data_count <= data_count - 1;
        end
      end
    end
  end

  // Output assignments - combinatorial read
  assign read_data       = memory_pool[read_pointer];
  assign buffer_full     = is_buffer_full();
  assign buffer_empty    = is_buffer_empty();
  assign occupancy_count = data_count;

  initial $display("Circular buffer manager initialized with depth %0d", 
                   BUFFER_DEPTH);

endmodule