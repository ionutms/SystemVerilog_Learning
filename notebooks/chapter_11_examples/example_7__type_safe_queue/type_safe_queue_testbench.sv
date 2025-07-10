// type_safe_queue_testbench.sv
// Comprehensive testbench for type-safe queue implementation

module type_safe_queue_testbench;

  import type_safe_queue_pkg::*;
  
  // Test queue instances
  IntQueue small_int_queue;
  ByteQueue word_queue;
  StringQueue test_string_queue;
  
  // Test data
  int test_values[] = {10, 20, 30, 40, 50, 60, 70};
  bit [7:0] test_bytes[] = {8'hAB, 8'h12, 8'hFE, 8'h56};
  string test_strings[] = {"First", "Second", "Third", "Fourth", "Fifth"};
  
  // Test results tracking
  int test_pass_count = 0;
  int test_fail_count = 0;
  
  // Test assertion macro
  `define ASSERT(condition, message) \
    if (condition) begin \
      $display("PASS: %s", message); \
      test_pass_count++; \
    end else begin \
      $display("FAIL: %s", message); \
      test_fail_count++; \
    end
  
  // Instantiate design under test
  type_safe_queue_design DESIGN_INSTANCE();
  
  initial begin
    // Setup waveform dumping
    $dumpfile("type_safe_queue_testbench.vcd");
    $dumpvars(0, type_safe_queue_testbench);
    
    $display("=== Type-Safe Queue Testbench Started ===");
    
    // Initialize queue instances
    small_int_queue = new();
    word_queue = new();
    test_string_queue = new();
    
    // Run all tests
    test_basic_operations();
    test_boundary_conditions();
    test_type_safety();
    test_queue_overflow_underflow();
    test_peek_operations();
    test_mixed_operations();
    
    // Display final results
    display_test_results();
    
    #10; // Wait before finishing
    $display("=== Testbench Complete ===");
    $finish;
  end
  
  // Test basic enqueue/dequeue operations
  task automatic test_basic_operations();
    int dequeued_value;
    bit success;
    
    $display("\n=== Test: Basic Operations ===");
    
    // Test enqueue
    success = small_int_queue.enqueue(100);
    `ASSERT(success, "Enqueue operation successful");
    `ASSERT(small_int_queue.size() == 1, "Queue size is 1 after enqueue");
    
    // Test dequeue
    success = small_int_queue.dequeue(dequeued_value);
    `ASSERT(success, "Dequeue operation successful");
    `ASSERT(dequeued_value == 100, "Dequeued correct value");
    `ASSERT(small_int_queue.size() == 0, "Queue size is 0 after dequeue");
    
    small_int_queue.display_queue();
  endtask
  
  // Test boundary conditions
  task automatic test_boundary_conditions();
    int dummy_value;
    bit success;
    int i;
    
    $display("\n=== Test: Boundary Conditions ===");
    
    // Test empty queue
    `ASSERT(small_int_queue.is_empty(), "New queue is empty");
    `ASSERT(!small_int_queue.is_full(), "New queue is not full");
    
    // Fill queue to capacity
    for (i = 0; i < 10; i++) begin
      success = small_int_queue.enqueue(i * 10);
      `ASSERT(success, $sformatf("Enqueue item %0d successful", i));
    end
    
    // Test full queue
    `ASSERT(small_int_queue.is_full(), "Queue is full after filling");
    `ASSERT(small_int_queue.size() == 10, "Queue size is 10 when full");
    
    small_int_queue.display_queue();
    
    // Clear queue for next test
    small_int_queue.clear();
    `ASSERT(small_int_queue.is_empty(), "Queue is empty after clear");
  endtask
  
  // Test type safety with different data types
  task automatic test_type_safety();
    bit [7:0] byte_value;
    string string_value;
    bit success;
    
    $display("\n=== Test: Type Safety ===");
    
    // Test byte queue
    success = word_queue.enqueue(8'hDE);
    `ASSERT(success, "Byte enqueue successful");
    
    success = word_queue.enqueue(8'hAD);
    `ASSERT(success, "Second byte enqueue successful");
    
    word_queue.display_queue();
    
    success = word_queue.dequeue(byte_value);
    `ASSERT(success && byte_value == 8'hDE, "Byte dequeue correct");
    
    // Test string queue
    success = test_string_queue.enqueue("TypeSafe");
    `ASSERT(success, "String enqueue successful");
    
    success = test_string_queue.enqueue("Queue");
    `ASSERT(success, "Second string enqueue successful");
    
    test_string_queue.display_queue();
    
    success = test_string_queue.dequeue(string_value);
    `ASSERT(success && string_value == "TypeSafe", "String dequeue correct");
  endtask
  
  // Test overflow and underflow conditions
  task automatic test_queue_overflow_underflow();
    int dummy_value;
    bit success;
    int i;
    
    $display("\n=== Test: Overflow/Underflow ===");
    
    // Test underflow on empty queue
    success = small_int_queue.dequeue(dummy_value);
    `ASSERT(!success, "Dequeue from empty queue fails correctly");
    
    // Fill queue beyond capacity
    for (i = 0; i < 12; i++) begin
      success = small_int_queue.enqueue(i);
      if (i < 10) begin
        `ASSERT(success, $sformatf("Enqueue %0d successful", i));
      end else begin
        `ASSERT(!success, $sformatf("Enqueue %0d fails when full", i));
      end
    end
    
    small_int_queue.display_queue();
    small_int_queue.clear();
  endtask
  
  // Test peek operations
  task automatic test_peek_operations();
    int front_value, rear_value;
    bit success;
    
    $display("\n=== Test: Peek Operations ===");
    
    // Test peek on empty queue
    success = small_int_queue.peek_front(front_value);
    `ASSERT(!success, "Peek front on empty queue fails correctly");
    
    // Add some elements
    success = small_int_queue.enqueue(111);
    `ASSERT(success, "Enqueue 111 successful");
    
    success = small_int_queue.enqueue(222);
    `ASSERT(success, "Enqueue 222 successful");
    
    success = small_int_queue.enqueue(333);
    `ASSERT(success, "Enqueue 333 successful");
    
    // Test peek operations
    success = small_int_queue.peek_front(front_value);
    `ASSERT(success && front_value == 111, "Peek front returns correct value");
    
    success = small_int_queue.peek_rear(rear_value);
    `ASSERT(success && rear_value == 333, "Peek rear returns correct value");
    
    // Verify peek doesn't modify queue
    `ASSERT(small_int_queue.size() == 3, "Queue size unchanged after peek");
    
    small_int_queue.display_queue();
    small_int_queue.clear();
  endtask
  
  // Test mixed operations scenario
  task automatic test_mixed_operations();
    int values_to_test[] = {5, 15, 25, 35, 45};
    int dequeued_val;
    bit success;
    int i;
    
    $display("\n=== Test: Mixed Operations ===");
    
    // Enqueue some values
    for (i = 0; i < 3; i++) begin
      success = small_int_queue.enqueue(values_to_test[i]);
      `ASSERT(success, $sformatf("Mixed test enqueue %0d", i));
    end
    
    // Dequeue one
    success = small_int_queue.dequeue(dequeued_val);
    `ASSERT(success && dequeued_val == 5, "Mixed test dequeue correct");
    
    // Enqueue more
    for (i = 3; i < 5; i++) begin
      success = small_int_queue.enqueue(values_to_test[i]);
      `ASSERT(success, $sformatf("Mixed test enqueue %0d", i));
    end
    
    small_int_queue.display_queue();
    
    // Verify final state
    `ASSERT(small_int_queue.size() == 4, "Mixed test final size correct");
    
    // Test circular buffer behavior
    for (i = 0; i < 6; i++) begin
      success = small_int_queue.enqueue(50 + i);
      `ASSERT(success, $sformatf("Circular buffer enqueue %0d successful", i));
    end
    `ASSERT(small_int_queue.is_full(), "Queue is full after circular fill");
    
    small_int_queue.display_queue();
    small_int_queue.clear();
  endtask
  
  // Display final test results
  task automatic display_test_results();
    $display("\n=== Final Test Results ===");
    $display("Tests Passed: %0d", test_pass_count);
    $display("Tests Failed: %0d", test_fail_count);
    $display("Total Tests:  %0d", test_pass_count + test_fail_count);
    
    if (test_fail_count == 0) begin
      $display("*** ALL TESTS PASSED! ***");
    end else begin
      $display("*** SOME TESTS FAILED ***");
    end
    $display("=========================");
  endtask

endmodule