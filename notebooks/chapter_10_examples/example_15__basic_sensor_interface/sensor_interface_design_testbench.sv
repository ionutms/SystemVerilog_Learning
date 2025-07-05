// sensor_interface_design_testbench.sv
module sensor_interface_testbench;
  import sensor_interface_pkg::*;
  
  // Instantiate the design under test
  sensor_interface_module SENSOR_INTERFACE_INSTANCE();
  
  // Test-specific sensor instances
  TemperatureSensor test_temp_sensor;
  HumiditySensor test_humidity_sensor;
  BaseSensor polymorphic_sensor;
  
  initial begin
    // Setup VCD dumping
    $dumpfile("sensor_interface_testbench.vcd");
    $dumpvars(0, sensor_interface_testbench);
    
    #1; // Wait for design to initialize
    
    $display("=== Testbench: Basic Sensor Interface ===");
    $display();
    
    // Test 1: Create and test individual sensors
    $display("TEST 1: Individual sensor creation and testing");
    test_temp_sensor = new("Test Temperature", 100, 20.0);
    test_humidity_sensor = new("Test Humidity", 101, 60.0);
    
    $display("Created sensors:");
    test_temp_sensor.display_reading();
    test_humidity_sensor.display_reading();
    
    $display();
    
    // Test 2: Polymorphic behavior
    $display("TEST 2: Polymorphic behavior");
    polymorphic_sensor = test_temp_sensor;
    $display("Polymorphic access to temperature sensor:");
    polymorphic_sensor.display_reading();
    
    polymorphic_sensor = test_humidity_sensor;
    $display("Polymorphic access to humidity sensor:");
    polymorphic_sensor.display_reading();
    
    $display();
    
    // Test 3: Multiple readings to show variation
    $display("TEST 3: Multiple readings showing sensor variation");
    for (int i = 0; i < 5; i++) begin
      $display("Reading %0d:", i + 1);
      $display("  Temperature: %0.2f°C", test_temp_sensor.read_value());
      $display("  Humidity: %0.2f%%", test_humidity_sensor.read_value());
    end
    
    $display();
    
    // Test 4: Specific sensor methods
    $display("TEST 4: Sensor-specific methods");
    $display("Temperature in Fahrenheit: %0.2f°F", 
             test_temp_sensor.get_fahrenheit());
    $display("Humidity level: %s", test_humidity_sensor.get_humidity_level());
    
    $display();
    
    // Test 5: Boundary conditions for humidity
    $display("TEST 5: Humidity boundary conditions");
    test_humidity_sensor = new("Boundary Test", 102, 95.0);
    for (int i = 0; i < 10; i++) begin
      real humidity = test_humidity_sensor.read_value();
      $display("Humidity reading %0d: %0.2f%%", i + 1, humidity);
    end
    
    $display();
    $display("=== Testbench Complete ===");
    
    #10; // Final delay
    $finish;
  end
  
endmodule