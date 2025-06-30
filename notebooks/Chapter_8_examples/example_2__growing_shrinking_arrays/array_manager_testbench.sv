// array_manager_testbench.sv
module array_manager_testbench;      // Testbench for dynamic array operations
  
  // Instantiate the array manager
  array_manager ARRAY_MANAGER_INSTANCE();
  
  initial begin
    // Dump waves
    $dumpfile("array_manager_testbench.vcd");
    $dumpvars(0, array_manager_testbench);
    
    $display("=== Dynamic Array Growing and Shrinking Demo ===");
    $display();
    
    // Test 1: Start with empty array
    $display("Test 1: Starting with empty array");
    ARRAY_MANAGER_INSTANCE.display_array_contents();
    $display();
    
    // Test 2: Grow array to size 5 and fill with value 10
    $display("Test 2: Growing array to size 5");
    ARRAY_MANAGER_INSTANCE.grow_data_array(5, 10);
    ARRAY_MANAGER_INSTANCE.display_array_contents();
    $display();
    
    // Test 3: Grow array further to size 8 and fill with value 20
    $display("Test 3: Growing array to size 8");
    ARRAY_MANAGER_INSTANCE.grow_data_array(8, 20);
    ARRAY_MANAGER_INSTANCE.display_array_contents();
    $display();
    
    // Test 4: Shrink array to size 6
    $display("Test 4: Shrinking array to size 6");
    ARRAY_MANAGER_INSTANCE.shrink_data_array(6);
    ARRAY_MANAGER_INSTANCE.display_array_contents();
    $display();
    
    // Test 5: Try to shrink to larger size (should fail)
    $display("Test 5: Attempting to 'shrink' to size 10");
    ARRAY_MANAGER_INSTANCE.shrink_data_array(10);
    ARRAY_MANAGER_INSTANCE.display_array_contents();
    $display();
    
    // Test 6: Shrink to size 2
    $display("Test 6: Shrinking array to size 2");
    ARRAY_MANAGER_INSTANCE.shrink_data_array(2);
    ARRAY_MANAGER_INSTANCE.display_array_contents();
    $display();
    
    // Test 7: Demonstrate string array management
    $display("Test 7: String array growing and shrinking");
    ARRAY_MANAGER_INSTANCE.manage_name_list();
    $display();
    
    #1;  // Wait for a time unit
    $display("=== Array Management Demo Complete ===");
    
  end

endmodule