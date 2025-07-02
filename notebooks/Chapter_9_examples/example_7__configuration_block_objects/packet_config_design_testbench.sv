// packet_config_design_testbench.sv
module packet_config_testbench;
  // Instantiate design under test
  packet_config_module PACKET_CONFIG_INSTANCE();
  
  initial begin
    // Dump waves for debugging
    $dumpfile("packet_config_testbench.vcd");
    $dumpvars(0, packet_config_testbench);
    
    // Wait for design to complete
    #10;
    
    $display();
    $display("=== Testbench: Configuration Objects Test Complete ===");
    $display("Multiple packet configurations created with different");
    $display("constructor parameters demonstrating flexible object");
    $display("initialization patterns.");
    $display();
    
    // Finish simulation
    $finish;
  end
endmodule