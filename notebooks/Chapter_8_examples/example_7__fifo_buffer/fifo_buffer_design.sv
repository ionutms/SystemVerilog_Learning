// fifo_buffer_design.sv
module simple_fifo_buffer #(
  parameter DATA_WIDTH = 8,
  parameter FIFO_DEPTH = 4
)(
  input  logic                  clock_signal,
  input  logic                  reset_signal,
  input  logic                  push_enable,
  input  logic                  pop_enable,
  input  logic [DATA_WIDTH-1:0] data_input,
  output logic [DATA_WIDTH-1:0] data_output,
  output logic                  fifo_empty_flag,
  output logic                  fifo_full_flag
);

  // Internal FIFO storage array
  logic [DATA_WIDTH-1:0] fifo_memory [0:FIFO_DEPTH-1];
  
  // Pointers for head and tail of FIFO
  logic [$clog2(FIFO_DEPTH):0] write_pointer;
  logic [$clog2(FIFO_DEPTH):0] read_pointer;
  logic [$clog2(FIFO_DEPTH):0] data_count;

  // Status flags
  assign fifo_empty_flag = (data_count == 0);
  assign fifo_full_flag  = (data_count == FIFO_DEPTH);

  // Output data from read pointer location
  assign data_output = fifo_memory[read_pointer[1:0]];

  always_ff @(posedge clock_signal or posedge reset_signal) begin
    if (reset_signal) begin
      write_pointer <= 0;
      read_pointer  <= 0;
      data_count    <= 0;
    end
    else begin
      // Push operation (push_back)
      if (push_enable && !fifo_full_flag) begin
        fifo_memory[write_pointer[1:0]] <= data_input;
        write_pointer <= write_pointer + 1;
        data_count    <= data_count + 1;
        $display("FIFO: Pushed data 0x%02x, count=%0d", 
                 data_input, data_count + 1);
      end
      
      // Pop operation (pop_front)
      if (pop_enable && !fifo_empty_flag) begin
        read_pointer <= read_pointer + 1;
        data_count   <= data_count - 1;
        $display("FIFO: Popped data 0x%02x, count=%0d", 
                 data_output, data_count - 1);
      end
    end
  end

endmodule