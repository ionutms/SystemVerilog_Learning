// basic_handle_demo.sv
package handle_demo_pkg;

  // Simple class to demonstrate handle behavior
  class BasicObject;
    string name;
    int value;
    
    // Constructor
    function new(string obj_name = "unnamed", int obj_value = 0);
      this.name = obj_name;
      this.value = obj_value;
    endfunction
    
    // Method to display object contents
    function void display();
      $display("Object: %s, Value: %d", name, value);
    endfunction
    
    // Method to modify object
    function void set_value(int new_value);
      this.value = new_value;
      $display("Modified %s to value: %d", name, new_value);
    endfunction
    
  endclass : BasicObject

endpackage : handle_demo_pkg

module basic_handle_demo_module();
  import handle_demo_pkg::*;
  
  initial begin
    BasicObject original_handle;
    BasicObject copied_handle;
    
    $display("=== Basic Handle Demo ===");
    $display();
    
    // Create an object
    original_handle = new("original_obj", 42);
    $display("Created original object:");
    original_handle.display();
    $display();
    
    // Handle assignment (both handles point to same object)
    copied_handle = original_handle;
    $display("After handle assignment (copied_handle = original_handle):");
    $display("Original handle points to:");
    original_handle.display();
    $display("Copied handle points to:");
    copied_handle.display();
    $display();
    
    // Modify through one handle
    $display("Modifying object through copied_handle:");
    copied_handle.set_value(99);
    $display();
    
    // Check both handles - they show the same change
    $display("After modification, both handles show same object:");
    $display("Original handle:");
    original_handle.display();
    $display("Copied handle:");
    copied_handle.display();
    $display();
    
    // Demonstrate that both handles reference the same object
    $display("Proof both handles point to same object:");
    $display("original_handle.name: %s", original_handle.name);
    $display("copied_handle.name: %s", copied_handle.name);
    $display("Are they the same object? %s", 
             (original_handle === copied_handle) ? "YES" : "NO");
    
  end

endmodule : basic_handle_demo_module