// parameter_override.sv
module parameter_override #(
  parameter WIDTH = 4,           // Default width parameter
  parameter DEPTH = 8            // Default depth parameter
)();

  initial begin
    $display();
    $display("Design Parameters:");
    $display("  WIDTH = %0d", WIDTH);
    $display("  DEPTH = %0d", DEPTH);
    $display("  Total capacity = %0d bits", WIDTH * DEPTH);
    $display();
  end

endmodule