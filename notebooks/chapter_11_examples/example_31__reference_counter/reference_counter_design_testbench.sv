// reference_counter_design_testbench.sv
module reference_counter_testbench;
  import reference_counter_pkg::*;
  
  // Object handles for testing
  RefCountedObject obj1, obj2, obj3;
  RefCountedObject handle_a, handle_b, handle_c;
  int ref_result;  // Variable to capture return values
  
  initial begin
    // Dump waves
    $dumpfile("reference_counter_testbench.vcd");
    $dumpvars(0, reference_counter_testbench);
    
    $display("=== Reference Counter Example ===");
    $display();
    
    // Test 1: Create objects and check initial reference count
    $display("--- Test 1: Object Creation ---");
    obj1 = new("database_connection");
    obj2 = new("file_handler");
    obj3 = new("network_socket");
    $display();
    
    // Test 2: Multiple handles pointing to same object
    $display("--- Test 2: Multiple Handles ---");
    handle_a = obj1;                  // Same object, should increment ref_count
    obj1.add_reference();             // Manually add reference
    
    handle_b = obj1;                  // Another handle to same object
    obj1.add_reference();             // Manually add reference
    
    obj1.display_status();
    $display();
    
    // Test 3: Remove references
    $display("--- Test 3: Removing References ---");
    ref_result = obj1.remove_reference();     // Remove one reference
    obj1.display_status();
    
    ref_result = obj1.remove_reference();     // Remove another reference
    obj1.display_status();
    
    ref_result = obj1.remove_reference();     // Remove last reference
    obj1.display_status();
    $display();
    
    // Test 4: Try to remove reference when count is 0
    $display("--- Test 4: Over-removal Protection ---");
    ref_result = obj1.remove_reference();     // Should show warning
    obj1.display_status();
    $display();
    
    // Test 5: Different objects with different reference patterns
    $display("--- Test 5: Multiple Objects ---");
    obj2.add_reference();
    obj2.add_reference();
    obj2.display_status();
    
    obj3.display_status();            // Should still have ref_count = 1
    $display();
    
    // Test 6: Simulate garbage collection check
    $display("--- Test 6: Garbage Collection Simulation ---");
    $display("Objects that can be deleted:");
    if (obj1.can_be_deleted()) 
      $display("  - Object #%0d '%s' can be deleted", 
               obj1.object_id, obj1.object_name);
    if (obj2.can_be_deleted()) 
      $display("  - Object #%0d '%s' can be deleted", 
               obj2.object_id, obj2.object_name);
    if (obj3.can_be_deleted()) 
      $display("  - Object #%0d '%s' can be deleted", 
               obj3.object_id, obj3.object_name);
    $display();
    
    // Test 7: Clean up remaining references
    $display("--- Test 7: Final Cleanup ---");
    while (obj2.get_ref_count() > 0) begin
      ref_result = obj2.remove_reference();
    end
    
    while (obj3.get_ref_count() > 0) begin
      ref_result = obj3.remove_reference();
    end
    
    $display();
    $display("=== Reference Counter Test Complete ===");
    
    #10 $finish;
  end
  
  // Instantiate design under test
  reference_counter_design DESIGN_INSTANCE();

endmodule : reference_counter_testbench