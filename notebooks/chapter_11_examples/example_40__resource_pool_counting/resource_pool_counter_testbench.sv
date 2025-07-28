// resource_pool_counter_testbench.sv
module resource_pool_counter_testbench;
  import resource_pool_pkg::*;
  
  resource_pool test_pool;
  managed_resource resources[4];
  
  initial begin
    // Dump waves
    $dumpfile("resource_pool_counter_testbench.vcd");
    $dumpvars(0, resource_pool_counter_testbench);
    
    $display("=== Resource Pool Counter Testbench ===\n");
    
    // Test 1: Pool creation and basic allocation
    $display("TEST 1: Pool Creation and Basic Allocation");
    test_pool = new(2);
    
    resources[0] = test_pool.get_resource();
    resources[1] = test_pool.get_resource();
    
    // Pool should be empty now
    resources[2] = test_pool.get_resource();
    test_pool.show_pool_status();
    
    // Test 2: Reference counting behavior
    $display("\nTEST 2: Reference Counting");
    if (resources[0] != null) begin
      // Add multiple references
      resources[0].acquire();
      resources[0].acquire();
      test_pool.show_pool_status();
      
      // Release one by one
      resources[0].release_ref();
      resources[0].release_ref();
      test_pool.return_resource(resources[0]);
    end
    
    // Test 3: Proper resource return and reuse
    $display("\nTEST 3: Resource Reuse");
    test_pool.return_resource(resources[1]);
    test_pool.show_pool_status();
    
    // Should be able to get resource again
    resources[3] = test_pool.get_resource();
    if (resources[3] != null) begin
      $display("Successfully reacquired resource ID: %0d", 
               resources[3].resource_id);
    end
    
    // Test 4: Edge cases
    $display("\nTEST 4: Edge Cases");
    // Try to release resource with zero refs
    if (resources[3] != null) begin
      resources[3].release_ref();  // Should warn
    end
    
    // Clean up
    test_pool.return_resource(resources[3]);
    test_pool.show_pool_status();
    
    #10;  // Wait before finish
    $display("\n=== All Tests Complete ===");
    $finish;
  end
  
  // Instantiate the design module
  resource_pool_counter_design design_inst();

endmodule