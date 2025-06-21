// localparam_calculator.sv
module localparam_calculator #(
  parameter DATA_WIDTH = 8,        // User-configurable parameter
  parameter NUM_ELEMENTS = 16      // User-configurable parameter
)(
  input  logic clk,
  input  logic reset
);

  // Localparams - calculated from parameters, cannot be overridden
  localparam ADDR_WIDTH = $clog2(NUM_ELEMENTS);           // Address width needed
  localparam TOTAL_BITS = DATA_WIDTH * NUM_ELEMENTS;      // Total memory bits
  localparam MAX_VALUE = (1 << DATA_WIDTH) - 1;          // Maximum data value
  localparam HALF_ELEMENTS = NUM_ELEMENTS / 2;           // Half the elements
  
  // Example memory array using derived values
  logic [DATA_WIDTH-1:0] memory [NUM_ELEMENTS-1:0];
  logic [ADDR_WIDTH-1:0] address;

  initial begin
    $display();
    $display("=== Localparam Calculator ===");
    $display("Input Parameters:");
    $display("  DATA_WIDTH = %0d", DATA_WIDTH);
    $display("  NUM_ELEMENTS = %0d", NUM_ELEMENTS);
    $display();
    $display("Calculated Localparams:");
    $display("  ADDR_WIDTH = %0d bits", ADDR_WIDTH);
    $display("  TOTAL_BITS = %0d bits", TOTAL_BITS);
    $display("  MAX_VALUE = %0d", MAX_VALUE);
    $display("  HALF_ELEMENTS = %0d", HALF_ELEMENTS);
    $display();
    $display("Memory array: [%0d:0] memory [%0d:0]", DATA_WIDTH-1, NUM_ELEMENTS-1);
    $display("Address signal: [%0d:0] address", ADDR_WIDTH-1);
    $display();
  end

  // Simple counter to demonstrate address usage
  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      address <= '0;
    else
      address <= address + 1;  // Will automatically wrap at NUM_ELEMENTS
  end

endmodule