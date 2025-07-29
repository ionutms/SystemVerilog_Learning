// nested_class_access_design.sv
package nested_class_pkg;

  // Outer class containing nested classes
  class outer_processor_class;
    int outer_data = 100;
    static int shared_counter = 0;
    
    // Public nested class - accessible from outside
    class inner_config_class;
      int config_value = 42;
      string config_name = "default";
      
      function void display_config();
        $display("Config: %s = %d", config_name, config_value);
      endfunction
      
      function void set_config(string name, int value);
        config_name = name;
        config_value = value;
      endfunction
      
      function int get_value();
        return config_value;
      endfunction
    endclass
    
    // Another nested class for status management
    class inner_status_class;
      bit [7:0] status_flags = 8'hAA;
      string status_name = "idle";
      
      function bit [7:0] get_status();
        return status_flags;
      endfunction
      
      function void set_status(bit [7:0] new_status, string name);
        status_flags = new_status;
        status_name = name;
      endfunction
      
      function void display_status();
        $display("Status: %s (0x%02x)", status_name, status_flags);
      endfunction
    endclass
    
    // Nested class for data processing
    class inner_processor_class;
      int process_id;
      int data_count = 0;
      
      function new(int id = 0);
        process_id = id;
      endfunction
      
      function void process_data(int data);
        data_count++;
        $display("Processor %0d: Processing data %0d (count=%0d)", 
                 process_id, data, data_count);
      endfunction
      
      function int get_count();
        return data_count;
      endfunction
    endclass
    
    // Instances of nested classes
    inner_config_class config_obj;
    inner_status_class status_obj;
    inner_processor_class processor_obj;
    
    function new();
      config_obj = new();
      status_obj = new();
      processor_obj = new(shared_counter);
      shared_counter++;
    endfunction
    
    // Method to demonstrate access patterns
    function void demonstrate_access();
      $display("=== Outer Class Access Demo ===");
      $display("Outer data: %d", outer_data);
      $display("Shared counter: %d", shared_counter);
      
      // Direct access to nested class members
      config_obj.set_config("processor_config", 256);
      config_obj.display_config();
      
      // Access through methods
      status_obj.set_status(8'h55, "running");
      status_obj.display_status();
      
      // Process some data
      processor_obj.process_data(outer_data);
      processor_obj.process_data(outer_data * 2);
    endfunction
    
    // Methods to get nested class instances
    function inner_config_class get_config();
      return config_obj;
    endfunction
    
    function inner_status_class get_status_obj();
      return status_obj;
    endfunction
    
    function inner_processor_class get_processor();
      return processor_obj;
    endfunction
    
    // Method to create new nested class instances
    function inner_config_class create_config();
      inner_config_class new_config = new();
      return new_config;
    endfunction
    
  endclass

endpackage