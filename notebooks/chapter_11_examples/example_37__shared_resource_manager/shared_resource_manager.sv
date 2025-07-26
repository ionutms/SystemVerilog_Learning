// shared_resource_manager.sv
package shared_resource_pkg;

  // Shared resource class with automatic cleanup
  class shared_resource;
    protected int resource_id;
    protected string resource_name;
    protected static int resource_counter = 0;
    
    function new(string name = "default_resource");
      resource_counter++;
      resource_id = resource_counter;
      resource_name = name;
      $display("[%0t] Resource '%s' (ID:%0d) created", 
               $time, resource_name, resource_id);
    endfunction
    
    function void use_resource();
      $display("[%0t] Using resource '%s' (ID:%0d)", 
               $time, resource_name, resource_id);
    endfunction
    
    function string get_name();
      return resource_name;
    endfunction
    
    function int get_id();
      return resource_id;
    endfunction
    
    // Automatic cleanup when object is destroyed
    virtual function void cleanup();
      $display("[%0t] Resource '%s' (ID:%0d) cleaning up", 
               $time, resource_name, resource_id);
    endfunction
  endclass

  // Shared resource manager with reference counting
  class shared_resource_manager;
    protected shared_resource resources[$];
    protected int reference_count = 0;
    protected static shared_resource_manager m_instance;
    
    protected function new();
      $display("[%0t] Shared Resource Manager created", $time);
    endfunction
    
    // Singleton pattern - get manager instance
    static function shared_resource_manager get_instance();
      if (m_instance == null) begin
        m_instance = new();
      end
      return m_instance;
    endfunction
    
    function void add_reference();
      reference_count++;
      $display("[%0t] Reference added. Count: %0d", $time, reference_count);
    endfunction
    
    function void remove_reference();
      if (reference_count > 0) begin
        reference_count--;
        $display("[%0t] Reference removed. Count: %0d", 
                 $time, reference_count);
        
        // Auto cleanup when no more references
        if (reference_count == 0) begin
          cleanup_all_resources();
        end
      end
    endfunction
    
    function void add_resource(shared_resource res);
      resources.push_back(res);
      $display("[%0t] Resource '%s' added to manager", 
               $time, res.get_name());
    endfunction
    
    function shared_resource get_resource(int index);
      if (index < resources.size()) begin
        return resources[index];
      end
      return null;
    endfunction
    
    function int get_resource_count();
      return resources.size();
    endfunction
    
    function int get_reference_count();
      return reference_count;
    endfunction
    
    protected function void cleanup_all_resources();
      $display("[%0t] Cleaning up all resources (%0d total)", 
               $time, resources.size());
      
      foreach (resources[i]) begin
        if (resources[i] != null) begin
          resources[i].cleanup();
        end
      end
      resources.delete();
      $display("[%0t] All resources cleaned up", $time);
    endfunction
  endclass

endpackage

module shared_resource_manager_design;
  import shared_resource_pkg::*;
  
  initial begin
    $display("[%0t] Shared Resource Manager Design Module Started", $time);
  end
  
endmodule