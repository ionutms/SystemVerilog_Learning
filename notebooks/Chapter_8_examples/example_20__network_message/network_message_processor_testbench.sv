// network_message_processor_testbench.sv
module network_message_testbench;

  // Instantiate the network message processor
  network_message_processor MESSAGE_PROCESSOR_INSTANCE();

  initial begin
    // Dump waves for debugging
    $dumpfile("network_message_testbench.vcd");
    $dumpvars(0, network_message_testbench);
    
    $display("=== Network Message Testbench Started ===");
    $display();
    
    // Wait for the processor to complete
    #10;
    
    $display();
    $display("=== Network Message Testbench Completed ===");
    
    // Finish simulation
    $finish;
  end

endmodule