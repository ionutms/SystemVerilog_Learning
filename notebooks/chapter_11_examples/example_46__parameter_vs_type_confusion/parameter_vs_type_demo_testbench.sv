// parameter_vs_type_demo_testbench.sv
module parameter_vs_type_testbench;
  import data_types_pkg::*;

  // Clock and reset
  logic clk;
  logic reset_n;
  
  // Parameter-based module signals
  logic [7:0] param8_data_out;
  logic [15:0] param16_data_out;
  logic param8_valid, param16_valid;
  
  // Type-based module signals  
  logic [7:0] simple_data_in, simple_data_out;
  rgb_color_t color_data_in, color_data_out;
  coordinate_t coord_data_in, coord_data_out;
  logic load_enable;

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Parameter-based instantiations - same module, different sizes
  parameter_vs_type_demo #(
    .WIDTH(8),
    .DEPTH(8)
  ) param_8bit_inst (
    .clk(clk),
    .reset_n(reset_n),
    .param_data_out(param8_data_out),
    .param_valid(param8_valid)
  );

  parameter_vs_type_demo #(
    .WIDTH(16),
    .DEPTH(4)
  ) param_16bit_inst (
    .clk(clk),
    .reset_n(reset_n),
    .param_data_out(param16_data_out),
    .param_valid(param16_valid)
  );

  // Type-based instantiations - same module, different types
  type_parameterized_register #(
    .DATA_TYPE(byte)
  ) simple_reg_inst (
    .clk(clk),
    .reset_n(reset_n),
    .load_enable(load_enable),
    .data_in(simple_data_in),
    .data_out(simple_data_out)
  );

  type_parameterized_register #(
    .DATA_TYPE(rgb_color_t)
  ) color_reg_inst (
    .clk(clk),
    .reset_n(reset_n),
    .load_enable(load_enable),
    .data_in(color_data_in),
    .data_out(color_data_out)
  );

  type_parameterized_register #(
    .DATA_TYPE(coordinate_t)
  ) coord_reg_inst (
    .clk(clk),
    .reset_n(reset_n),
    .load_enable(load_enable),
    .data_in(coord_data_in),
    .data_out(coord_data_out)
  );

  // Test sequence
  initial begin
    // Dump waves
    $dumpfile("parameter_vs_type_testbench.vcd");
    $dumpvars(0, parameter_vs_type_testbench);
    
    $display("=== Parameter vs Type Parameterization Demo ===");
    $display();
    
    // Initialize signals
    reset_n = 0;
    load_enable = 0;
    simple_data_in = 8'h00;
    color_data_in = '{red: 8'h00, green: 8'h00, blue: 8'h00};
    coord_data_in = '{x: 16'h0000, y: 16'h0000};
    
    // Reset sequence
    repeat(3) @(posedge clk);
    reset_n = 1;
    $display("Reset released at time %0t", $time);
    
    // Demonstrate parameter differences
    repeat(10) @(posedge clk);
    $display();
    $display("Parameter-based modules running:");
    $display("  8-bit module output: 0x%02h, valid: %b", 
             param8_data_out, param8_valid);
    $display("  16-bit module output: 0x%04h, valid: %b", 
             param16_data_out, param16_valid);
    
    // Demonstrate type parameterization
    load_enable = 1;
    
    // Test simple logic type
    simple_data_in = 8'hAB;
    @(posedge clk);
    $display();
    $display("Type-based registers after loading:");
    
    // Test RGB color type
    color_data_in = '{red: 8'hFF, green: 8'h80, blue: 8'h40};
    @(posedge clk);
    
    // Test coordinate type  
    coord_data_in = '{x: 16'h1234, y: 16'h5678};
    @(posedge clk);
    
    load_enable = 0;
    @(posedge clk);
    
    $display("  Simple register (8-bit): 0x%02h", simple_data_out);
    $display("  Color register (24-bit): R=0x%02h G=0x%02h B=0x%02h", 
             color_data_out.red, color_data_out.green, color_data_out.blue);
    $display("  Coordinate register (32-bit): X=0x%04h Y=0x%04h", 
             coord_data_out.x, coord_data_out.y);
    
    $display();
    $display("Key Differences:");
    $display("- Parameters: Compile-time values (widths, sizes, constants)");
    $display("- Type parameters: Different data types, more flexible");
    $display("- Parameters affect module behavior, types affect data format");
    
    repeat(5) @(posedge clk);
    $finish;
  end

endmodule