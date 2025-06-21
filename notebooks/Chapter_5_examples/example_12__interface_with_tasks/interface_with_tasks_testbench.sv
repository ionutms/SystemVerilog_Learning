// interface_with_tasks_testbench.sv
module interface_with_tasks_testbench;
  
  // Instantiate design under test
  interface_with_tasks DESIGN_INSTANCE_NAME();
  
  initial begin
    // Dump waves
    $dumpfile("interface_with_tasks_testbench.vcd");
    $dumpvars(0, interface_with_tasks_testbench);
    
    $display("Testbench: Starting interface with tasks simulation");
    $display();
    
    // Wait for design to complete
    #250;
    
    $display();
    $display("Testbench: Interface with tasks simulation complete");
    $display();
    
    $finish;
  end
  
endmodule