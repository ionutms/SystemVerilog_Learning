// search_algorithms_module_testbench.sv
module search_testbench_module;

  // Instantiate design under test
  search_algorithms_module SEARCH_ALGORITHM_INSTANCE();

  // Test data arrays
  int test_array[8] = '{10, 25, 33, 47, 52, 68, 74, 89};
  int sorted_test_array[8] = '{10, 25, 33, 47, 52, 68, 74, 89};
  int duplicate_array[8] = '{15, 25, 25, 25, 40, 55, 70, 85};
  
  int search_result;

  initial begin
    // Setup waveform dumping
    $dumpfile("search_testbench_module.vcd");
    $dumpvars(0, search_testbench_module);
    
    $display("=== Testing Search Functions with Early Returns ===");
    $display();
    
    // Display test arrays
    $display("Test array: %p", test_array);
    $display("Sorted array: %p", sorted_test_array);
    $display("Array with duplicates: %p", duplicate_array);
    $display();
    
    // Test linear search with early return
    $display("--- Linear Search Tests ---");
    search_result = SEARCH_ALGORITHM_INSTANCE.
                    linear_search_with_early_return(test_array, 47);
    search_result = SEARCH_ALGORITHM_INSTANCE.
                    linear_search_with_early_return(test_array, 99);
    $display();
    
    // Test binary search with early return
    $display("--- Binary Search Tests ---");
    search_result = SEARCH_ALGORITHM_INSTANCE.
                    binary_search_with_early_return(sorted_test_array, 52);
    search_result = SEARCH_ALGORITHM_INSTANCE.
                    binary_search_with_early_return(sorted_test_array, 30);
    $display();
    
    // Test first occurrence search with early return
    $display("--- First Occurrence Search Tests ---");
    search_result = SEARCH_ALGORITHM_INSTANCE.
                    find_first_occurrence_with_early_return(
                      duplicate_array, 25);
    search_result = SEARCH_ALGORITHM_INSTANCE.
                    find_first_occurrence_with_early_return(
                      duplicate_array, 60);
    $display();
    
    $display("=== Search Functions Testing Complete ===");
    $display();
    
    #10;  // Wait before finishing
  end

endmodule