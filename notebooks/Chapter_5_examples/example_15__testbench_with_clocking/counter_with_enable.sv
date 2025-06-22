// counter_with_enable.sv
module counter_with_enable (
  input  logic       clk,
  input  logic       reset_n,
  input  logic       enable,
  output logic [3:0] count
);

  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      count <= 4'b0000;
    end else if (enable) begin
      count <= count + 1;
    end
  end

endmodule