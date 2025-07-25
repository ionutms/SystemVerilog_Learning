// handle_validation_utilities.sv

// Package containing handle validation utilities and classes
package handle_validation_pkg;

  // Base class for demonstrating handle validation
  class data_object;
    rand int data_value;
    int object_id;
    static int next_id = 1;
    
    function new();
      this.object_id = next_id++;
      this.data_value = $urandom_range(1, 100);
    endfunction
    
    function void display();
      $display("Object ID: %0d, Data: %0d", object_id, data_value);
    endfunction
  endclass

  // Handle validation utilities class
  class handle_validator;
    
    // Check if handle is valid (not null)
    static function bit is_valid_handle(data_object obj_handle);
      return (obj_handle != null);
    endfunction
    
    // Safe handle access with validation
    static function bit safe_access(data_object obj_handle, 
                                   output int value);
      if (obj_handle == null) begin
        $display("ERROR: Attempting to access null handle!");
        value = -1;
        return 0;
      end
      value = obj_handle.data_value;
      return 1;
    endfunction
    
    // Detect dangling reference by checking object validity
    static function bit is_dangling_reference(data_object obj_handle);
      // In SystemVerilog, we can't truly detect freed memory,
      // but we can check for null handles
      return (obj_handle == null);
    endfunction
    
    // Safe handle assignment with validation
    static function bit safe_assign(ref data_object dest_handle,
                                   data_object src_handle);
      if (src_handle == null) begin
        $display("WARNING: Assigning null handle!");
        dest_handle = null;
        return 0;
      end
      dest_handle = src_handle;
      $display("Handle assigned successfully to Object ID: %0d", 
               src_handle.object_id);
      return 1;
    endfunction
    
    // Validate handle before method call
    static function bit validate_before_call(data_object obj_handle,
                                            string method_name);
      if (obj_handle == null) begin
        $display("ERROR: Cannot call %s on null handle!", method_name);
        return 0;
      end
      $display("Validation passed for %s on Object ID: %0d", 
               method_name, obj_handle.object_id);
      return 1;
    endfunction
    
  endclass

endpackage

// Design module demonstrating handle validation utilities
module handle_validation_utilities;
  import handle_validation_pkg::*;
  
  // Handles for testing
  data_object obj1, obj2, obj3;
  int retrieved_value;
  bit success;
  
  initial begin
    $display("=== Handle Validation Utilities Demo ===");
    $display();
    
    // Test 1: Valid handle creation and validation
    $display("--- Test 1: Valid Handle Operations ---");
    obj1 = new();
    obj1.display();
    
    if (handle_validator::is_valid_handle(obj1))
      $display("Handle obj1 is valid");
    else
      $display("Handle obj1 is invalid");
    
    // Test 2: Safe access with valid handle
    $display("\n--- Test 2: Safe Access Operations ---");
    success = handle_validator::safe_access(obj1, retrieved_value);
    if (success)
      $display("Safe access successful, value: %0d", retrieved_value);
    
    // Test 3: Null handle validation
    $display("\n--- Test 3: Null Handle Validation ---");
    if (!handle_validator::is_valid_handle(obj2))
      $display("Handle obj2 is null (invalid)");
    
    // Test 4: Safe access with null handle
    success = handle_validator::safe_access(obj2, retrieved_value);
    if (!success)
      $display("Safe access failed on null handle");
    
    // Test 5: Safe handle assignment
    $display("\n--- Test 4: Safe Handle Assignment ---");
    obj3 = new();
    success = handle_validator::safe_assign(obj2, obj3);
    
    // Test 6: Validation before method call
    $display("\n--- Test 5: Method Call Validation ---");
    if (handle_validator::validate_before_call(obj2, "display"))
      obj2.display();
    
    // Test 7: Dangling reference detection
    $display("\n--- Test 6: Dangling Reference Detection ---");
    obj1 = null;  // Simulate handle becoming null
    if (handle_validator::is_dangling_reference(obj1))
      $display("Detected dangling reference in obj1");
    
    $display();
    $display("=== Handle Validation Demo Complete ===");
  end
  
endmodule