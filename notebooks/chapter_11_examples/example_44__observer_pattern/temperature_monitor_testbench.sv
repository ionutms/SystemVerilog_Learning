// temperature_monitor_testbench.sv
module observer_pattern_testbench;
  
  temperature_monitor_module DESIGN_INSTANCE_NAME();

  initial begin
    // Dump waves
    $dumpfile("observer_pattern_testbench.vcd");
    $dumpvars(0, observer_pattern_testbench);
    
    $display("\n=== Observer Pattern Demo ===");
    
    // Wait for design initialization
    #1;
    
    // Add observers to sensor
    $display("\n1. Adding observers:");
    DESIGN_INSTANCE_NAME.add_display_observer(32'd1);  // LCD Display
    DESIGN_INSTANCE_NAME.add_display_observer(32'd2);  // LED Panel
    DESIGN_INSTANCE_NAME.add_alarm_observer(32'd25);   // Alarm at 25°C
    
    // Test temperature changes
    $display("\n2. Testing temperature updates:");
    DESIGN_INSTANCE_NAME.set_temperature(32'd20);
    
    #1;
    DESIGN_INSTANCE_NAME.set_temperature(32'd30);  // Should trigger alarm
    
    #1;
    DESIGN_INSTANCE_NAME.set_temperature(32'd22);  // Back to normal
    
    // Remove an observer and test again
    $display("\n3. Removing one observer:");
    #1;
    DESIGN_INSTANCE_NAME.remove_observer(32'd2);  // Remove LED Panel
    
    #1;
    DESIGN_INSTANCE_NAME.set_temperature(32'd28);  // Fewer observers
    
    // Remove more observers
    $display("\n4. Removing more observers:");
    #1;
    DESIGN_INSTANCE_NAME.remove_observer(32'd1);  // Remove LCD Display
    
    #1;
    DESIGN_INSTANCE_NAME.set_temperature(32'd35);  // Only alarm remains
    
    // Remove last observer
    #1;
    DESIGN_INSTANCE_NAME.remove_observer(32'hA1A2);  // Remove alarm
    
    #1;
    DESIGN_INSTANCE_NAME.set_temperature(32'd40);  // No observers
    
    $display("\n=== Demo Complete ===");
    
    #10;
    $finish;
  end

endmodule