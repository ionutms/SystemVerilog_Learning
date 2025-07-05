// sensor_interface_design.sv
package sensor_interface_pkg;

  // Base sensor class with pure virtual method
  virtual class BaseSensor;
    protected string sensor_name;
    protected int sensor_id;
    
    // Constructor
    function new(string name = "Unknown", int id = 0);
      this.sensor_name = name;
      this.sensor_id = id;
    endfunction
    
    // Pure virtual method - must be implemented by derived classes
    pure virtual function real read_value();
    
    // Common method for all sensors
    virtual function string get_sensor_info();
      return $sformatf("Sensor: %s (ID: %0d)", sensor_name, sensor_id);
    endfunction
    
    // Display sensor reading with formatting
    virtual function void display_reading();
      real value = read_value();
      $display("%s - Reading: %0.2f", get_sensor_info(), value);
    endfunction
    
  endclass

  // Temperature sensor implementation
  class TemperatureSensor extends BaseSensor;
    local real temperature_celsius;
    
    // Constructor
    function new(string name = "Temperature", int id = 0, 
                 real initial_temp = 25.0);
      super.new(name, id);
      this.temperature_celsius = initial_temp;
    endfunction
    
    // Implement pure virtual method
    virtual function real read_value();
      // Simulate temperature reading with some variation
      int rand_val = $random % 10;
      real variation = (rand_val - 5) * 0.1;
      temperature_celsius = temperature_celsius + variation;
      return temperature_celsius;
    endfunction
    
    // Temperature-specific method
    function real get_fahrenheit();
      return (read_value() * 9.0/5.0) + 32.0;
    endfunction
    
    // Override display method for temperature-specific formatting
    virtual function void display_reading();
      real celsius = read_value();
      real fahrenheit = (celsius * 9.0/5.0) + 32.0;
      $display("%s - Temperature: %0.2f°C (%0.2f°F)", 
               get_sensor_info(), celsius, fahrenheit);
    endfunction
    
  endclass

  // Humidity sensor implementation
  class HumiditySensor extends BaseSensor;
    local real humidity_percent;
    
    // Constructor
    function new(string name = "Humidity", int id = 0, 
                 real initial_humidity = 50.0);
      super.new(name, id);
      this.humidity_percent = initial_humidity;
    endfunction
    
    // Implement pure virtual method
    virtual function real read_value();
      // Simulate humidity reading with some variation
      int rand_val = $random % 20;
      real variation = (rand_val - 10) * 0.1;
      humidity_percent = humidity_percent + variation;
      // Clamp to valid range
      if (humidity_percent < 0.0) humidity_percent = 0.0;
      if (humidity_percent > 100.0) humidity_percent = 100.0;
      return humidity_percent;
    endfunction
    
    // Humidity-specific method
    function string get_humidity_level();
      real humidity = read_value();
      if (humidity < 30.0) return "Low";
      else if (humidity < 60.0) return "Normal";
      else return "High";
    endfunction
    
    // Override display method for humidity-specific formatting
    virtual function void display_reading();
      real humidity = read_value();
      string level = get_humidity_level();
      $display("%s - Humidity: %0.2f%% (%s)", 
               get_sensor_info(), humidity, level);
    endfunction
    
  endclass

endpackage

// Design module using the sensor interface
module sensor_interface_module;
  import sensor_interface_pkg::*;
  
  // Sensor instances
  TemperatureSensor temp_sensor_indoor;
  TemperatureSensor temp_sensor_outdoor;
  HumiditySensor humidity_sensor;
  
  // Array of base sensor handles for polymorphism
  BaseSensor sensor_array[];
  
  initial begin
    $display("=== Basic Sensor Interface Example ===");
    $display();
    
    // Create sensor instances
    temp_sensor_indoor = new("Indoor Temp", 1, 22.5);
    temp_sensor_outdoor = new("Outdoor Temp", 2, 15.0);
    humidity_sensor = new("Room Humidity", 3, 45.0);
    
    // Setup sensor array for polymorphic access
    sensor_array = new[3];
    sensor_array[0] = temp_sensor_indoor;
    sensor_array[1] = temp_sensor_outdoor;
    sensor_array[2] = humidity_sensor;
    
    $display("Initial sensor readings:");
    foreach(sensor_array[i]) begin
      sensor_array[i].display_reading();
    end
    
    $display();
    $display("Sensor readings after simulation time:");
    
    // Simulate some time passing and read sensors again
    for (int cycle = 0; cycle < 3; cycle++) begin
      $display("--- Cycle %0d ---", cycle + 1);
      foreach(sensor_array[i]) begin
        sensor_array[i].display_reading();
      end
      $display();
    end
    
    // Demonstrate specific sensor methods
    $display("=== Specific Sensor Features ===");
    $display("Indoor temperature in Fahrenheit: %0.2f°F", 
             temp_sensor_indoor.get_fahrenheit());
    $display("Humidity level: %s", humidity_sensor.get_humidity_level());
    
    $display();
    $display("=== Sensor Information ===");
    foreach(sensor_array[i]) begin
      $display("Sensor %0d: %s", i, sensor_array[i].get_sensor_info());
    end
    
  end
  
endmodule