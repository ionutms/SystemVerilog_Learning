// simple_counter_design.sv
module simple_counter_module (
  input  logic       clock_signal,
  input  logic       reset_signal,
  input  logic       enable_signal,
  output logic [3:0] counter_output
);

  always_ff @(posedge clock_signal or posedge reset_signal) begin
    if (reset_signal) begin
      counter_output <= 4'b0000;
    end
    else if (enable_signal) begin
      counter_output <= counter_output + 1;
    end
  end

endmodule