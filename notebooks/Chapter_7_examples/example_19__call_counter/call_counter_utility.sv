// call_counter_utility.sv
// Utility class demonstrating static functions with call counters

class statistics_tracker_class;
  
  // Static function to track total function calls across all instances
  static function void increment_total_calls();
    static int total_call_counter = 0;
    total_call_counter++;
    $display("Total calls made: %0d", total_call_counter);
  endfunction
  
  // Static function to track specific operation calls
  static function void track_operation_usage(string operation_name);
    static int operation_counter[string];
    
    if (operation_counter.exists(operation_name) == 0) begin
      operation_counter[operation_name] = 0;
    end
    
    operation_counter[operation_name]++;
    $display("Operation '%s' called %0d times", 
             operation_name, operation_counter[operation_name]);
  endfunction
  
  // Static function to get usage statistics report
  static function void print_usage_report();
    $display("=== Usage Statistics Report ===");
    $display("This report shows function call statistics");
  endfunction
  
endclass

// Simple module to demonstrate the utility
module call_counter_utility_module;
  
  initial begin
    $display("Call Counter Utility Demo");
    $display("==========================");
    
    // Demonstrate static function call counting
    statistics_tracker_class::increment_total_calls();
    statistics_tracker_class::track_operation_usage("read");
    statistics_tracker_class::track_operation_usage("write");
    statistics_tracker_class::track_operation_usage("read");
    statistics_tracker_class::increment_total_calls();
    
    $display();
    statistics_tracker_class::print_usage_report();
  end
  
endmodule