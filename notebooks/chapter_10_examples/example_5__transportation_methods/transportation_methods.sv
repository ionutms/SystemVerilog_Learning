// transportation_methods.sv
// Transportation base class and derived classes example

// Base Transportation class
virtual class Transportation;
  string name;
  
  function new(string transport_name);
    this.name = transport_name;
  endfunction
  
  // Virtual method to be overridden by derived classes
  virtual function void move();
    $display("Generic transportation moving...");
  endfunction
  
  virtual function void show_info();
    $display("Transportation: %s", name);
  endfunction
endclass

// Car class - derived from Transportation
class Car extends Transportation;
  function new(string car_name);
    super.new(car_name);
  endfunction
  
  // Override move method
  virtual function void move();
    $display("Driving...");
  endfunction
endclass

// Bike class - derived from Transportation
class Bike extends Transportation;
  function new(string bike_name);
    super.new(bike_name);
  endfunction
  
  // Override move method
  virtual function void move();
    $display("Pedaling...");
  endfunction
endclass

// Plane class - derived from Transportation
class Plane extends Transportation;
  function new(string plane_name);
    super.new(plane_name);
  endfunction
  
  // Override move method
  virtual function void move();
    $display("Flying...");
  endfunction
endclass

// Transportation manager module
module transportation_manager();
  Car my_car;
  Bike my_bike;
  Plane my_plane;
  
  initial begin
    $display("=== Transportation Methods Example ===");
    $display();
    
    // Create instances of different transportation types
    my_car = new("Toyota Camry");
    my_bike = new("Mountain Bike");
    my_plane = new("Boeing 737");
    
    // Show info and demonstrate move methods
    my_car.show_info();
    my_car.move();
    $display();
    
    my_bike.show_info();
    my_bike.move();
    $display();
    
    my_plane.show_info();
    my_plane.move();
    $display();
    
    $display("=== Polymorphism Example ===");
    demonstrate_polymorphism();
  end
  
  // Function to demonstrate polymorphism
  function void demonstrate_polymorphism();
    Transportation transports[];
    Car poly_car;
    Bike poly_bike;
    Plane poly_plane;
    
    // Create array of different transportation types
    transports = new[3];
    
    // Create individual instances first
    poly_car = new("Honda Civic");
    poly_bike = new("Road Bike");
    poly_plane = new("Airbus A320");
    
    // Assign to base class array
    transports[0] = poly_car;
    transports[1] = poly_bike;
    transports[2] = poly_plane;
    
    // Call move() on each - polymorphic behavior
    foreach(transports[i]) begin
      transports[i].show_info();
      transports[i].move();
      $display();
    end
  endfunction
endmodule