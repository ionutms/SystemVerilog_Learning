// bitwise_example_testbench.sv
module bitwise_example_testbench;  // Testbench module
  bitwise_example DESIGN_INSTANCE();  // Instantiate design under test

  initial begin
    // Dump waves
    $dumpfile("bitwise_example_testbench.vcd");       // Specify the VCD file
    $dumpvars(0, bitwise_example_testbench);          // Dump all variables in the test module
    #1;                                                       // Wait for a time unit
    $display();                                               // Display empty line
    $display("Hello from logical bitwise testbench!");       // Display message
    $display("Testing logical and bitwise operations...");
    $display();                                               // Display empty line
    
    // Wait for design to complete its operations
    #10;
    $display();
    
    // End simulation
    $finish;
  end

endmodule