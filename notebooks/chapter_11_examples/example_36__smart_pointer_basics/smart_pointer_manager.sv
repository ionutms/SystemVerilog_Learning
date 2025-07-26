// smart_pointer_manager.sv
package smart_pointer_pkg;
  
  // Simple data class to be managed by smart pointer
  class managed_data;
    string name;
    int value;
    
    function new(string name = "default", int value = 0);
      this.name = name;
      this.value = value;
      $display("[%0t] Created managed_data: %s = %0d", $time, name, value);
    endfunction
    
    function void display();
      $display("[%0t] Data: %s = %0d", $time, name, value);
    endfunction
    
    // Destructor equivalent - called when object is deleted
    function void cleanup();
      $display("[%0t] Cleaning up managed_data: %s", $time, name);
    endfunction
  endclass
  
  // Reference count manager for shared data
  class ref_count_manager;
    managed_data data_ptr;
    int ref_count;
    
    function new(managed_data data);
      this.data_ptr = data;
      this.ref_count = 1;
    endfunction
  endclass
  
  // Smart pointer class with reference counting
  class smart_pointer;
    protected ref_count_manager manager;
    protected static ref_count_manager managers[managed_data];
    
    function new(managed_data data);
      // Initialize manager to null first
      manager = null;
      
      if (data == null) begin
        $display("[%0t] ERROR: Cannot create smart_pointer with null data", 
                 $time);
        return;
      end
      
      // Check if this data already has a manager
      if (managers.exists(data)) begin
        // Found existing manager, increment reference count
        manager = managers[data];
        manager.ref_count++;
        $display("[%0t] Smart pointer ref count increased to %0d", 
                 $time, manager.ref_count);
      end else begin
        // New data, create new manager
        manager = new(data);
        managers[data] = manager;
        $display("[%0t] Smart pointer created with ref count 1", $time);
      end
    endfunction
    
    function managed_data get();
      return (manager != null) ? manager.data_ptr : null;
    endfunction
    
    function int get_ref_count();
      return (manager != null) ? manager.ref_count : 0;
    endfunction
    
    function void increment_ref();
      if (manager != null) begin
        manager.ref_count++;
        $display("[%0t] Reference count incremented to %0d", 
                 $time, manager.ref_count);
      end
    endfunction
    
    function void decrement_ref();
      if (manager != null && manager.ref_count > 0) begin
        manager.ref_count--;
        $display("[%0t] Reference count decremented to %0d", 
                 $time, manager.ref_count);
        
        if (manager.ref_count == 0) begin
          $display("[%0t] Reference count reached 0, cleaning up data", 
                   $time);
          if (manager.data_ptr != null) begin
            manager.data_ptr.cleanup();
            // Remove from managers associative array
            managers.delete(manager.data_ptr);
            manager.data_ptr = null;
          end
          manager = null;
        end
      end
    endfunction
    
    function bit is_valid();
      return (manager != null && manager.data_ptr != null && 
              manager.ref_count > 0);
    endfunction
  endclass
  
endpackage

// Design module demonstrating smart pointer usage
module smart_pointer_manager;
  import smart_pointer_pkg::*;
  
  // Smart pointer instances
  smart_pointer ptr1, ptr2, ptr3;
  managed_data data1, data2;
  
  initial begin
    $display("=== Smart Pointer Basics Demo ===");
    $display();
    
    // Create managed data objects
    data1 = new("sensor_data", 42);
    data2 = new("config_data", 100);
    
    // Create smart pointers
    $display("\n--- Creating Smart Pointers ---");
    ptr1 = new(data1);
    ptr2 = new(data1);  // Should share reference with ptr1
    ptr3 = new(data2);  // Different data object
    
    // Use smart pointers
    $display("\n--- Using Smart Pointers ---");
    if (ptr1.is_valid()) ptr1.get().display();
    if (ptr2.is_valid()) ptr2.get().display();
    if (ptr3.is_valid()) ptr3.get().display();
    
    $display("\nReference counts:");
    $display("ptr1 ref count: %0d", ptr1.get_ref_count());
    $display("ptr2 ref count: %0d", ptr2.get_ref_count());
    $display("ptr3 ref count: %0d", ptr3.get_ref_count());
    
    // Simulate scope exit by decrementing references
    $display("\n--- Simulating Scope Exit ---");
    ptr1.decrement_ref();
    ptr2.decrement_ref();  // This should trigger cleanup
    ptr3.decrement_ref();  // This should trigger cleanup
    
    $display("\n--- Checking Validity After Cleanup ---");
    $display("ptr1 valid: %0b", ptr1.is_valid());
    $display("ptr2 valid: %0b", ptr2.is_valid());
    $display("ptr3 valid: %0b", ptr3.is_valid());
    
    $display("\n=== Demo Complete ===");
  end
  
endmodule