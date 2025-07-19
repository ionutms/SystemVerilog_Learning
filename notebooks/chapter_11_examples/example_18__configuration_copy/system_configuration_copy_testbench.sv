// system_configuration_copy_testbench.sv
module config_copy_testbench;
  
  import system_config_pkg::*;
  
  // Instantiate the design module
  system_configuration_copy dut();
  
  // Configuration objects
  system_config_c base_config;
  system_config_c copied_config;
  system_config_c modified_config;

  initial begin
    // Setup wave dumping
    $dumpfile("config_copy_testbench.vcd");
    $dumpvars(0, config_copy_testbench);
    
    $display("=== Configuration Copy Example ===");
    $display();
    
    // Create base configuration with custom parameters
    base_config = new(.clk_freq(150),
                     .width(16),
                     .protocol("PCIe"),
                     .debug(1'b1),
                     .buf_size(512));
    
    $display("Step 1: Display original base configuration");
    base_config.display("Base");
    
    // Create a copy of the base configuration
    copied_config = base_config.copy();
    
    $display("Step 2: Display copied configuration (should be identical)");
    copied_config.display("Copied");
    
    // Modify the original configuration
    $display("Step 3: Modifying original configuration...");
    base_config.modify_for_testing();
    
    $display("Step 4: Display original after modification");
    base_config.display("Modified Base");
    
    $display("Step 5: Display copy (should remain unchanged)");
    copied_config.display("Copy (Unchanged)");
    
    // Create another copy from the modified base
    modified_config = base_config.copy();
    
    $display("Step 6: Display new copy from modified base");
    modified_config.display("Copy of Modified");
    
    // Verify independence by checking specific fields
    $display("=== Verification of Copy Independence ===");
    $display("Original clock freq: %0d MHz", base_config.clock_freq_mhz);
    $display("Copy clock freq:     %0d MHz", copied_config.clock_freq_mhz);
    
    if (base_config.clock_freq_mhz != copied_config.clock_freq_mhz) begin
      $display("✓ PASS: Copies are independent - modifications don't affect each other");
    end else begin
      $display("✗ FAIL: Copies are not independent!");
    end
    
    $display();
    $display("=== Configuration Copy Test Complete ===");
    
    #10;
    $finish;
  end

endmodule : config_copy_testbench