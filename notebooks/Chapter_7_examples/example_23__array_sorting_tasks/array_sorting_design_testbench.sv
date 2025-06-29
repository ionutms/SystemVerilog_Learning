// array_sorting_design_testbench.sv
module array_sorting_testbench;
  
  // Instantiate the design under test
  array_sorting_engine SORTING_ENGINE_INSTANCE();

  // Declare test arrays at module level
  int random_numbers[8];
  int mixed_values[6];
  int duplicate_numbers[8];

  initial begin
    // Configure wave dumping
    $dumpfile("array_sorting_testbench.vcd");
    $dumpvars(0, array_sorting_testbench);
    
    // Initialize test data arrays
    random_numbers = '{64, 34, 25, 12, 22, 11, 90, 5};
    mixed_values = '{100, -50, 0, 75, -25, 200};
    duplicate_numbers = '{5, 2, 8, 2, 9, 1, 5, 5};
    
    $display();
    $display("=== Testing Array Sorting Tasks ===");
    $display();
    
    // Test 1: Sort random numbers in ascending order
    $display("--- Test 1: Ascending Sort ---");
    SORTING_ENGINE_INSTANCE.display_array_8_contents(random_numbers, 
                                                     "Original array");
    SORTING_ENGINE_INSTANCE.sort_ascending_numbers(random_numbers);
    SORTING_ENGINE_INSTANCE.display_array_8_contents(random_numbers, 
                                                     "Sorted ascending");
    $display();
    
    // Test 2: Sort mixed values in descending order
    $display("--- Test 2: Descending Sort ---");
    SORTING_ENGINE_INSTANCE.display_array_6_contents(mixed_values, 
                                                     "Original array");
    SORTING_ENGINE_INSTANCE.sort_descending_numbers(mixed_values);
    SORTING_ENGINE_INSTANCE.display_array_6_contents(mixed_values, 
                                                     "Sorted descending");
    $display();
    
    // Test 3: Sort array with duplicates in ascending order
    $display("--- Test 3: Duplicates Ascending Sort ---");
    SORTING_ENGINE_INSTANCE.display_array_8_contents(duplicate_numbers, 
                                                     "Original array");
    SORTING_ENGINE_INSTANCE.sort_ascending_numbers(duplicate_numbers);
    SORTING_ENGINE_INSTANCE.display_array_8_contents(duplicate_numbers, 
                                                     "Sorted ascending");
    $display();
    
    $display("All sorting tests completed successfully!");
    $display();
    
    #10; // Wait before finishing
  end

endmodule