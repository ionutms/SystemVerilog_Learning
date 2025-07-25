// handle_lifecycle_demo_testbench.sv
module lifecycle_test_bench;
  
  lifecycle_manager LIFECYCLE_DEMO_INSTANCE();
  
  initial begin
    // Dump waves for analysis
    $dumpfile("lifecycle_test_bench.vcd");
    $dumpvars(0, lifecycle_test_bench);
    
    // Wait for lifecycle demo to complete
    #100;
    
    $display();
    $display("Testbench: Lifecycle demonstration completed");
    $display();
    
    $finish;
  end
  
endmodule