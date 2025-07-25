// object_registry_system_testbench.sv
module object_registry_testbench;
  import object_registry_pkg::*;
  
  // Instantiate design under test
  object_registry_system DESIGN_INSTANCE_NAME();
  
  initial begin
    // Dump waves
    $dumpfile("object_registry_testbench.vcd");
    $dumpvars(0, object_registry_testbench);
    
    $display("\n=== Object Registry System Test ===\n");
    
    // Test the registry system
    test_object_registry();
    
    $display("\n=== Test Complete ===\n");
    $finish;
  end
  
  task test_object_registry();
    object_registry registry;
    managed_object base_obj1, base_obj2;
    transaction_object trans_obj1, trans_obj2;
    int handle1, handle2, handle3, handle4;
    managed_object retrieved_obj;
    
    $display("--- Testing Object Registry ---");
    
    // Get registry instance (singleton)
    registry = object_registry::get_instance();
    
    // Create some objects
    base_obj1 = new("base_object_1");
    base_obj2 = new("base_object_2");
    trans_obj1 = new("transaction_1", 100);
    trans_obj2 = new("transaction_2", 250);
    
    $display("\n1. Registering objects...");
    
    // Register objects and get handles
    handle1 = registry.register_object(base_obj1);
    handle2 = registry.register_object(base_obj2);
    handle3 = registry.register_object(trans_obj1);
    handle4 = registry.register_object(trans_obj2);
    
    $display("\n2. Registry status after registration:");
    registry.list_objects();
    
    $display("\n3. Testing object lookup...");
    
    // Test lookups
    retrieved_obj = registry.lookup_object(handle1);
    retrieved_obj = registry.lookup_object(handle3);
    
    // Test invalid lookup
    retrieved_obj = registry.lookup_object(999);
    
    $display("\n4. Testing transaction object functionality...");
    
    // Access transaction-specific methods
    retrieved_obj = registry.lookup_object(handle3);
    if (retrieved_obj != null) begin
      transaction_object trans;
      if ($cast(trans, retrieved_obj)) begin
        $display("[TEST] Transaction value: %0d", trans.get_value());
        trans.set_value(500);
        $display("[TEST] Updated transaction value: %0d", trans.get_value());
      end
    end
    
    $display("\n5. Testing object unregistration...");
    
    // Remove one object
    if (registry.unregister_object(handle2)) begin
      $display("[TEST] Successfully unregistered object with handle %0d", 
               handle2);
    end
    
    // Try to lookup removed object
    retrieved_obj = registry.lookup_object(handle2);
    
    $display("\n6. Registry status after partial cleanup:");
    registry.list_objects();
    
    $display("\n7. Testing complete cleanup...");
    registry.cleanup_all();
    
    $display("\n8. Final registry status:");
    registry.list_objects();
    
    $display("\n9. Testing singleton behavior...");
    begin
      object_registry registry2;
      registry2 = object_registry::get_instance();
      if (registry === registry2) begin
        $display("[TEST] ✓ Singleton pattern working correctly");
      end else begin
        $display("[TEST] ✗ Singleton pattern failed");
      end
    end
    
  endtask
  
endmodule