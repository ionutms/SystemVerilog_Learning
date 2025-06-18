// clock_generator_testbench.sv
module clock_generator_testbench;  // Testbench module
  clock_generator CLK_GEN_DUT();   // Instantiate clock generator design under test

  initial begin
    // Dump waves
    $dumpfile("clock_generator_testbench.vcd");     // Specify the VCD file
    $dumpvars(0, clock_generator_testbench);        // Dump all variables in the test module
    #1;                                             // Wait for a time unit
    $display("Testbench: Starting clock generator validation...");
    
    // Monitor clock transitions
    $monitor("Time: %0t, Clock: %b", $time, CLK_GEN_DUT.clk);
    
    $display();                                     // Display empty line
    $display("Testbench: Clock generator validation initiated!");
    $display();                                     // Display empty line
  end

endmodule