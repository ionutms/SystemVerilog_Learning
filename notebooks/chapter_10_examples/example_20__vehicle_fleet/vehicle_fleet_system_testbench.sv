// vehicle_fleet_system_testbench.sv
module vehicle_fleet_testbench;
  import vehicle_fleet_pkg::*;
  
  // Instantiate the design under test
  vehicle_fleet_system fleet_system_instance();
  
  // Additional test scenarios
  initial begin
    VehicleFleet test_fleet;
    Car economy_car;
    Truck heavy_truck;
    Motorcycle sport_bike;
    
    // Setup wave dumping
    $dumpfile("vehicle_fleet_testbench.vcd");
    $dumpvars(0, vehicle_fleet_testbench);
    
    // Wait for main system to complete
    #1;
    
    $display("\n\n=== Additional Test Scenarios ===");
    
    // Test polymorphic behavior with different vehicle types
    test_fleet = new();
    economy_car = new("ECON-001");
    heavy_truck = new("HEAVY-001");
    sport_bike = new("SPORT-001");
    
    test_fleet.add_vehicle(economy_car);
    test_fleet.add_vehicle(heavy_truck);
    test_fleet.add_vehicle(sport_bike);
    
    // Test fuel efficiency comparison
    $display("\n--- Fuel Efficiency Comparison (200 miles) ---");
    $display("Car fuel consumption: %.2f gallons", 
             economy_car.calculate_fuel_consumption(200.0));
    $display("Truck fuel consumption: %.2f gallons", 
             heavy_truck.calculate_fuel_consumption(200.0));
    $display("Motorcycle fuel consumption: %.2f gallons", 
             sport_bike.calculate_fuel_consumption(200.0));
    
    // Test maintenance intervals
    $display("\n--- Maintenance Interval Comparison ---");
    $display("Car maintenance interval: %0d miles", 
             economy_car.get_maintenance_interval());
    $display("Truck maintenance interval: %0d miles", 
             heavy_truck.get_maintenance_interval());
    $display("Motorcycle maintenance interval: %0d miles", 
             sport_bike.get_maintenance_interval());
    
    // Test long-distance driving scenario
    $display("\n--- Long Distance Driving Test ---");
    test_fleet.drive_all_vehicles(3000.0);
    test_fleet.check_maintenance_needs();
    
    // Test multiple maintenance cycles
    $display("\n--- Multiple Maintenance Cycles ---");
    test_fleet.drive_all_vehicles(5000.0);
    test_fleet.check_maintenance_needs();
    test_fleet.drive_all_vehicles(3000.0);
    test_fleet.check_maintenance_needs();
    
    // Final fleet status
    test_fleet.display_fleet_status();
    
    $display("\n=== Testbench Complete ===");
    
    // Small delay before finish
    #10;
    $finish;
  end
  
  // Monitor for any potential issues
  initial begin
    #1000; // Timeout after 1000 time units
    $display("WARNING: Testbench timeout reached");
    $finish;
  end

endmodule