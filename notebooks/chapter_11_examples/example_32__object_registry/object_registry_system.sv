// object_registry_system.sv
package object_registry_pkg;
  
  // Base class for all managed objects
  class managed_object;
    protected int object_id;
    protected string object_name;
    
    function new(string name = "unnamed_object");
      this.object_name = name;
      this.object_id = $urandom();
    endfunction
    
    function string get_name();
      return object_name;
    endfunction
    
    function int get_id();
      return object_id;
    endfunction
    
    virtual function string get_info();
      return $sformatf("Object[%0d]: %s", object_id, object_name);
    endfunction
  endclass
  
  // Example derived class - Transaction object
  class transaction_object extends managed_object;
    protected int transaction_value;
    
    function new(string name = "transaction", int value = 0);
      super.new(name);
      this.transaction_value = value;
    endfunction
    
    function void set_value(int value);
      transaction_value = value;
    endfunction
    
    function int get_value();
      return transaction_value;
    endfunction
    
    virtual function string get_info();
      return $sformatf("Transaction[%0d]: %s, value=%0d", 
                       object_id, object_name, transaction_value);
    endfunction
  endclass
  
  // Object Registry - Central management system
  class object_registry;
    // Static instance for singleton pattern
    protected static object_registry m_instance;
    
    // Handle counter and object storage
    protected int next_handle;
    protected managed_object objects[int];  // Handle -> Object mapping
    protected int object_count;
    
    // Protected constructor for singleton
    protected function new();
      next_handle = 1;
      object_count = 0;
    endfunction
    
    // Get singleton instance
    static function object_registry get_instance();
      if (m_instance == null) begin
        m_instance = new();
      end
      return m_instance;
    endfunction
    
    // Register a new object and return handle
    function int register_object(managed_object obj);
      int handle;
      if (obj != null) begin
        handle = next_handle++;
        objects[handle] = obj;
        object_count++;
        $display("[REGISTRY] Registered object with handle %0d: %s", 
                 handle, obj.get_info());
        return handle;
      end else begin
        $error("[REGISTRY] Cannot register null object");
        return -1;
      end
    endfunction
    
    // Lookup object by handle
    function managed_object lookup_object(int handle);
      if (objects.exists(handle)) begin
        $display("[REGISTRY] Found object with handle %0d: %s", 
                 handle, objects[handle].get_info());
        return objects[handle];
      end else begin
        $warning("[REGISTRY] Object with handle %0d not found", handle);
        return null;
      end
    endfunction
    
    // Remove object from registry
    function bit unregister_object(int handle);
      if (objects.exists(handle)) begin
        $display("[REGISTRY] Unregistering object with handle %0d: %s", 
                 handle, objects[handle].get_info());
        objects.delete(handle);
        object_count--;
        return 1;
      end else begin
        $warning("[REGISTRY] Cannot unregister - handle %0d not found", 
                 handle);
        return 0;
      end
    endfunction
    
    // Get current object count
    function int get_object_count();
      return object_count;
    endfunction
    
    // List all registered objects
    function void list_objects();
      $display("[REGISTRY] === Object Registry Status ===");
      $display("[REGISTRY] Total objects: %0d", object_count);
      if (object_count > 0) begin
        foreach (objects[handle]) begin
          $display("[REGISTRY] Handle %0d: %s", 
                   handle, objects[handle].get_info());
        end
      end else begin
        $display("[REGISTRY] No objects registered");
      end
      $display("[REGISTRY] ===========================");
    endfunction
    
    // Cleanup all objects
    function void cleanup_all();
      int handles_to_delete[];
      
      $display("[REGISTRY] Starting cleanup of all objects...");
      
      // Collect all handles first to avoid iterator issues
      foreach (objects[handle]) begin
        handles_to_delete = new[handles_to_delete.size() + 1](handles_to_delete);
        handles_to_delete[handles_to_delete.size() - 1] = handle;
      end
      
      // Delete all objects
      foreach (handles_to_delete[i]) begin
        bit success = unregister_object(handles_to_delete[i]);
      end
      
      $display("[REGISTRY] Cleanup complete. Objects remaining: %0d", 
               object_count);
    endfunction
  endclass
  
endpackage

module object_registry_system;
  import object_registry_pkg::*;
  
  // Module just imports the package - all functionality is in classes
  initial begin
    $display("Object Registry System Module Loaded");
  end
  
endmodule