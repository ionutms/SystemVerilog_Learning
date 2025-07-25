// handle_lifecycle_demo.sv
package lifecycle_pkg;
  
  class data_container;
    string name;
    int value;
    static int object_count = 0;
    
    function new(string obj_name = "unnamed", int obj_value = 0);
      this.name = obj_name;
      this.value = obj_value;
      object_count++;
      $display("Object created: %s (value=%0d) | Total objects: %0d", 
               name, value, object_count);
    endfunction
    
    function void cleanup();
      $display("Cleaning up object: %s (value=%0d)", name, value);
      object_count--;
      $display("Objects remaining: %0d", object_count);
    endfunction
    
    function void display_info();
      $display("Object info - Name: %s, Value: %0d", name, value);
    endfunction
    
    static function int get_object_count();
      return object_count;
    endfunction
    
  endclass
  
endpackage

module lifecycle_manager;
  import lifecycle_pkg::*;
  
  data_container handle1, handle2, handle3;
  
  initial begin
    $display("=== Object Lifecycle Demo ===");
    $display();
    
    // Phase 1: Object creation
    $display("Phase 1: Creating objects");
    handle1 = new("first_object", 100);
    handle2 = new("second_object", 200);
    
    // Phase 2: Handle assignment (shallow copy)
    $display();
    $display("Phase 2: Handle assignment");
    handle3 = handle1;  // Both handles point to same object
    $display("handle3 now points to same object as handle1");
    handle3.display_info();
    
    // Phase 3: Modify through different handle
    $display();
    $display("Phase 3: Modifying through handle3");
    handle3.value = 999;
    $display("After modification through handle3:");
    handle1.display_info();  // Shows modified value
    handle3.display_info();  // Shows same modified value
    
    // Phase 4: Handle reassignment
    $display();
    $display("Phase 4: Reassigning handle1");
    handle1 = new("third_object", 300);
    $display("handle1 now points to new object");
    handle1.display_info();
    handle3.display_info();  // Still points to original object
    
    // Phase 5: Explicit cleanup demonstration
    $display();
    $display("Phase 5: Explicit cleanup");
    handle1.cleanup();
    handle2.cleanup();
    handle3.cleanup();
    
    // Phase 6: Setting handles to null
    $display();
    $display("Phase 6: Setting handles to null");
    handle1 = null;
    handle2 = null;
    handle3 = null;
    $display("All handles set to null");
    
    $display();
    $display("Final object count: %0d", 
             data_container::get_object_count());
    $display("=== Lifecycle Demo Complete ===");
  end
  
endmodule