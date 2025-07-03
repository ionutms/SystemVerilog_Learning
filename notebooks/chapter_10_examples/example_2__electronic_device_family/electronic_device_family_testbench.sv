// electronic_device_family_testbench.sv
// Testbench for Electronic Device Family demonstration

module device_family_testbench;
  // Instantiate the design under test
  electronic_device_family DEVICE_FAMILY_INSTANCE();
  
  initial begin
    // Dump waves for debugging
    $dumpfile("device_family_testbench.vcd");
    $dumpvars(0, device_family_testbench);
    
    // Wait for design to complete
    #100;
    
    $display();
    $display("=== Additional Testbench Verification ===");
    $display();
    
    // Test power state verification
    $display("--- Power State Verification ---");
    $display("Phone power state: %s", 
             DEVICE_FAMILY_INSTANCE.phone_if.power_state ? "ON" : "OFF");
    $display("Laptop power state: %s",
             DEVICE_FAMILY_INSTANCE.laptop_if.power_state ? "ON" : "OFF");
    $display();
    
    // Test brand and model access
    $display("--- Device Properties Access ---");
    $display("Phone brand: %s, model: %s", 
             DEVICE_FAMILY_INSTANCE.phone_if.brand,
             DEVICE_FAMILY_INSTANCE.phone_if.model);
    $display("Laptop brand: %s, model: %s",
             DEVICE_FAMILY_INSTANCE.laptop_if.brand,
             DEVICE_FAMILY_INSTANCE.laptop_if.model);
    $display();
    
    // Test polymorphic behavior
    $display("--- Polymorphic Method Testing ---");
    DEVICE_FAMILY_INSTANCE.phone_if.show_device_info();
    DEVICE_FAMILY_INSTANCE.laptop_if.show_device_info();
    $display();
    
    $display("Hello from device family testbench!");
    $display();
    
    // End simulation
    $finish;
  end
endmodule