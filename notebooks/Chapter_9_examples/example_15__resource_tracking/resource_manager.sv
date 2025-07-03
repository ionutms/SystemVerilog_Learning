// resource_manager.sv
package resource_pkg;

  // Resource tracking class with instance counting
  class ResourceTracker;
    static int total_instances = 0;    // Total instances created
    static int active_instances = 0;   // Currently active instances
    int instance_id;                   // Unique ID for this instance
    string resource_name;              // Name of the resource
    
    // Constructor - tracks creation
    function new(string name = "unnamed_resource");
      total_instances++;
      active_instances++;
      instance_id = total_instances;
      resource_name = name;
      $display("Resource created: %s (ID: %0d)", resource_name, instance_id);
      $display("  Total created: %0d, Active: %0d", 
               total_instances, active_instances);
    endfunction
    
    // Destructor - tracks cleanup  
    function void cleanup();
      active_instances--;
      $display("Resource cleaned up: %s (ID: %0d)", 
               resource_name, instance_id);
      $display("  Total created: %0d, Active: %0d", 
               total_instances, active_instances);
    endfunction
    
    // Static method to get current statistics
    static function void print_stats();
      $display("Resource Statistics:");
      $display("  Total instances created: %0d", total_instances);
      $display("  Currently active: %0d", active_instances);
    endfunction
    
    // Method to display resource info
    function void display_info();
      $display("Resource Info: %s (ID: %0d)", resource_name, instance_id);
    endfunction
    
  endclass

endpackage

module resource_manager_module();

  // Simple demonstration - main logic is in testbench
  initial begin
    $display("Resource Manager Design Module Ready");
    $display();
  end

endmodule