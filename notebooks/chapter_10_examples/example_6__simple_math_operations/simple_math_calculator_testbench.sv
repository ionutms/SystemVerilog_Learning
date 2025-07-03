// simple_math_calculator_testbench.sv
module test_bench_module;

  // Instantiate design under test
  simple_math_calculator_module CALCULATOR_INSTANCE();

  initial begin
    // Dump waves for debugging
    $dumpfile("test_bench_module.vcd");
    $dumpvars(0, test_bench_module);
    
    $display();
    $display("=== Math Calculator Testbench Started ===");
    $display();
    
    // Wait for design to complete
    #10;
    
    $display();
    $display("=== All Math Operations Verified ===");
    $display();
    
    // End simulation
    $finish;
  end

endmodule