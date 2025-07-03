// circular_buffer_manager.sv
module circular_buffer_manager #(
  parameter int BUFFER_SIZE = 8,
  parameter int DATA_WIDTH = 8
)(
  input  logic                    clk,
  input  logic                    rst_n,
  input  logic                    write_enable,
  input  logic                    read_enable,
  input  logic [DATA_WIDTH-1:0]   write_data,
  output logic [DATA_WIDTH-1:0]   read_data,
  output logic                    buffer_full,
  output logic                    buffer_empty,
  output logic [$clog2(BUFFER_SIZE):0] buffer_count
);

  // Internal buffer memory
  logic [DATA_WIDTH-1:0] buffer_memory [BUFFER_SIZE-1:0];
  logic [$clog2(BUFFER_SIZE)-1:0] write_pointer;
  logic [$clog2(BUFFER_SIZE)-1:0] read_pointer;
  logic [$clog2(BUFFER_SIZE):0] item_count;

  // Buffer status flags
  assign buffer_full = (item_count == ($clog2(BUFFER_SIZE)+1)'(BUFFER_SIZE));
  assign buffer_empty = (item_count == 0);
  assign buffer_count = item_count;

  // Write operation
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      write_pointer <= 0;
      item_count <= 0;
      // Initialize buffer memory
      for (int i = 0; i < BUFFER_SIZE; i++) begin
        buffer_memory[i] <= 0;
      end
    end else begin
      if (write_enable && !buffer_full) begin
        buffer_memory[write_pointer] <= write_data;
        if (write_pointer == ($clog2(BUFFER_SIZE))'(BUFFER_SIZE - 1)) begin
          write_pointer <= 0;
        end else begin
          write_pointer <= write_pointer + 1'b1;
        end
        if (!read_enable || buffer_empty) begin
          item_count <= item_count + 1'b1;
        end
      end else if (read_enable && !buffer_empty && !write_enable) begin
        item_count <= item_count - 1'b1;
      end
    end
  end

  // Read operation
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      read_pointer <= 0;
      read_data <= 0;
    end else begin
      if (read_enable && !buffer_empty) begin
        read_data <= buffer_memory[read_pointer];
        if (read_pointer == ($clog2(BUFFER_SIZE))'(BUFFER_SIZE - 1)) begin
          read_pointer <= 0;
        end else begin
          read_pointer <= read_pointer + 1'b1;
        end
      end
    end
  end

  // Display buffer contents for debugging
  initial begin
    $display("Buffer Manager initialized with size: %0d", BUFFER_SIZE);
    $display("Data width: %0d bits", DATA_WIDTH);
  end

endmodule