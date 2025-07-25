// reference_counter_design.sv
package reference_counter_pkg;
  
  // Simple class with reference counting functionality
  class RefCountedObject;
    static int total_objects = 0;     // Track total objects created
    int ref_count;                    // Reference counter for this object
    int object_id;                    // Unique identifier for this object
    string object_name;               // Name of the object
    
    // Constructor
    function new(string name = "unnamed_object");
      this.ref_count = 1;             // Start with one reference
      this.object_name = name;
      this.object_id = ++total_objects;
      $display("[%0t] Created object #%0d '%s' with ref_count=%0d", 
               $time, object_id, object_name, ref_count);
    endfunction
    
    // Add a reference (increment counter)
    function void add_reference();
      ref_count++;
      $display("[%0t] Added reference to object #%0d '%s': ref_count=%0d", 
               $time, object_id, object_name, ref_count);
    endfunction
    
    // Remove a reference (decrement counter)
    function int remove_reference();
      if (ref_count > 0) begin
        ref_count--;
        $display("[%0t] Removed reference from object #%0d '%s': ref_count=%0d", 
                 $time, object_id, object_name, ref_count);
      end else begin
        $display("[%0t] WARNING: Trying to remove reference from object #%0d '%s' with ref_count=0", 
                 $time, object_id, object_name);
      end
      return ref_count;
    endfunction
    
    // Get current reference count
    function int get_ref_count();
      return ref_count;
    endfunction
    
    // Check if object can be deleted (ref_count == 0)
    function bit can_be_deleted();
      return (ref_count == 0);
    endfunction
    
    // Display object status
    function void display_status();
      $display("[%0t] Object #%0d '%s': ref_count=%0d, can_delete=%b", 
               $time, object_id, object_name, ref_count, can_be_deleted());
    endfunction
    
  endclass : RefCountedObject
  
endpackage : reference_counter_pkg

module reference_counter_design;
  // Empty design module - all functionality is in the package
  initial $display("[%0t] Reference Counter Design Module Ready", $time);
endmodule : reference_counter_design