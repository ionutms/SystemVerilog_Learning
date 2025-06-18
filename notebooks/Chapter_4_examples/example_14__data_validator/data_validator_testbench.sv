// data_validator_testbench.sv
module data_validator_testbench;  // Testbench module
  data_validator DATA_VAL_DUT();  // Instantiate data validator design under test

  initial begin
    // Dump waves
    $dumpfile("data_validator_testbench.vcd");      // Specify the VCD file
    $dumpvars(0, data_validator_testbench);         // Dump all variables in the test module
    #1;                                             // Wait for a time unit

    $display();                                     // Display empty line
    $display("Testbench: Starting data validator verification...");
    $display();                                     // Display empty line
    
    // Wait for design to complete processing
    #100;
    
    $display("Testbench: Data validator verification completed!");
    $display("Testbench: Check output for validation results and statistics.");
    $display();                                     // Display empty line
  end

endmodule