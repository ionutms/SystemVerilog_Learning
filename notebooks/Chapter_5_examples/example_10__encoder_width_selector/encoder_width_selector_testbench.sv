// encoder_width_selector_testbench.sv
module encoder_width_selector_testbench;
  
  // Test different encoder widths by instantiating multiple design modules
  
  // 2-bit encoder instance
  encoder_width_selector #(.WIDTH(2)) ENCODER_2BIT();
  
  // 4-bit encoder instance  
  encoder_width_selector #(.WIDTH(4)) ENCODER_4BIT();
  
  // 8-bit encoder instance
  encoder_width_selector #(.WIDTH(8)) ENCODER_8BIT();
  
  // Unsupported width instance (will show error)
  encoder_width_selector #(.WIDTH(6)) ENCODER_UNSUPPORTED();

  initial begin
    // Dump waves
    $dumpfile("encoder_width_selector_testbench.vcd");
    $dumpvars(0, encoder_width_selector_testbench);
    
    $display();
    $display("Testing Encoder Width Selector with Generate Case");
    $display("==================================================");
    
    #1; // Allow time for all instances to execute
    
    $display();
    $display("=== Test Complete ===");
    $display("Check output to see different encoder widths selected");
    
    #1;
    $finish;
  end

endmodule