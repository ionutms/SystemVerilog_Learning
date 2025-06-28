// stack_processor_testbench.sv
module stack_processor_testbench;         // Testbench for stack processor

  // Instantiate the stack processor
  stack_processor STACK_PROCESSOR_INSTANCE();

  // Test variables
  logic [15:0] test_data_values [0:9] = {
    16'hABCD, 16'h1234, 16'hDEAD, 16'hBEEF, 16'hCAFE,
    16'hFACE, 16'hFEED, 16'hC0DE, 16'hDA7A, 16'hF00D
  };
  
  logic push_result, pop_result, peek_result;
  logic [15:0] popped_value, peeked_value;
  int test_iteration;

  initial begin
    // Setup waveform dumping
    $dumpfile("stack_processor_testbench.vcd");
    $dumpvars(0, stack_processor_testbench);
    
    $display();
    $display("=== Stack Processor Testbench Started ===");
    $display();
    
    // Wait for initialization
    #1;
    
    // Display initial stack status
    STACK_PROCESSOR_INSTANCE.display_stack_status();
    $display();
    
    // Test 1: Fill stack with data
    $display("TEST 1: Filling stack with test data");
    for (test_iteration = 0; test_iteration < 10; test_iteration++) begin
      push_result = STACK_PROCESSOR_INSTANCE.push_data_onto_stack(
        test_data_values[test_iteration]
      );
      #1;
    end
    STACK_PROCESSOR_INSTANCE.display_stack_status();
    $display();
    
    // Test 2: Peek at stack top
    $display("TEST 2: Peeking at stack top");
    peeked_value = STACK_PROCESSOR_INSTANCE.peek_stack_top(peek_result);
    if (peek_result) 
      $display("Successfully peeked value: 0x%04h", peeked_value);
    $display();
    
    // Test 3: Pop some values
    $display("TEST 3: Popping values from stack");
    for (test_iteration = 0; test_iteration < 5; test_iteration++) begin
      popped_value = STACK_PROCESSOR_INSTANCE.pop_data_from_stack(pop_result);
      if (pop_result)
        $display("Test iteration %0d: Successfully popped 0x%04h", 
                 test_iteration, popped_value);
      #1;
    end
    STACK_PROCESSOR_INSTANCE.display_stack_status();
    $display();
    
    // Test 4: Push more data
    $display("TEST 4: Pushing additional data");
    push_result = STACK_PROCESSOR_INSTANCE.push_data_onto_stack(16'h9999);
    push_result = STACK_PROCESSOR_INSTANCE.push_data_onto_stack(16'h8888);
    push_result = STACK_PROCESSOR_INSTANCE.push_data_onto_stack(16'h7777);
    STACK_PROCESSOR_INSTANCE.display_stack_status();
    $display();
    
    // Test 5: Empty the stack
    $display("TEST 5: Emptying the entire stack");
    test_iteration = 0;
    while (STACK_PROCESSOR_INSTANCE.stack_pointer > 0) begin
      popped_value = STACK_PROCESSOR_INSTANCE.pop_data_from_stack(pop_result);
      test_iteration++;
      #1;
    end
    STACK_PROCESSOR_INSTANCE.display_stack_status();
    $display();
    
    // Test 6: Try operations on empty stack
    $display("TEST 6: Testing operations on empty stack");
    popped_value = STACK_PROCESSOR_INSTANCE.pop_data_from_stack(pop_result);
    peeked_value = STACK_PROCESSOR_INSTANCE.peek_stack_top(peek_result);
    $display();
    
    $display("=== All Stack Tests Completed Successfully ===");
    $display();
    
    $finish;
  end

endmodule