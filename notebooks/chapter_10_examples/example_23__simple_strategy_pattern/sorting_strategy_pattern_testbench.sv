// sorting_strategy_pattern_testbench.sv
module sorting_strategy_testbench;
  import sorting_strategy_pkg::*;
  
  // Instantiate design under test
  sorting_strategy_pattern DESIGN_INSTANCE();
  
  // Test data arrays
  int test_data1[] = '{64, 34, 25, 12, 22, 11, 90};
  int test_data2[] = '{64, 34, 25, 12, 22, 11, 90};
  int test_data3[] = '{64, 34, 25, 12, 22, 11, 90};
  int reference_data[] = '{64, 34, 25, 12, 22, 11, 90};
  
  // Strategy objects
  BubbleSortStrategy bubble_strategy;
  SelectionSortStrategy selection_strategy;
  InsertionSortStrategy insertion_strategy;
  SortingContext sort_context;
  
  initial begin
    // Initialize VCD dumping
    $dumpfile("sorting_strategy_testbench.vcd");
    $dumpvars(0, sorting_strategy_testbench);
    
    // Create strategy objects
    bubble_strategy = new();
    selection_strategy = new();
    insertion_strategy = new();
    
    // Create context with initial strategy
    sort_context = new(bubble_strategy);
    
    $display("=== Testing Strategy Pattern with Sorting Algorithms ===");
    $display();
    
    // Display original data
    $display("Original data: %p", reference_data);
    $display();
    
    // Test 1: Bubble Sort Strategy
    $display("--- Test 1: Bubble Sort Strategy ---");
    $display("Current strategy: %s", sort_context.get_current_strategy_name());
    display_array("Before sorting", test_data1);
    sort_context.execute_sort(test_data1);
    display_array("After sorting", test_data1);
    verify_sorted(test_data1, "Bubble Sort");
    $display();
    
    // Test 2: Selection Sort Strategy
    $display("--- Test 2: Selection Sort Strategy ---");
    sort_context.set_strategy(selection_strategy);
    $display("Current strategy: %s", sort_context.get_current_strategy_name());
    display_array("Before sorting", test_data2);
    sort_context.execute_sort(test_data2);
    display_array("After sorting", test_data2);
    verify_sorted(test_data2, "Selection Sort");
    $display();
    
    // Test 3: Insertion Sort Strategy
    $display("--- Test 3: Insertion Sort Strategy ---");
    sort_context.set_strategy(insertion_strategy);
    $display("Current strategy: %s", sort_context.get_current_strategy_name());
    display_array("Before sorting", test_data3);
    sort_context.execute_sort(test_data3);
    display_array("After sorting", test_data3);
    verify_sorted(test_data3, "Insertion Sort");
    $display();
    
    // Test 4: Strategy switching demonstration
    $display("--- Test 4: Strategy Switching Demonstration ---");
    demonstrate_strategy_switching();
    
    $display("=== Strategy Pattern Test Complete ===");
    $display();
    
    // Wait and finish
    #10;
    $finish;
  end
  
  // Helper function to display array contents
  function void display_array(string label, int data[]);
    $write("%s: [", label);
    for (int i = 0; i < data.size(); i++) begin
      if (i > 0) $write(", ");
      $write("%0d", data[i]);
    end
    $display("]");
  endfunction
  
  // Helper function to verify array is sorted
  function automatic void verify_sorted(int data[], string strategy_name);
    bit is_sorted = 1;
    for (int i = 0; i < data.size() - 1; i++) begin
      if (data[i] > data[i + 1]) begin
        is_sorted = 0;
        break;
      end
    end
    
    if (is_sorted) begin
      $display("✓ %s: Array is correctly sorted!", strategy_name);
    end else begin
      $display("✗ %s: Array is NOT sorted correctly!", strategy_name);
    end
  endfunction
  
  // Demonstrate dynamic strategy switching
  function automatic void demonstrate_strategy_switching();
    int demo_data[];
    int temp_data[];
    
    // Initialize arrays
    demo_data = new[6];
    demo_data = '{5, 2, 8, 1, 9, 3};
    
    $display("Demonstrating dynamic strategy switching:");
    $display("Original data: %p", demo_data);
    
    // Test with Bubble Sort
    temp_data = new[6];
    temp_data = '{5, 2, 8, 1, 9, 3};
    sort_context.set_strategy(bubble_strategy);
    $display("Switched to: Bubble Sort");
    sort_context.execute_sort(temp_data);
    $display("Result: %p", temp_data);
    $display();
    
    // Test with Selection Sort
    temp_data = '{5, 2, 8, 1, 9, 3};
    sort_context.set_strategy(selection_strategy);
    $display("Switched to: Selection Sort");
    sort_context.execute_sort(temp_data);
    $display("Result: %p", temp_data);
    $display();
    
    // Test with Insertion Sort
    temp_data = '{5, 2, 8, 1, 9, 3};
    sort_context.set_strategy(insertion_strategy);
    $display("Switched to: Insertion Sort");
    sort_context.execute_sort(temp_data);
    $display("Result: %p", temp_data);
    $display();
  endfunction
  
endmodule