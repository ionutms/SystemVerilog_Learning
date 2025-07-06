// weather_station_observer_testbench.sv
module weather_station_testbench;
  
  // Instantiate the design under test
  weather_station_observer WEATHER_OBSERVER_INSTANCE();
  
  initial begin
    // Dump waves for debugging
    $dumpfile("weather_station_testbench.vcd");
    $dumpvars(0, weather_station_testbench);
    
    // Wait for design to complete
    #100;
    
    $display("Hello from weather station observer testbench!");
    $display();
    
    // Simulation complete
    $finish;
  end

endmodule