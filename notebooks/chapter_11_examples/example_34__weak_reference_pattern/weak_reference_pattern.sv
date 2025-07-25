// weak_reference_pattern.sv
package weak_reference_pkg;

  // Object that can be referenced
  class target_object;
    string name;
    int value;
    
    function new(string name = "unnamed", int value = 0);
      this.name = name;
      this.value = value;
      $display("[%0t] Target object '%s' created with value %0d", 
               $time, this.name, this.value);
    endfunction
    
    function void print_info();
      $display("[%0t] Target object '%s' has value %0d", 
               $time, this.name, this.value);
    endfunction
    
    function void set_value(int new_value);
      this.value = new_value;
      $display("[%0t] Target object '%s' value updated to %0d", 
               $time, this.name, this.value);
    endfunction
  endclass

  // Weak reference class that doesn't prevent garbage collection
  class weak_reference #(type T = target_object);
    protected T weak_ptr;
    protected bit is_valid;
    
    function new();
      this.weak_ptr = null;
      this.is_valid = 0;
      $display("[%0t] Weak reference created", $time);
    endfunction
    
    // Set the weak reference to point to an object
    function void set_reference(T obj);
      this.weak_ptr = obj;
      this.is_valid = (obj != null);
      $display("[%0t] Weak reference %s to object", 
               $time, this.is_valid ? "set" : "cleared");
    endfunction
    
    // Check if the reference is still valid
    function bit is_reference_valid();
      // In real implementation, this would check if object still exists
      return this.is_valid && (this.weak_ptr != null);
    endfunction
    
    // Get the referenced object (returns null if invalid)
    function T get_reference();
      if (is_reference_valid()) begin
        $display("[%0t] Weak reference accessed successfully", $time);
        return this.weak_ptr;
      end else begin
        $display("[%0t] Weak reference is invalid or null", $time);
        return null;
      end
    endfunction
    
    // Manually invalidate the reference (simulates object cleanup)
    function void invalidate();
      this.is_valid = 0;
      $display("[%0t] Weak reference invalidated", $time);
    endfunction
  endclass

endpackage

module weak_reference_design;
  import weak_reference_pkg::*;
  
  initial begin
    $display("[%0t] Weak Reference Pattern Design Started", $time);
    $display("----------------------------------------------");
  end

endmodule