// basic_memory_interface_testbench.sv
module basic_memory_interface_testbench;
  
  // Instantiate design under test
  basic_memory_interface DESIGN_INSTANCE_NAME();
  
  initial begin
    // Dump waves
    $dumpfile("basic_memory_interface_testbench.vcd");
    $dumpvars(0, basic_memory_interface_testbench);
    
    $display("Testbench: Starting memory interface simulation");
    $display();
    
    // Wait for design to complete
    #150;
    
    $display();
    $display("Testbench: Memory interface simulation complete");
    $display();
    
    $finish;
  end
  
endmodule