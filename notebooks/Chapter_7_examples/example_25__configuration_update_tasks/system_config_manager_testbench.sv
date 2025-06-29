// system_config_manager_testbench.sv
module config_update_testbench;

  // Instantiate the system configuration manager
  system_config_manager CONFIG_MANAGER_INSTANCE();

  initial begin
    // Setup waveform dumping
    $dumpfile("config_update_testbench.vcd");
    $dumpvars(0, config_update_testbench);
    
    $display();
    $display("Starting Configuration Update Tasks Demonstration");
    $display("================================================");
    
    // Wait for initialization
    #5;
    
    // Display initial configuration
    CONFIG_MANAGER_INSTANCE.display_config_status(
      CONFIG_MANAGER_INSTANCE.current_system_config, "Initial"
    );
    
    #10;
    $display("\n--- Testing CPU Frequency Configuration Update ---");
    CONFIG_MANAGER_INSTANCE.update_cpu_frequency_config(
      CONFIG_MANAGER_INSTANCE.current_system_config, 8'd150
    );
    
    #5;
    CONFIG_MANAGER_INSTANCE.display_config_status(
      CONFIG_MANAGER_INSTANCE.current_system_config, "After CPU Update"
    );
    
    #10;
    $display("\n--- Testing Cache Configuration Update ---");
    CONFIG_MANAGER_INSTANCE.update_cache_config(
      CONFIG_MANAGER_INSTANCE.current_system_config, 4'd5
    );
    
    #5;
    CONFIG_MANAGER_INSTANCE.display_config_status(
      CONFIG_MANAGER_INSTANCE.current_system_config, "After Cache Update"
    );
    
    #10;
    $display("\n--- Testing Power Management Configuration Update ---");
    CONFIG_MANAGER_INSTANCE.update_power_management_config(
      CONFIG_MANAGER_INSTANCE.current_system_config, 1'b1, 1'b0
    );
    
    #5;
    CONFIG_MANAGER_INSTANCE.display_config_status(
      CONFIG_MANAGER_INSTANCE.current_system_config, "After Power Update"
    );
    
    #10;
    $display("\n--- Testing Configuration Backup ---");
    CONFIG_MANAGER_INSTANCE.backup_current_config(
      CONFIG_MANAGER_INSTANCE.current_system_config,
      CONFIG_MANAGER_INSTANCE.backup_system_config
    );
    
    #5;
    CONFIG_MANAGER_INSTANCE.display_config_status(
      CONFIG_MANAGER_INSTANCE.backup_system_config, "Backup"
    );
    
    #10;
    $display("\n--- Testing Multiple Configuration Updates ---");
    CONFIG_MANAGER_INSTANCE.update_cpu_frequency_config(
      CONFIG_MANAGER_INSTANCE.current_system_config, 8'd200
    );
    CONFIG_MANAGER_INSTANCE.update_cache_config(
      CONFIG_MANAGER_INSTANCE.current_system_config, 4'd7
    );
    
    #5;
    CONFIG_MANAGER_INSTANCE.display_config_status(
      CONFIG_MANAGER_INSTANCE.current_system_config, "Final Current"
    );
    CONFIG_MANAGER_INSTANCE.display_config_status(
      CONFIG_MANAGER_INSTANCE.backup_system_config, "Final Backup"
    );
    
    #10;
    $display("\n================================================");
    $display("Configuration Update Tasks Demonstration Complete");
    $display();
    
    $finish;
  end

endmodule