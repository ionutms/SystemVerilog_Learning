// transportation_methods_testbench.sv
// Testbench for transportation methods example

module transportation_testbench;
  // Instantiate the transportation manager
  transportation_manager TRANSPORT_INSTANCE();
  
  initial begin
    // Dump waves for Verilator
    $dumpfile("transportation_testbench.vcd");
    $dumpvars(0, transportation_testbench);
    
    #1; // Wait for design to execute
    
    $display("=== Additional Transportation Tests ===");
    test_individual_transports();
    
    $display("=== Test Complete ===");
    $display();
  end
  
  // Additional test function
  function void test_individual_transports();
    Car test_car;
    Bike test_bike;
    Plane test_plane;
    
    $display("Testing individual transportation objects:");
    $display();
    
    // Test Car
    test_car = new("Test Car");
    $display("Creating and testing %s:", test_car.name);
    test_car.move();
    $display();
    
    // Test Bike
    test_bike = new("Test Bike");
    $display("Creating and testing %s:", test_bike.name);
    test_bike.move();
    $display();
    
    // Test Plane
    test_plane = new("Test Plane");
    $display("Creating and testing %s:", test_plane.name);
    test_plane.move();
    $display();
  endfunction
endmodule