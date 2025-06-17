// precedence_testbench.sv
module precedence_testbench;  // Testbench module
  precedence PRECEDENCE_INSTANCE();  // Instantiate design under test

  initial begin
    // Dump waves
    $dumpfile("precedence_testbench.vcd");     // Specify the VCD file
    $dumpvars(0, precedence_testbench);        // Dump all variables in the test module
    #1;                                         // Wait for a time unit
    $display("Hello from precedence testbench!"); // Display message
    $display();                                 // Display empty line
  end

endmodule