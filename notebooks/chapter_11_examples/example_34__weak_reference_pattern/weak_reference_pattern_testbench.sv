// weak_reference_pattern_testbench.sv
module weak_reference_test_bench;
  import weak_reference_pkg::*;
  
  // Instantiate design under test
  weak_reference_design DUT();
  
  initial begin
    // Dump waves
    $dumpfile("weak_reference_test_bench.vcd");
    $dumpvars(0, weak_reference_test_bench);
    
    $display("[%0t] Starting Weak Reference Pattern Test", $time);
    $display("=============================================");
    
    // Test 1: Basic weak reference usage
    test_basic_weak_reference();
    
    #10;
    
    // Test 2: Object cleanup simulation
    test_object_cleanup_scenario();
    
    #10;
    
    // Test 3: Multiple weak references
    test_multiple_weak_references();
    
    $display("\n[%0t] All weak reference tests completed", $time);
    $finish;
  end
  
  // Test basic weak reference functionality
  task test_basic_weak_reference();
    target_object obj;
    weak_reference #(target_object) weak_ref;
    target_object retrieved_obj;
    
    $display("\n--- Test 1: Basic Weak Reference ---");
    
    // Create object and weak reference
    obj = new("primary_object", 100);
    weak_ref = new();
    
    // Set weak reference to point to object
    weak_ref.set_reference(obj);
    
    // Access object through weak reference
    retrieved_obj = weak_ref.get_reference();
    if (retrieved_obj != null) begin
      retrieved_obj.print_info();
      retrieved_obj.set_value(200);
    end
    
    $display("Basic weak reference test completed");
  endtask
  
  // Test object cleanup scenario
  task test_object_cleanup_scenario();
    target_object obj;
    weak_reference #(target_object) weak_ref;
    target_object retrieved_obj;
    
    $display("\n--- Test 2: Object Cleanup Scenario ---");
    
    // Create object and weak reference
    obj = new("cleanup_object", 300);
    weak_ref = new();
    weak_ref.set_reference(obj);
    
    // Simulate object being cleaned up (manual invalidation)
    $display("[%0t] Simulating object cleanup...", $time);
    weak_ref.invalidate();
    
    // Try to access object after cleanup
    retrieved_obj = weak_ref.get_reference();
    if (retrieved_obj == null) begin
      $display("[%0t] Correctly detected invalid reference", $time);
    end
    
    $display("Object cleanup scenario test completed");
  endtask
  
  // Test multiple weak references to same object
  task test_multiple_weak_references();
    target_object shared_obj;
    weak_reference #(target_object) weak_ref1, weak_ref2;
    target_object retrieved_obj1, retrieved_obj2;
    
    $display("\n--- Test 3: Multiple Weak References ---");
    
    // Create shared object
    shared_obj = new("shared_object", 400);
    
    // Create multiple weak references
    weak_ref1 = new();
    weak_ref2 = new();
    
    weak_ref1.set_reference(shared_obj);
    weak_ref2.set_reference(shared_obj);
    
    // Access through both references
    retrieved_obj1 = weak_ref1.get_reference();
    retrieved_obj2 = weak_ref2.get_reference();
    
    if (retrieved_obj1 != null && retrieved_obj2 != null) begin
      $display("[%0t] Both weak references are valid", $time);
      retrieved_obj1.set_value(500);
      retrieved_obj2.print_info(); // Should show updated value
    end
    
    // Invalidate one reference
    weak_ref1.invalidate();
    
    // Check status of both references
    if (weak_ref1.get_reference() == null) begin
      $display("[%0t] First weak reference is now invalid", $time);
    end
    
    if (weak_ref2.get_reference() != null) begin
      $display("[%0t] Second weak reference is still valid", $time);
    end
    
    $display("Multiple weak references test completed");
  endtask

endmodule