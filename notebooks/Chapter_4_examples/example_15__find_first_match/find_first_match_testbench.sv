// find_first_match_testbench.sv
module find_first_match_testbench;  // Testbench module
  array_searcher SEARCH_DUT();  // Instantiate array searcher design under test

  initial begin
    // Dump waves
    $dumpfile("find_first_match_testbench.vcd");      // Specify the VCD file
    $dumpvars(0, find_first_match_testbench);         // Dump all variables in the test module
    #1;                                               // Wait for a time unit

    $display();                                       // Display empty line
    $display("Testbench: Starting array search function verification...");
    $display();                                       // Display empty line
    
    // Wait for design to complete processing
    #150;
    
    $display("Testbench: Array search function verification completed!");
    $display("Testbench: Check output for search results and function behavior.");
    $display();                                       // Display empty line
    
    // End simulation
    $finish;
  end

endmodule