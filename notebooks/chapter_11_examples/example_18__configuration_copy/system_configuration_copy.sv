// system_configuration_copy.sv
package system_config_pkg;

  // System configuration class with copy functionality
  class system_config_c;
    // Configuration parameters
    int unsigned clock_freq_mhz;
    int unsigned data_width;
    string       protocol_type;
    bit          debug_enable;
    int unsigned buffer_size;
    
    // Constructor with default values
    function new(int unsigned clk_freq = 100,
                 int unsigned width = 32,
                 string protocol = "AXI4",
                 bit debug = 1'b0,
                 int unsigned buf_size = 1024);
      this.clock_freq_mhz = clk_freq;
      this.data_width = width;
      this.protocol_type = protocol;
      this.debug_enable = debug;
      this.buffer_size = buf_size;
    endfunction

    // Copy constructor for safe duplication
    function system_config_c copy();
      system_config_c copied_config;
      copied_config = new(this.clock_freq_mhz,
                         this.data_width,
                         this.protocol_type,
                         this.debug_enable,
                         this.buffer_size);
      return copied_config;
    endfunction

    // Display configuration details
    function void display(string config_name = "Config");
      $display("=== %s Configuration ===", config_name);
      $display("  Clock Frequency: %0d MHz", clock_freq_mhz);
      $display("  Data Width:      %0d bits", data_width);
      $display("  Protocol Type:   %s", protocol_type);
      $display("  Debug Enable:    %b", debug_enable);
      $display("  Buffer Size:     %0d bytes", buffer_size);
      $display();
    endfunction

    // Modify configuration (for testing copy independence)
    function void modify_for_testing();
      clock_freq_mhz = 200;
      data_width = 64;
      protocol_type = "AXI4-Lite";
      debug_enable = 1'b1;
      buffer_size = 2048;
    endfunction

  endclass : system_config_c

endpackage : system_config_pkg

// Design module that uses the configuration package
module system_configuration_copy;
  
  import system_config_pkg::*;
  
  // This module could contain actual design logic
  // For this example, it's just a placeholder that imports the package
  
  initial begin
    $display("Configuration package loaded successfully");
  end

endmodule : system_configuration_copy