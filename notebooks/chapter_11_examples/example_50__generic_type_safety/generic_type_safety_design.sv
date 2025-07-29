// generic_type_safety_design.sv
package type_safe_pkg;

  // Type-safe generic container class
  class typed_container #(type T = int);
    protected T data[$];
    
    // Safe method to add items of correct type
    function void add_item(T item);
      data.push_back(item);
      $display("[SAFE] Added item to container");
    endfunction
    
    // Safe method to get items with type checking
    function T get_item(int index);
      if (index >= 0 && index < data.size()) begin
        return data[index];
      end else begin
        $error("[ERROR] Index %0d out of bounds [0:%0d]", 
               index, data.size()-1);
        return T'(0);  // Return default value
      end
    endfunction
    
    // Method to show container size
    function void show_info();
      $display("[INFO] Container holds %0d items", data.size());
    endfunction
    
    // Method to display all items (type-specific implementations)
    virtual function void display_contents();
      $display("[INFO] Base container display");
    endfunction
    
    function int size();
      return data.size();
    endfunction
  endclass

  // Specialized byte container with proper display
  class byte_container extends typed_container #(bit [7:0]);
    virtual function void display_contents();
      $display("[BYTE] Container contents:");
      foreach (data[i]) begin
        $display("  [%0d]: 0x%02h", i, data[i]);
      end
    endfunction
  endclass

  // Specialized integer container with proper display  
  class int_container extends typed_container #(int);
    virtual function void display_contents();
      $display("[INT] Container contents:");
      foreach (data[i]) begin
        $display("  [%0d]: %0d", i, data[i]);
      end
    endfunction
  endclass

endpackage

module generic_type_safety_design;
  import type_safe_pkg::*;
  
  // Demonstrate type safety at module level
  initial begin
    $display("=== Generic Type Safety Design ===");
    $display("Design demonstrates type-safe generic containers");
    $display("Package contains typed_container class with type T");
    $display("Specialized classes: byte_container, int_container");
  end

endmodule