// strategy_pattern_generics_testbench.sv
module strategy_pattern_testbench;
  import sorting_strategy_pkg::*;
  
  // Instantiate design under test
  strategy_pattern_generics DESIGN_INSTANCE();
  
  // Test variables
  int test_data1[$];
  int test_data2[$];
  int expected1[$];
  int expected2[$];
  shortint short_data[$];
  shortint expected_short[$];
  
  SortingContext#(int) int_context;
  SortingContext#(shortint) short_context;
  BubbleSortStrategy#(int) bubble_int;
  SelectionSortStrategy#(int) selection_int;
  BubbleSortStrategy#(shortint) bubble_short;
  
  initial begin
    // Setup waveform dumping
    $dumpfile("strategy_pattern_testbench.vcd");
    $dumpvars(0, strategy_pattern_testbench);
    
    #1; // Wait for design to complete
    
    $display("=== Testbench Verification ===");
    
    // Initialize test data
    test_data1.push_back(3);
    test_data1.push_back(1);
    test_data1.push_back(4);
    test_data1.push_back(1);
    test_data1.push_back(5);
    test_data1.push_back(9);
    test_data1.push_back(2);
    test_data1.push_back(6);
    
    expected1.push_back(1);
    expected1.push_back(1);
    expected1.push_back(2);
    expected1.push_back(3);
    expected1.push_back(4);
    expected1.push_back(5);
    expected1.push_back(6);
    expected1.push_back(9);
    
    // Test bubble sort strategy
    $display("Testing strategy switching...");
    bubble_int = new();
    int_context = new(bubble_int);
    $display("Original data: %p", test_data1);
    int_context.execute_sort(test_data1);
    $display("Sorted data: %p", test_data1);
    
    if (test_data1.size() == expected1.size()) begin
      automatic bit match = 1;
      for (int i = 0; i < test_data1.size(); i++) begin
        if (test_data1[i] != expected1[i]) match = 0;
      end
      if (match) begin
        $display("Bubble sort strategy test PASSED");
      end else begin
        $display("Bubble sort strategy test FAILED");
      end
    end else begin
      $display("Bubble sort strategy test FAILED - size mismatch");
    end
    
    // Initialize second test data
    test_data2.push_back(9);
    test_data2.push_back(5);
    test_data2.push_back(1);
    test_data2.push_back(8);
    test_data2.push_back(3);
    test_data2.push_back(7);
    test_data2.push_back(2);
    test_data2.push_back(4);
    
    expected2.push_back(1);
    expected2.push_back(2);
    expected2.push_back(3);
    expected2.push_back(4);
    expected2.push_back(5);
    expected2.push_back(7);
    expected2.push_back(8);
    expected2.push_back(9);
    
    // Test selection sort strategy
    selection_int = new();
    int_context.set_strategy(selection_int);
    $display("New data: %p", test_data2);
    int_context.execute_sort(test_data2);
    $display("Sorted data: %p", test_data2);
    
    if (test_data2.size() == expected2.size()) begin
      automatic bit match = 1;
      for (int i = 0; i < test_data2.size(); i++) begin
        if (test_data2[i] != expected2[i]) match = 0;
      end
      if (match) begin
        $display("Selection sort strategy test PASSED");
      end else begin
        $display("Selection sort strategy test FAILED");
      end
    end else begin
      $display("Selection sort strategy test FAILED - size mismatch");
    end
    
    $display();
    
    // Test generic capability with shortint
    short_data.push_back(-100);
    short_data.push_back(200);
    short_data.push_back(-50);
    short_data.push_back(150);
    short_data.push_back(0);
    
    expected_short.push_back(-100);
    expected_short.push_back(-50);
    expected_short.push_back(0);
    expected_short.push_back(150);
    expected_short.push_back(200);
    
    $display("Testing generic capability with shortint...");
    bubble_short = new();
    short_context = new(bubble_short);
    $display("Original shortint data: %p", short_data);
    short_context.execute_sort(short_data);
    $display("Sorted shortint data: %p", short_data);
    
    if (short_data.size() == expected_short.size()) begin
      automatic bit match = 1;
      for (int i = 0; i < short_data.size(); i++) begin
        if (short_data[i] != expected_short[i]) match = 0;
      end
      if (match) begin
        $display("Generic shortint sorting test PASSED");
      end else begin
        $display("Generic shortint sorting test FAILED");
      end
    end else begin
      $display("Generic shortint sorting test FAILED - size mismatch");
    end
    
    $display();
    $display("=== All Tests Completed ===");
    $finish;
  end

endmodule