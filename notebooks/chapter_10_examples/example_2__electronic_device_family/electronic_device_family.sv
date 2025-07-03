// electronic_device_family.sv
// Electronic Device Family with inheritance-like behavior

// Base device interface defining common properties and methods
interface device_interface;
  string brand;
  string model;
  bit power_state;
  
  // Common power on method
  task power_on();
    power_state = 1'b1;
    $display("Device %s %s powered ON", brand, model);
  endtask
  
  // Common power off method  
  task power_off();
    power_state = 1'b0;
    $display("Device %s %s powered OFF", brand, model);
  endtask
  
  // Pure virtual method to be implemented by derived classes
  task show_device_info();
    $display("Generic device: %s %s", brand, model);
  endtask
endinterface

// Phone class inheriting from device interface
module phone_device(device_interface dev_if);
  string phone_number = "+1-555-0123";
  bit has_camera = 1'b1;
  
  initial begin
    dev_if.brand = "Apple";
    dev_if.model = "iPhone 15";
    #1; // Small delay to ensure assignment
  end
  
  // Override device info method
  task show_phone_info();
    $display("Phone: %s %s", dev_if.brand, dev_if.model);
    $display("  Phone Number: %s", phone_number);
    $display("  Has Camera: %s", has_camera ? "Yes" : "No");
  endtask
  
  // Phone-specific method
  task make_call(string number);
    if (dev_if.power_state) begin
      $display("Calling %s from %s...", number, phone_number);
    end else begin
      $display("Cannot make call - phone is powered off");
    end
  endtask
endmodule

// Laptop class inheriting from device interface
module laptop_device(device_interface dev_if);
  string operating_system = "Ubuntu Linux";
  int ram_gb = 16;
  
  initial begin
    dev_if.brand = "Dell";
    dev_if.model = "XPS 13";
    #1; // Small delay to ensure assignment
  end
  
  // Override device info method
  task show_laptop_info();
    $display("Laptop: %s %s", dev_if.brand, dev_if.model);
    $display("  Operating System: %s", operating_system);
    $display("  RAM: %0d GB", ram_gb);
  endtask
  
  // Laptop-specific method
  task run_application(string app_name);
    if (dev_if.power_state) begin
      $display("Running %s on %s %s", app_name, dev_if.brand, 
               dev_if.model);
    end else begin
      $display("Cannot run application - laptop is powered off");
    end
  endtask
endmodule

// Top-level design module
module electronic_device_family();
  // Create device interfaces
  device_interface phone_if();
  device_interface laptop_if();
  
  // Instantiate device modules
  phone_device phone_inst(phone_if);
  laptop_device laptop_inst(laptop_if);
  
  initial begin
    $display("=== Electronic Device Family Demo ===");
    $display();
    
    // Wait for initialization
    #2;
    
    // Show initial device information
    phone_inst.show_phone_info();
    $display();
    laptop_inst.show_laptop_info();
    $display();
    
    // Test common power methods
    $display("--- Testing Power Control ---");
    phone_if.power_on();
    laptop_if.power_on();
    $display();
    
    // Test device-specific methods
    $display("--- Testing Device-Specific Methods ---");
    phone_inst.make_call("+1-555-9876");
    laptop_inst.run_application("Firefox Browser");
    $display();
    
    // Test power off
    $display("--- Testing Power Off ---");
    phone_if.power_off();
    laptop_if.power_off();
    $display();
    
    // Try to use devices when powered off
    $display("--- Testing Powered Off State ---");
    phone_inst.make_call("+1-555-5555");
    laptop_inst.run_application("Text Editor");
  end
endmodule