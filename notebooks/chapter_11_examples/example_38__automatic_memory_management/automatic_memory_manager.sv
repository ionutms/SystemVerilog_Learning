// automatic_memory_manager.sv
package memory_pkg;

  // Memory-managed class with explicit cleanup tracking
  class managed_data;
    local int data_value;
    local static int total_created = 0;
    local static int total_cleaned = 0;
    local int object_id;
    local bit is_valid;
    
    function new(int value = 0);
      data_value = value;
      total_created++;
      object_id = total_created;
      is_valid = 1;
      $display("Creating object ID %0d with value %0d (Created: %0d)", 
               object_id, data_value, total_created);
    endfunction
    
    // Manual cleanup method (simulates automatic destruction)
    function void cleanup();
      if (is_valid) begin
        total_cleaned++;
        is_valid = 0;
        $display("Cleaning object ID %0d with value %0d (Cleaned: %0d)", 
                 object_id, data_value, total_cleaned);
      end
    endfunction
    
    function int get_value();
      if (!is_valid) begin
        $display("Warning: Accessing cleaned object ID %0d", object_id);
        return -1;
      end
      return data_value;
    endfunction
    
    function void set_value(int value);
      if (is_valid) begin
        data_value = value;
      end else begin
        $display("Error: Cannot modify cleaned object ID %0d", object_id);
      end
    endfunction
    
    function bit is_object_valid();
      return is_valid;
    endfunction
    
    static function void show_memory_stats();
      $display("Memory Stats - Created: %0d, Cleaned: %0d, Active: %0d", 
               total_created, total_cleaned, total_created - total_cleaned);
    endfunction
    
    function int get_id();
      return object_id;
    endfunction
  endclass

  // Smart container with automatic cleanup capabilities
  class smart_container;
    managed_data data_objects[];
    int active_count;
    
    function new();
      data_objects = new[0];
      active_count = 0;
    endfunction
    
    function void add_object(int value);
      managed_data new_obj = new(value);
      data_objects = new[data_objects.size() + 1](data_objects);
      data_objects[data_objects.size() - 1] = new_obj;
      active_count++;
    endfunction
    
    // Simulates automatic cleanup when container is destroyed
    function void auto_cleanup();
      $display("Container auto-cleanup: cleaning %0d objects", active_count);
      foreach(data_objects[i]) begin
        if(data_objects[i] != null && data_objects[i].is_object_valid()) begin
          data_objects[i].cleanup();
        end
      end
      data_objects.delete();
      active_count = 0;
    endfunction
    
    function void display_active_objects();
      $display("Container has %0d active objects:", active_count);
      foreach(data_objects[i]) begin
        if(data_objects[i] != null && data_objects[i].is_object_valid()) begin
          $display("  Index %0d: ID %0d, Value %0d", 
                   i, data_objects[i].get_id(), data_objects[i].get_value());
        end
      end
    endfunction
    
    function void cleanup_object(int index);
      if (index < data_objects.size() && data_objects[index] != null) begin
        if (data_objects[index].is_object_valid()) begin
          data_objects[index].cleanup();
          active_count--;
        end
      end
    endfunction
  endclass

  // Resource manager that simulates RAII (Resource Acquisition Is 
  // Initialization)
  class resource_manager;
    managed_data resources[];
    string manager_name;
    
    function new(string name = "ResourceManager");
      manager_name = name;
      resources = new[0];
      $display("%s: Initialized", manager_name);
    endfunction
    
    function managed_data acquire_resource(int value);
      managed_data new_resource = new(value);
      resources = new[resources.size() + 1](resources);
      resources[resources.size() - 1] = new_resource;
      $display("%s: Acquired resource ID %0d", 
               manager_name, new_resource.get_id());
      return new_resource;
    endfunction
    
    // Simulates automatic resource cleanup (like destructor)
    function void release_all_resources();
      $display("%s: Releasing %0d resources", manager_name, resources.size());
      foreach(resources[i]) begin
        if(resources[i] != null && resources[i].is_object_valid()) begin
          resources[i].cleanup();
        end
      end
      resources.delete();
      $display("%s: All resources released", manager_name);
    endfunction
  endclass

endpackage

module automatic_memory_manager;
  import memory_pkg::*;
  
  initial begin
    $display("Automatic Memory Management Design Module Loaded");
    $display("Note: Simulates automatic cleanup with explicit methods");
  end

endmodule