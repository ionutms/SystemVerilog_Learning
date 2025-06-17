// conditional_testbench.sv
module conditional_testbench;  // Testbench module
  conditional CONDITIONAL_INSTANCE();  // Instantiate design under test

  initial begin
    // Dump waves
    $dumpfile("conditional_testbench.vcd");     // Specify the VCD file
    $dumpvars(0, conditional_testbench);        // Dump all variables in the test module
    #1;                                          // Wait for a time unit
    $display("Hello from conditional testbench!"); // Display message
    $display();                                  // Display empty line
  end

endmodule