// call_counter_utility_testbench.sv
// Testbench for call counter utility demonstration

module call_counter_testbench_module;
  
  // Instantiate the design under test
  call_counter_utility_module COUNTER_UTILITY_INSTANCE();
  
  initial begin
    // Dump waves for simulation
    $dumpfile("call_counter_testbench_module.vcd");
    $dumpvars(0, call_counter_testbench_module);
    
    $display("Testbench: Call Counter Utility Test");
    $display("=====================================");
    
    // Wait for design to complete
    #10;
    
    $display();
    $display("Testbench: Additional counter tests");
    
    // Test multiple calls to demonstrate persistent counters
    statistics_tracker_class::track_operation_usage("delete");
    statistics_tracker_class::track_operation_usage("write");
    statistics_tracker_class::track_operation_usage("delete");
    statistics_tracker_class::increment_total_calls();
    
    $display();
    $display("Testbench: Final statistics");
    statistics_tracker_class::print_usage_report();
    
    // End simulation
    #5;
    $display();
    $display("Testbench: Simulation completed successfully");
    $finish;
  end
  
endmodule