// object_self_reference.sv
// Example demonstrating object self-reference using 'this' keyword

class ConfigBuilder;
  string config_name;
  int timeout_value;
  bit debug_enable;
  
  // Constructor
  function new(string name = "default_config");
    this.config_name = name;
    this.timeout_value = 100;
    this.debug_enable = 0;
  endfunction
  
  // Method that sets timeout and returns self-reference for chaining
  function ConfigBuilder set_timeout(int timeout);
    this.timeout_value = timeout;
    return this;  // Return reference to current object
  endfunction
  
  // Method that sets debug mode and returns self-reference for chaining
  function ConfigBuilder set_debug(bit enable);
    this.debug_enable = enable;
    return this;  // Return reference to current object
  endfunction
  
  // Method that sets name and returns self-reference for chaining
  function ConfigBuilder set_name(string name);
    this.config_name = name;
    return this;  // Return reference to current object
  endfunction
  
  // Method to display current configuration
  function void display_config();
    $display("Configuration: %s", this.config_name);
    $display("  Timeout: %0d", this.timeout_value);
    $display("  Debug: %s", this.debug_enable ? "ON" : "OFF");
  endfunction
  
  // Method that returns a copy of this object
  function ConfigBuilder clone();
    ConfigBuilder copy = new(this.config_name);
    copy.timeout_value = this.timeout_value;
    copy.debug_enable = this.debug_enable;
    return copy;
  endfunction
  
endclass

module design_module_name;
  
  initial begin
    ConfigBuilder cfg1, cfg2, cfg3;
    
    $display("=== Object Self-Reference Example ===");
    $display();
    
    // Create initial configuration
    cfg1 = new("basic_config");
    $display("Initial configuration:");
    cfg1.display_config();
    $display();
    
    // Demonstrate method chaining using self-reference
    $display("Method chaining example:");
    cfg2 = cfg1.set_name("chained_config")
              .set_timeout(500)
              .set_debug(1);
    cfg2.display_config();
    $display();
    
    // Demonstrate cloning (another use of self-reference)
    $display("Cloning example:");
    cfg3 = cfg2.clone();
    void'(cfg3.set_name("cloned_config"));  // Explicit void cast
    cfg3.display_config();
    $display();
    
    // Verify original object is unchanged
    $display("Original object after cloning:");
    cfg2.display_config();
    $display();
    
  end
  
endmodule