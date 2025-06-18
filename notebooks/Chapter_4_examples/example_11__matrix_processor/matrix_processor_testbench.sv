// matrix_processor_testbench.sv
module matrix_processor_testbench;  // Testbench module
  matrix_processor MATRIX_DUT();    // Instantiate matrix processor design under test

  initial begin
    // Dump waves
    $dumpfile("matrix_processor_testbench.vcd");    // Specify the VCD file
    $dumpvars(0, matrix_processor_testbench);       // Dump all variables in the test module
    #1;                                             // Wait for a time unit

    $display("Testbench: Starting matrix processor validation...");
    $display();                                     // Display empty line
    
    // Wait for design to complete
    #10;
    
    $display("Testbench: Matrix processor validation completed!");
  end

endmodule