// smart_pointer_manager_testbench.sv
module smart_pointer_testbench;
  import smart_pointer_pkg::*;
  
  // Test smart pointer functionality
  smart_pointer test_ptr1, test_ptr2, test_ptr3, test_ptr4;
  managed_data test_data1, test_data2;
  
  // Instantiate design under test
  smart_pointer_manager DUT();
  
  initial begin
    // Dump waves
    $dumpfile("smart_pointer_testbench.vcd");
    $dumpvars(0, smart_pointer_testbench);
    
    #10;
    $display("\n=== Testbench: Advanced Smart Pointer Tests ===");
    
    // Test 1: Multiple pointers to same data
    $display("\n--- Test 1: Multiple References ---");
    test_data1 = new("test_object_1", 255);
    test_ptr1 = new(test_data1);
    test_ptr2 = new(test_data1);
    test_ptr3 = new(test_data1);
    
    $display("Created 3 pointers to same data:");
    $display("Ref count should be 3: %0d", test_ptr1.get_ref_count());
    
    // Test 2: Independent data objects
    $display("\n--- Test 2: Independent Objects ---");
    test_data2 = new("test_object_2", 128);
    test_ptr4 = new(test_data2);
    
    $display("Independent pointer ref count: %0d", test_ptr4.get_ref_count());
    
    // Test 3: Sequential cleanup
    $display("\n--- Test 3: Sequential Cleanup ---");
    test_ptr1.decrement_ref();
    $display("After first cleanup, ref count: %0d", 
             test_ptr2.get_ref_count());
    
    test_ptr2.decrement_ref();
    $display("After second cleanup, ref count: %0d", 
             test_ptr3.get_ref_count());
    
    test_ptr3.decrement_ref();  // Should trigger final cleanup
    $display("After final cleanup, validity: %0b", test_ptr3.is_valid());
    
    // Test 4: Cleanup independent object
    $display("\n--- Test 4: Independent Object Cleanup ---");
    test_ptr4.decrement_ref();
    $display("Independent object validity after cleanup: %0b", 
             test_ptr4.is_valid());
    
    // Test 5: Error handling - null data
    $display("\n--- Test 5: Error Handling ---");
    begin
      smart_pointer error_ptr;
      managed_data null_data = null;
      $display("Attempting to create smart pointer with null data...");
      error_ptr = new(null_data);  // Should generate error
      if (error_ptr != null) begin
        $display("Error pointer validity: %0b", error_ptr.is_valid());
        $display("Error pointer ref count: %0d", error_ptr.get_ref_count());
      end else begin
        $display("Smart pointer creation failed as expected");
      end
    end
    
    #10;
    $display("\n=== All Tests Complete ===");
    $finish;
  end
  
  // Monitor for educational purposes
  initial begin
    $monitor("[%0t] Monitoring smart pointer operations", $time);
  end
  
endmodule