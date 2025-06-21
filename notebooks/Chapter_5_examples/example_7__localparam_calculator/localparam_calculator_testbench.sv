// localparam_calculator_testbench.sv
module localparam_calculator_testbench;

  logic clk, reset;

  // Instance 1: Default parameters (8-bit, 16 elements)
  localparam_calculator default_calc(
    .clk(clk),
    .reset(reset)
  );

  // Instance 2: 4-bit data, 32 elements
  localparam_calculator #(
    .DATA_WIDTH(4),
    .NUM_ELEMENTS(32)
  ) small_wide_calc(
    .clk(clk),
    .reset(reset)
  );

  // Instance 3: 16-bit data, 8 elements
  localparam_calculator #(
    .DATA_WIDTH(16),
    .NUM_ELEMENTS(8)
  ) wide_narrow_calc(
    .clk(clk),
    .reset(reset)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    // Dump waves
    $dumpfile("localparam_calculator_testbench.vcd");
    $dumpvars(0, localparam_calculator_testbench);
    
    $display("=== Localparam Calculator Testbench ===");
    $display("Demonstrating how localparams are calculated from parameters");
    $display();
    
    // Reset sequence
    reset = 1;
    #10;
    reset = 0;
    
    // Run for a few clock cycles
    #100;
    
    $display("Notice how each instance has different localparam values");
    $display("based on their parameter overrides, but localparams cannot");
    $display("be overridden directly - they are always calculated!");
    $display();
    
    $finish;
  end

endmodule