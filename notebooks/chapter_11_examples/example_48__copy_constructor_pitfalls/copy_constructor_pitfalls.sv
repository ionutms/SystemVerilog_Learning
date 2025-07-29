// copy_constructor_pitfalls.sv
package copy_constructor_pkg;

  // Helper class to demonstrate object reference sharing
  class DataContainer;
    int value;
    string name;
    
    function new(int val = 0, string n = "container");
      this.value = val;
      this.name = n;
    endfunction
    
    function void display(string prefix = "");
      $display("%s%s: value = %0d", prefix, name, value);
    endfunction
  endclass

  // Class with handle/reference copy pitfall
  class ShallowCopyClass;
    DataContainer container_handle;  // Object handle - this can be shared!
    int simple_data;
    string name;
    
    function new(string name = "default");
      this.name = name;
      this.simple_data = 42;
      this.container_handle = new(100, "shared_container");
    endfunction
    
    // PITFALL: This creates shallow copy - object handles are shared!
    function ShallowCopyClass shallow_copy();
      ShallowCopyClass copy_obj = new();
      copy_obj.name = this.name;
      copy_obj.simple_data = this.simple_data;
      copy_obj.container_handle = this.container_handle;  // Shares handle!
      return copy_obj;
    endfunction
    
    function void display(string prefix = "");
      $display("%s%s: simple_data = %0d", prefix, name, simple_data);
      if (container_handle != null)
        container_handle.display({prefix, "  "});
    endfunction
    
    function void modify_container(int new_val);
      if (container_handle != null)
        container_handle.value = new_val;
    endfunction
  endclass

  // Class with correct deep copy implementation
  class DeepCopyClass;
    DataContainer container_handle;
    int simple_data;
    string name;
    
    function new(string name = "default");
      this.name = name;
      this.simple_data = 42;
      this.container_handle = new(100, "independent_container");
    endfunction
    
    // CORRECT: Deep copy constructor - creates independent objects
    function DeepCopyClass deep_copy();
      DeepCopyClass copy_obj = new();
      copy_obj.name = this.name;
      copy_obj.simple_data = this.simple_data;
      // Create new container object instead of sharing handle
      if (this.container_handle != null) begin
        copy_obj.container_handle = new(this.container_handle.value,
                                       this.container_handle.name);
      end
      return copy_obj;
    endfunction
    
    function void display(string prefix = "");
      $display("%s%s: simple_data = %0d", prefix, name, simple_data);
      if (container_handle != null)
        container_handle.display({prefix, "  "});
    endfunction
    
    function void modify_container(int new_val);
      if (container_handle != null)
        container_handle.value = new_val;
    endfunction
  endclass

  // Class demonstrating missing copy constructor pitfall
  class NoCopyConstructorClass;
    DataContainer container_handle;
    int data_array[];
    string name;
    
    function new(string name = "default");
      this.name = name;
      this.data_array = new[3];
      this.data_array = '{10, 20, 30};
      this.container_handle = new(500, "no_copy_container");
    endfunction
    
    // PITFALL: No explicit copy constructor - users might do wrong assignment
    // Users might try: new_obj = old_obj; (this doesn't work as expected)
    
    function void display(string prefix = "");
      $display("%s%s: data_array = %p", prefix, name, data_array);
      if (container_handle != null)
        container_handle.display({prefix, "  "});
    endfunction
    
    function void modify_data(int index, int new_val);
      if (index >= 0 && index < data_array.size())
        data_array[index] = new_val;
    endfunction
    
    function void modify_container(int new_val);
      if (container_handle != null)
        container_handle.value = new_val;
    endfunction
  endclass

  // Class with proper copy constructor
  class ProperCopyClass;
    DataContainer container_handle;
    int data_array[];
    string name;
    
    function new(string name = "default");
      this.name = name;
      this.data_array = new[3];
      this.data_array = '{10, 20, 30};
      this.container_handle = new(500, "proper_copy_container");
    endfunction
    
    // CORRECT: Comprehensive copy constructor
    function ProperCopyClass copy();
      ProperCopyClass copy_obj = new();
      copy_obj.name = this.name;
      
      // Deep copy array (SystemVerilog does this automatically for arrays)
      copy_obj.data_array = new[this.data_array.size()];
      copy_obj.data_array = this.data_array;
      
      // Deep copy object handle
      if (this.container_handle != null) begin
        copy_obj.container_handle = new(this.container_handle.value,
                                       this.container_handle.name);
      end
      
      return copy_obj;
    endfunction
    
    function void display(string prefix = "");
      $display("%s%s: data_array = %p", prefix, name, data_array);
      if (container_handle != null)
        container_handle.display({prefix, "  "});
    endfunction
    
    function void modify_data(int index, int new_val);
      if (index >= 0 && index < data_array.size())
        data_array[index] = new_val;
    endfunction
    
    function void modify_container(int new_val);
      if (container_handle != null)
        container_handle.value = new_val;
    endfunction
  endclass

endpackage