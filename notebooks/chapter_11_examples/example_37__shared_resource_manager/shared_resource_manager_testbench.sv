// shared_resource_manager_testbench.sv
module shared_resource_manager_testbench;
  import shared_resource_pkg::*;
  
  shared_resource_manager_design dut();
  shared_resource_manager mgr;
  shared_resource res1, res2, res3;
  
  initial begin
    // Dump waves
    $dumpfile("shared_resource_manager_testbench.vcd");
    $dumpvars(0, shared_resource_manager_testbench);
    
    $display("=== Shared Resource Manager Test ===");
    $display();
    
    // Get manager instance (singleton)
    mgr = shared_resource_manager::get_instance();
    
    // Test 1: Create resources and add references
    $display("--- Test 1: Creating resources and adding references ---");
    mgr.add_reference();  // First client
    mgr.add_reference();  // Second client
    
    res1 = new("database_connection");
    res2 = new("file_handle");
    res3 = new("network_socket");
    
    mgr.add_resource(res1);
    mgr.add_resource(res2);
    mgr.add_resource(res3);
    
    #10;
    
    // Test 2: Use resources
    $display("--- Test 2: Using resources ---");
    for (int i = 0; i < mgr.get_resource_count(); i++) begin
      shared_resource temp_res = mgr.get_resource(i);
      if (temp_res != null) begin
        temp_res.use_resource();
      end
    end
    
    #10;
    
    // Test 3: Remove references (first client done)
    $display("--- Test 3: First client done ---");
    mgr.remove_reference();
    $display("Resources still active: %0d", mgr.get_resource_count());
    
    #10;
    
    // Test 4: Remove last reference (auto cleanup)
    $display("--- Test 4: Last client done (auto cleanup) ---");
    mgr.remove_reference();
    $display("Resources after cleanup: %0d", mgr.get_resource_count());
    
    #10;
    
    // Test 5: Test with new resources after cleanup
    $display("--- Test 5: New resources after cleanup ---");
    mgr.add_reference();
    begin
      shared_resource res4 = new("cache_memory");
      mgr.add_resource(res4);
      res4.use_resource();
    end
    
    #5;
    mgr.remove_reference();  // Auto cleanup again
    
    #10;
    $display();
    $display("=== Test Complete ===");
    $finish;
  end
  
endmodule