// precedence_example_testbench.sv
module precedence_test_bench;  // Testbench module
  precedence_example PRECEDENCE_INSTANCE();  // Instantiate design under test

  initial begin
    // Dump waves
    $dumpfile("precedence_test_bench.vcd");     // Specify the VCD file
    $dumpvars(0, precedence_test_bench);        // Dump all variables in the test module
    #1;                                         // Wait for a time unit
    $display("Hello from precedence testbench!"); // Display message
    $display();                                 // Display empty line
  end

endmodule