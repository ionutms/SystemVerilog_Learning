// handle_validation_utilities_testbench.sv

module handle_validation_testbench;
  import handle_validation_pkg::*;
  
  // Test handles and variables
  data_object test_obj1, test_obj2, test_obj3, test_obj4;
  int value;
  bit result;
  
  // Instantiate design under test
  handle_validation_utilities DUT();
  
  initial begin
    // Dump waves for simulation
    $dumpfile("handle_validation_testbench.vcd");
    $dumpvars(0, handle_validation_testbench);
    
    #1; // Wait for initial block to complete
    
    $display("\n=== Testbench: Advanced Handle Validation Tests ===");
    $display();
    
    // Test Case 1: Multiple handle validation
    $display("--- TC1: Multiple Handle Validation ---");
    test_obj1 = new();
    test_obj2 = new();
    test_obj3 = null;
    
    $display("Testing multiple handles:");
    $display("  obj1 valid: %0b", 
             handle_validator::is_valid_handle(test_obj1));
    $display("  obj2 valid: %0b", 
             handle_validator::is_valid_handle(test_obj2));
    $display("  obj3 valid: %0b", 
             handle_validator::is_valid_handle(test_obj3));
    
    // Test Case 2: Safe assignment chain
    $display("\n--- TC2: Safe Assignment Chain ---");
    $display("Chaining safe assignments:");
    result = handle_validator::safe_assign(test_obj4, test_obj1);
    $display("Assignment 1 result: %0b", result);
    
    result = handle_validator::safe_assign(test_obj3, test_obj4);
    $display("Assignment 2 result: %0b", result);
    
    // Test Case 3: Batch handle validation
    $display("\n--- TC3: Batch Validation Test ---");
    test_obj1 = null;  // Make first handle null
    
    // Test multiple handles individually
    $display("Handle test_obj1 valid: %0b", 
             handle_validator::is_valid_handle(test_obj1));
    $display("Handle test_obj2 valid: %0b", 
             handle_validator::is_valid_handle(test_obj2));
    $display("Handle test_obj3 valid: %0b", 
             handle_validator::is_valid_handle(test_obj3));
    
    test_obj4 = new();
    $display("Handle test_obj4 valid: %0b", 
             handle_validator::is_valid_handle(test_obj4));
    
    // Test Case 4: Method validation stress test
    $display("\n--- TC4: Method Validation Stress Test ---");
    
    // Test different method names
    result = handle_validator::validate_before_call(test_obj2, "display");
    if (result) test_obj2.display();
    
    result = handle_validator::validate_before_call(test_obj2, "randomize");
    $display("Randomize validation result: %0b", result);
    
    result = handle_validator::validate_before_call(test_obj2, "get_data");
    $display("Get_data validation result: %0b", result);
    
    // Test Case 5: Error recovery test
    $display("\n--- TC5: Error Recovery Test ---");
    test_obj2 = null;
    
    $display("Attempting operations on null handle:");
    result = handle_validator::safe_access(test_obj2, value);
    $display("Safe access recovery: %0b", result);
    
    result = handle_validator::validate_before_call(test_obj2, "display");
    $display("Method validation recovery: %0b", result);
    
    #10; // Additional delay
    
    $display();
    $display("=== All Testbench Validation Tests Complete ===");
    $display();
    
    $finish;
  end
  
endmodule