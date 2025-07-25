// handle_comparison_demo_testbench.sv
module handle_comparison_testbench;
  
  // Instantiate the design under test
  handle_comparison_demo DESIGN_INSTANCE();
  
  initial begin
    // Dump waves for analysis
    $dumpfile("handle_comparison_testbench.vcd");
    $dumpvars(0, handle_comparison_testbench);
    
    // Wait for design to complete
    #10;
    
    $display();
    $display("=== Testbench Summary ===");
    $display("Demonstrated:");
    $display("- Handle equality (==) compares object references");
    $display("- Content comparison requires custom methods");
    $display("- Multiple handles can point to same object");
    $display("- Null handle comparisons");
    $display();
    
    $finish;
  end
  
endmodule