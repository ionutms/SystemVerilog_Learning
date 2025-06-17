// conditional_example_testbench.sv
module conditional_test_bench;  // Testbench module
  conditional_example CONDITIONAL_INSTANCE();  // Instantiate design under test

  initial begin
    // Dump waves
    $dumpfile("conditional_test_bench.vcd");     // Specify the VCD file
    $dumpvars(0, conditional_test_bench);        // Dump all variables in the test module
    #1;                                          // Wait for a time unit
    $display("Hello from conditional testbench!"); // Display message
    $display();                                  // Display empty line
  end

endmodule