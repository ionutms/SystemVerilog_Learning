// parameter_vs_type_demo.sv
package data_types_pkg;
  // Define custom types for demonstration
  typedef struct packed {
    logic [7:0] red;
    logic [7:0] green; 
    logic [7:0] blue;
  } rgb_color_t;
  
  typedef struct packed {
    logic [15:0] x;
    logic [15:0] y;
  } coordinate_t;
endpackage

module parameter_vs_type_demo
  import data_types_pkg::*;
  
  // Parameter parameterization - values known at compile time
  #(parameter int WIDTH = 8,           // Bit width
    parameter int DEPTH = 16)          // Memory depth
  
  // Type parameterization - types can be different
  (input  logic clk,
   input  logic reset_n,
   output logic [WIDTH-1:0] param_data_out,
   output logic param_valid);

  // Memory using parameter-based sizing
  logic [WIDTH-1:0] memory [DEPTH-1:0];
  logic [$clog2(DEPTH)-1:0] addr_counter;
  
  // Initialize memory with pattern based on WIDTH
  initial begin
    for (int i = 0; i < DEPTH; i++) begin
      memory[i] = i[WIDTH-1:0] ^ {WIDTH{1'b1}};  // XOR pattern
    end
  end
  
  // Simple counter to read through memory
  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      addr_counter <= '0;
      param_data_out <= '0;
      param_valid <= 1'b0;
    end else begin
      param_data_out <= memory[addr_counter];
      param_valid <= 1'b1;
      addr_counter <= (addr_counter == ($clog2(DEPTH))'(DEPTH-1)) ? 
                      '0 : addr_counter + 1;
    end
  end

  // Display current configuration
  initial begin
    $display("Parameter-based module instantiated:");
    $display("  WIDTH = %0d bits", WIDTH);
    $display("  DEPTH = %0d entries", DEPTH);
    $display("  Address width = %0d bits", $clog2(DEPTH));
  end

endmodule

// Type-parameterized module - more flexible for different data types
module type_parameterized_register
  #(parameter type DATA_TYPE = byte)
  
  (input  logic clk,
   input  logic reset_n,
   input  logic load_enable,
   input  DATA_TYPE data_in,
   output DATA_TYPE data_out);

  import data_types_pkg::*;

  // Register that can hold any type
  DATA_TYPE internal_register;
  
  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      internal_register <= '0;
    end else if (load_enable) begin
      internal_register <= data_in;
    end
  end
  
  assign data_out = internal_register;

  // Display type information (compile-time)
  initial begin
    $display("Type-parameterized register instantiated:");
    $display("  DATA_TYPE size = %0d bits", $bits(DATA_TYPE));
  end

endmodule