// handle_vs_object_copying_testbench.sv
// Testbench for handle vs object copying demonstration

module handle_vs_object_copying_testbench;

  // Instantiate the design module
  handle_vs_object_copying_module DESIGN_INSTANCE();

  initial begin
    // Dump waves for verilator
    $dumpfile("handle_vs_object_copying_testbench.vcd");
    $dumpvars(0, handle_vs_object_copying_testbench);
    
    // Wait for design to complete
    #10;
    
    $display();
    $display("=== Testbench Complete ===");
    $display("Handle vs Object Copying example finished successfully!");
    
    // Finish simulation
    $finish;
  end

endmodule