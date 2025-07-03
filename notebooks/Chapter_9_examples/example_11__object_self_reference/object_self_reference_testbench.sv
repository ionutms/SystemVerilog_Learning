// object_self_reference_testbench.sv
// Testbench for object self-reference example

module test_bench_module;
  
  // Instantiate design under test
  design_module_name DESIGN_INSTANCE_NAME();
  
  initial begin
    // Dump waves
    $dumpfile("test_bench_module.vcd");
    $dumpvars(0, test_bench_module);
    
    #1;  // Wait for a time unit
    
    $display("=== Testbench Additional Tests ===");
    $display();
    
    // Additional test to verify self-reference behavior
    begin
      ConfigBuilder test_cfg;
      ConfigBuilder returned_ref;
      
      test_cfg = new("test_reference");
      $display("Testing self-reference return:");
      test_cfg.display_config();
      $display();
      
      // Call method and capture returned reference
      returned_ref = test_cfg.set_timeout(999);
      
      // Verify that returned reference points to same object
      $display("Original object after method call:");
      test_cfg.display_config();
      $display();
      
      $display("Returned reference object:");
      returned_ref.display_config();
      $display();
      
      // Modify through returned reference
      void'(returned_ref.set_debug(1));  // Explicit void cast
      $display("Original object after modifying through returned reference:");
      test_cfg.display_config();
      $display();
      
    end
    
    $display("Hello from testbench!");
    $display();
    
  end
  
endmodule