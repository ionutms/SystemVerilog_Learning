// vehicle_fleet_system.sv
package vehicle_fleet_pkg;

  // Base Vehicle class with virtual methods for polymorphism
  virtual class Vehicle;
    string vehicle_id;
    real mileage;
    real fuel_capacity;
    real fuel_level;
    real last_maintenance_miles;
    
    function new(string id, real capacity);
      vehicle_id = id;
      fuel_capacity = capacity;
      fuel_level = capacity;
      mileage = 0.0;
      last_maintenance_miles = 0.0;
    endfunction
    
    // Pure virtual methods - must be implemented by derived classes
    pure virtual function real calculate_fuel_consumption(real distance);
    pure virtual function int get_maintenance_interval();
    pure virtual function string get_vehicle_type();
    
    // Common methods for all vehicles
    function void drive(real distance);
      real fuel_consumed = calculate_fuel_consumption(distance);
      mileage += distance;
      fuel_level -= fuel_consumed;
      $display("  %s drove %.1f miles, fuel level: %.1f/%.1f", 
               vehicle_id, distance, fuel_level, fuel_capacity);
    endfunction
    
    function bit needs_maintenance();
      real interval = get_maintenance_interval();
      return (mileage - last_maintenance_miles) >= interval;
    endfunction
    
    function void perform_maintenance();
      last_maintenance_miles = mileage;
      $display("  %s maintenance completed at %.1f miles", 
               vehicle_id, mileage);
    endfunction
    
    function void refuel();
      fuel_level = fuel_capacity;
      $display("  %s refueled to %.1f gallons", vehicle_id, fuel_capacity);
    endfunction
    
    function void display_status();
      $display("  %s (%s): %.1f miles, fuel: %.1f/%.1f, maintenance: %s", 
               vehicle_id, get_vehicle_type(), mileage, fuel_level, 
               fuel_capacity, needs_maintenance() ? "NEEDED" : "OK");
    endfunction
  endclass

  // Car class - good fuel efficiency, frequent maintenance
  class Car extends Vehicle;
    function new(string id);
      super.new(id, 15.0); // 15 gallon tank
    endfunction
    
    function real calculate_fuel_consumption(real distance);
      return distance / 30.0; // 30 MPG
    endfunction
    
    function int get_maintenance_interval();
      return 5000; // Every 5000 miles
    endfunction
    
    function string get_vehicle_type();
      return "Car";
    endfunction
  endclass

  // Truck class - poor fuel efficiency, less frequent maintenance
  class Truck extends Vehicle;
    function new(string id);
      super.new(id, 25.0); // 25 gallon tank
    endfunction
    
    function real calculate_fuel_consumption(real distance);
      return distance / 15.0; // 15 MPG
    endfunction
    
    function int get_maintenance_interval();
      return 8000; // Every 8000 miles
    endfunction
    
    function string get_vehicle_type();
      return "Truck";
    endfunction
  endclass

  // Motorcycle class - excellent fuel efficiency, frequent maintenance
  class Motorcycle extends Vehicle;
    function new(string id);
      super.new(id, 4.0); // 4 gallon tank
    endfunction
    
    function real calculate_fuel_consumption(real distance);
      return distance / 45.0; // 45 MPG
    endfunction
    
    function int get_maintenance_interval();
      return 3000; // Every 3000 miles
    endfunction
    
    function string get_vehicle_type();
      return "Motorcycle";
    endfunction
  endclass

  // Fleet management class
  class VehicleFleet;
    Vehicle fleet[$]; // Dynamic array of vehicles
    
    function void add_vehicle(Vehicle v);
      fleet.push_back(v);
      $display("Added %s (%s) to fleet", v.vehicle_id, v.get_vehicle_type());
    endfunction
    
    function void drive_all_vehicles(real distance);
      $display("\n--- Driving all vehicles %.1f miles ---", distance);
      foreach (fleet[i]) begin
        fleet[i].drive(distance);
      end
    endfunction
    
    function void check_maintenance_needs();
      $display("\n--- Checking maintenance needs ---");
      foreach (fleet[i]) begin
        if (fleet[i].needs_maintenance()) begin
          $display("  %s needs maintenance!", fleet[i].vehicle_id);
          fleet[i].perform_maintenance();
        end else begin
          $display("  %s maintenance OK", fleet[i].vehicle_id);
        end
      end
    endfunction
    
    function void refuel_all_vehicles();
      $display("\n--- Refueling all vehicles ---");
      foreach (fleet[i]) begin
        fleet[i].refuel();
      end
    endfunction
    
    function void display_fleet_status();
      $display("\n--- Fleet Status ---");
      foreach (fleet[i]) begin
        fleet[i].display_status();
      end
    endfunction
    
    function real calculate_total_fuel_consumption(real distance);
      real total_fuel = 0.0;
      foreach (fleet[i]) begin
        total_fuel += fleet[i].calculate_fuel_consumption(distance);
      end
      return total_fuel;
    endfunction
  endclass

endpackage

module vehicle_fleet_system;
  import vehicle_fleet_pkg::*;
  
  // Fleet management system demonstration
  initial begin
    VehicleFleet fleet;
    Car car1, car2;
    Truck truck1;
    Motorcycle bike1;
    real trip_distance = 100.0;
    
    $display("=== Vehicle Fleet Management System ===");
    
    // Create fleet and vehicles
    fleet = new();
    car1 = new("CAR-001");
    car2 = new("CAR-002");
    truck1 = new("TRUCK-001");
    bike1 = new("BIKE-001");
    
    // Add vehicles to fleet
    $display("\n--- Building Fleet ---");
    fleet.add_vehicle(car1);
    fleet.add_vehicle(car2);
    fleet.add_vehicle(truck1);
    fleet.add_vehicle(bike1);
    
    // Show initial status
    fleet.display_fleet_status();
    
    // Calculate fuel consumption for a trip
    $display("\n--- Fuel Consumption Analysis ---");
    $display("Total fuel needed for %.1f mile trip: %.2f gallons", 
             trip_distance, fleet.calculate_total_fuel_consumption(trip_distance));
    
    // Simulate driving
    fleet.drive_all_vehicles(trip_distance);
    fleet.display_fleet_status();
    
    // Drive more to trigger maintenance
    fleet.drive_all_vehicles(2500.0);
    fleet.drive_all_vehicles(2500.0);
    fleet.check_maintenance_needs();
    
    // Refuel all vehicles
    fleet.refuel_all_vehicles();
    fleet.display_fleet_status();
    
    $display("\n=== Fleet Management Demo Complete ===");
  end

endmodule