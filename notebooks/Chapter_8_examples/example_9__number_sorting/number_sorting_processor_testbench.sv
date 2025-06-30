// number_sorting_processor_testbench.sv
module number_sorting_testbench;              // Testbench module
  
  // Instantiate design under test
  number_sorting_processor SORTING_PROCESSOR_INSTANCE();  
  
  // Additional testbench variables for testing
  int test_numbers[$];
  int found_count;
  int search_value;
  int sum_result;
  int temp_value;
  int i;
  
  initial begin
    // Dump waves
    $dumpfile("number_sorting_testbench.vcd");     // Specify VCD file
    $dumpvars(0, number_sorting_testbench);        // Dump all variables
    
    #1;                                            // Wait for time unit
    
    $display("Hello from number sorting testbench!");
    $display();                                    // Display empty line
    
    // Test additional queue operations
    test_numbers.push_back(100);
    test_numbers.push_back(25);
    test_numbers.push_back(75);
    test_numbers.push_back(50);
    test_numbers.push_back(75);  // Duplicate for testing
    
    $display("Test collection:");
    for (i = 0; i < test_numbers.size(); i++) begin
      $display("  Element %0d: %0d", i, test_numbers[i]);
    end
    
    // Test finding specific values
    search_value = 75;
    found_count = 0;
    $display("Searching for value: %0d", search_value);
    for (i = 0; i < test_numbers.size(); i++) begin
      if (test_numbers[i] == search_value) begin
        $display("  Found %0d at position %0d", search_value, i);
        found_count++;
      end
    end
    $display("Total occurrences of %0d: %0d", search_value, found_count);
    
    // Test finding numbers greater than threshold
    search_value = 50;
    found_count = 0;
    $display("Numbers greater than %0d:", search_value);
    for (i = 0; i < test_numbers.size(); i++) begin
      if (test_numbers[i] > search_value) begin
        $display("  Found: %0d", test_numbers[i]);
        found_count++;
      end
    end
    $display("Count of numbers > %0d: %0d", search_value, found_count);
    
    // Test sum calculation
    sum_result = 0;
    for (i = 0; i < test_numbers.size(); i++) begin
      sum_result += test_numbers[i];
    end
    $display("Sum of all numbers: %0d", sum_result);
    
    // Test queue operations: pop and push
    $display("Queue size before pop: %0d", test_numbers.size());
    if (test_numbers.size() > 0) begin
      temp_value = test_numbers.pop_back();
      $display("Popped value: %0d", temp_value);
      $display("Queue size after pop: %0d", test_numbers.size());
    end
    
    // Add new element
    test_numbers.push_front(999);
    $display("Added 999 to front, new size: %0d", test_numbers.size());
    $display("First element is now: %0d", test_numbers[0]);
    
    $display();                                    // Display empty line
    $display("Testbench verification completed!");
    
  end
  
endmodule