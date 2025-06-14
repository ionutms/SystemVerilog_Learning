// arithmetic_example_testbench.sv
module arithmetic_example_testbench;  // Testbench module
  arithmetic_example DESIGN_INSTANCE();  // Instantiate design under test

  initial begin
    // Dump waves
    $dumpfile("arithmetic_example_testbench.vcd");       // Specify the VCD file
    $dumpvars(0, arithmetic_example_testbench);          // Dump all variables in the test module
    // Wait for design to complete its operations
    #20;
    // End simulation
    $finish;
  end

endmodule