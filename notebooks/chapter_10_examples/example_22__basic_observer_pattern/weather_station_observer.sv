// weather_station_observer.sv
package weather_observer_pkg;
  
  // Observer interface - defines the contract for observers
  virtual class observer_interface;
    pure virtual function void update(real temperature, real humidity, 
                                     real pressure);
  endclass
  
  // Subject interface - defines the contract for subjects
  virtual class subject_interface;
    protected observer_interface observers[$];
    
    virtual function void attach_observer(observer_interface obs);
      observers.push_back(obs);
      $display("[SUBJECT] Observer attached. Total observers: %0d", 
               observers.size());
    endfunction
    
    virtual function void detach_observer(observer_interface obs);
      for (int i = 0; i < observers.size(); i++) begin
        if (observers[i] == obs) begin
          observers.delete(i);
          $display("[SUBJECT] Observer detached. Remaining: %0d", 
                   observers.size());
          break;
        end
      end
    endfunction
    
    virtual function void notify_observers();
      // To be implemented by concrete subjects
    endfunction
  endclass
  
  // Concrete Subject - WeatherStation
  class weather_station extends subject_interface;
    protected real temperature;
    protected real humidity;
    protected real pressure;
    
    function new();
      temperature = 0.0;
      humidity = 0.0;
      pressure = 0.0;
    endfunction
    
    function void set_measurements(real temp, real humid, real press);
      temperature = temp;
      humidity = humid;
      pressure = press;
      $display("[WEATHER_STATION] New measurements recorded:");
      $display("  Temperature: %0.1f C", temperature);
      $display("  Humidity: %0.1f%%", humidity);
      $display("  Pressure: %0.1f hPa", pressure);
      notify_observers();
    endfunction
    
    virtual function void notify_observers();
      $display("[WEATHER_STATION] Notifying %0d observers...", 
               observers.size());
      foreach (observers[i]) begin
        observers[i].update(temperature, humidity, pressure);
      end
    endfunction
    
    function real get_temperature();
      return temperature;
    endfunction
    
    function real get_humidity();
      return humidity;
    endfunction
    
    function real get_pressure();
      return pressure;
    endfunction
  endclass
  
  // Concrete Observer - Current Conditions Display
  class current_conditions_display extends observer_interface;
    protected real temperature;
    protected real humidity;
    protected real pressure;
    protected string display_name;
    
    function new(string name = "Current Conditions");
      display_name = name;
    endfunction
    
    virtual function void update(real temp, real humid, real press);
      temperature = temp;
      humidity = humid;
      pressure = press;
      display();
    endfunction
    
    function void display();
      $display("[%s] Current conditions:", display_name);
      $display("  Temperature: %0.1f C", temperature);
      $display("  Humidity: %0.1f%%", humidity);
      $display("  Pressure: %0.1f hPa", pressure);
    endfunction
  endclass
  
  // Concrete Observer - Statistics Display
  class statistics_display extends observer_interface;
    protected real temp_sum;
    protected real temp_min;
    protected real temp_max;
    protected int measurement_count;
    protected string display_name;
    
    function new(string name = "Statistics");
      display_name = name;
      temp_sum = 0.0;
      temp_min = 999.0;
      temp_max = -999.0;
      measurement_count = 0;
    endfunction
    
    virtual function void update(real temp, real humid, real press);
      temp_sum += temp;
      measurement_count++;
      
      if (temp < temp_min) temp_min = temp;
      if (temp > temp_max) temp_max = temp;
      
      display();
    endfunction
    
    function void display();
      real avg_temp = temp_sum / measurement_count;
      $display("[%s] Temperature statistics:", display_name);
      $display("  Average: %0.1f C", avg_temp);
      $display("  Min: %0.1f C", temp_min);
      $display("  Max: %0.1f C", temp_max);
      $display("  Measurements: %0d", measurement_count);
    endfunction
  endclass
  
  // Concrete Observer - Forecast Display
  class forecast_display extends observer_interface;
    protected real last_pressure;
    protected string display_name;
    
    function new(string name = "Forecast");
      display_name = name;
      last_pressure = 0.0;
    endfunction
    
    virtual function void update(real temp, real humid, real press);
      string forecast;
      
      if (last_pressure == 0.0) begin
        forecast = "No trend data available";
      end else if (press > last_pressure) begin
        forecast = "Improving weather on the way!";
      end else if (press < last_pressure) begin
        forecast = "Watch out for cooler, rainy weather";
      end else begin
        forecast = "More of the same";
      end
      
      last_pressure = press;
      display(forecast);
    endfunction
    
    function void display(string forecast);
      $display("[%s] Weather forecast:", display_name);
      $display("  %s", forecast);
    endfunction
  endclass

endpackage

// Top-level design module
module weather_station_observer;
  import weather_observer_pkg::*;
  
  // Declare objects
  weather_station station;
  current_conditions_display current_display;
  statistics_display stats_display;
  forecast_display forecast_display_obj;
  
  initial begin
    $display("=== Basic Observer Pattern Example ===");
    $display();
    
    // Create the weather station (subject)
    station = new();
    
    // Create observers
    current_display = new("Current Conditions Display");
    stats_display = new("Statistics Display");
    forecast_display_obj = new("Forecast Display");
    
    // Register observers with the subject
    $display("--- Registering Observers ---");
    station.attach_observer(current_display);
    station.attach_observer(stats_display);
    station.attach_observer(forecast_display_obj);
    $display();
    
    // Simulate weather measurements
    $display("--- First Weather Update ---");
    station.set_measurements(25.5, 65.0, 1013.2);
    $display();
    
    $display("--- Second Weather Update ---");
    station.set_measurements(27.3, 70.0, 1015.8);
    $display();
    
    $display("--- Third Weather Update ---");
    station.set_measurements(23.1, 60.0, 1010.5);
    $display();
    
    // Demonstrate observer removal
    $display("--- Removing Statistics Display ---");
    station.detach_observer(stats_display);
    $display();
    
    $display("--- Fourth Weather Update (fewer observers) ---");
    station.set_measurements(26.0, 68.0, 1012.0);
    $display();
    
    $display("=== Observer Pattern Example Complete ===");
  end

endmodule