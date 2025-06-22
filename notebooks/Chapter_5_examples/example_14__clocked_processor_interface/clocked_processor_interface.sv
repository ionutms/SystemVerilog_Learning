// clocked_processor_interface.sv
module clocked_processor_interface (
  input  logic       clk,
  input  logic       rst_n,
  input  logic [7:0] data_in,
  input  logic       valid_in,
  output logic [7:0] data_out,
  output logic       valid_out,
  output logic       ready
);

  // Simple processor that doubles the input data
  logic [7:0] internal_data;
  
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      data_out  <= 8'h00;
      valid_out <= 1'b0;
      ready     <= 1'b1;
      internal_data <= 8'h00;
    end else begin
      if (valid_in && ready) begin
        internal_data <= data_in;
        data_out      <= data_in << 1;  // Double the input
        valid_out     <= 1'b1;
        ready         <= 1'b0;          // Not ready for next cycle
      end else begin
        valid_out <= 1'b0;
        ready     <= 1'b1;              // Ready for new data
      end
    end
  end

  initial $display("Clocked processor interface initialized");

endmodule