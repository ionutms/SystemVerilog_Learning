// system_config_manager.sv
module system_config_manager ();

  // System configuration structure
  typedef struct packed {
    logic [7:0] cpu_frequency_setting;
    logic [3:0] cache_size_level;
    logic       power_save_mode_enable;
    logic       debug_trace_enable;
  } system_config_struct;

  // Configuration registers
  system_config_struct current_system_config;
  system_config_struct backup_system_config;

  // Task to update CPU frequency configuration by reference
  task automatic update_cpu_frequency_config(
    ref system_config_struct config_to_modify,
    input logic [7:0] new_frequency_setting
  );
    $display("Updating CPU frequency from %d to %d", 
             config_to_modify.cpu_frequency_setting, new_frequency_setting);
    config_to_modify.cpu_frequency_setting = new_frequency_setting;
    $display("CPU frequency configuration updated successfully");
  endtask

  // Task to update cache configuration by reference
  task automatic update_cache_config(
    ref system_config_struct config_to_modify,
    input logic [3:0] new_cache_level
  );
    $display("Updating cache level from %d to %d", 
             config_to_modify.cache_size_level, new_cache_level);
    config_to_modify.cache_size_level = new_cache_level;
    $display("Cache configuration updated successfully");
  endtask

  // Task to update power management configuration by reference
  task automatic update_power_management_config(
    ref system_config_struct config_to_modify,
    input logic enable_power_save,
    input logic enable_debug_trace
  );
    $display("Updating power save: %b -> %b, debug trace: %b -> %b",
             config_to_modify.power_save_mode_enable, enable_power_save,
             config_to_modify.debug_trace_enable, enable_debug_trace);
    config_to_modify.power_save_mode_enable = enable_power_save;
    config_to_modify.debug_trace_enable = enable_debug_trace;
    $display("Power management configuration updated successfully");
  endtask

  // Task to backup current configuration by reference
  task automatic backup_current_config(
    ref system_config_struct source_config,
    ref system_config_struct destination_config
  );
    $display("Creating backup of current system configuration");
    destination_config = source_config;
    $display("Configuration backup completed");
  endtask

  // Display configuration status
  task automatic display_config_status(
    ref system_config_struct config_to_display,
    input string config_name
  );
    $display("=== %s Configuration Status ===", config_name);
    $display("CPU Frequency Setting: %d", 
             config_to_display.cpu_frequency_setting);
    $display("Cache Size Level: %d", config_to_display.cache_size_level);
    $display("Power Save Mode: %b", 
             config_to_display.power_save_mode_enable);
    $display("Debug Trace: %b", config_to_display.debug_trace_enable);
    $display("==============================");
  endtask

  initial begin
    $display("System Configuration Manager Initialization");
    
    // Initialize default configuration
    current_system_config.cpu_frequency_setting = 8'd100;
    current_system_config.cache_size_level = 4'd2;
    current_system_config.power_save_mode_enable = 1'b0;
    current_system_config.debug_trace_enable = 1'b1;
    
    $display("Default configuration loaded");
  end

endmodule