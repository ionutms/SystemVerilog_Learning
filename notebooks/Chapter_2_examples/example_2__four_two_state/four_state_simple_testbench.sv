module four_state_simple_testbench;
  
  // Instantiate the design
  four_state_simple DUT();
  
  initial begin
    // Setup waveform dumping
    $dumpfile("four_state_simple.vcd");
    $dumpvars(0, four_state_simple_testbench);
    
    // Wait for design to complete
    #60;
    
    $display("\nTestbench finished - check waveforms!");
    $display();
    $finish;
  end

endmodule