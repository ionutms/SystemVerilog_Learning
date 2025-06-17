// reduction_testbench.sv
module reduction_testbench;  // Testbench module
  reduction DESIGN_INSTANCE();  // Instantiate design under test
  
  // Variable for verification
  logic [7:0] original_data = 8'b11010010;

  initial begin
    // Dump waves
    $dumpfile("reduction_testbench.vcd");       // Specify the VCD file
    $dumpvars(0, reduction_testbench);          // Dump all variables in the test module
    
    // Wait for design to complete its operations
    #20;  // Longer wait since we have multiple test patterns
    
    // End simulation
    $finish;
  end

endmodule