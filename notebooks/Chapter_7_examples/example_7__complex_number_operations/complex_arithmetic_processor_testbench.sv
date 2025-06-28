// complex_arithmetic_processor_testbench.sv
module complex_arithmetic_testbench;

  // Instantiate the design under test
  complex_arithmetic_processor complex_processor_instance();

  initial begin
    // Configure wave dumping for analysis
    $dumpfile("complex_arithmetic_testbench.vcd");
    $dumpvars(0, complex_arithmetic_testbench);
    
    #1;  // Allow design to execute
    
    $display("Testbench: Complex arithmetic operations completed");
    $display("Testbench: Check VCD file for signal analysis");
    $display();
    
    $finish;  // End simulation
  end

endmodule