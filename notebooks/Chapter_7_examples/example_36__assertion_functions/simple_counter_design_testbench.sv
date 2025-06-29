// simple_counter_design_testbench.sv
module counter_assertion_testbench;

  // Test signals
  logic       clock_signal;
  logic       reset_signal;
  logic       enable_signal;
  logic [3:0] counter_output;
  
  // Test statistics
  int         passed_assertion_count = 0;
  int         failed_assertion_count = 0;

  // Instantiate design under test
  simple_counter_module COUNTER_INSTANCE (
    .clock_signal(clock_signal),
    .reset_signal(reset_signal),
    .enable_signal(enable_signal),
    .counter_output(counter_output)
  );

  // Clock generation
  initial begin
    clock_signal = 0;
    forever #5 clock_signal = ~clock_signal;
  end

  // Assertion function for equality check
  function void assert_equals_function(
    input logic [3:0] expected_value,
    input logic [3:0] actual_value,
    input string      test_description
  );
    if (expected_value === actual_value) begin
      $display("[PASS] %s: Expected=%0d, Actual=%0d", 
               test_description, expected_value, actual_value);
      passed_assertion_count++;
    end
    else begin
      $display("[FAIL] %s: Expected=%0d, Actual=%0d", 
               test_description, expected_value, actual_value);
      failed_assertion_count++;
    end
  endfunction

  // Assertion function for reset state verification
  function void assert_reset_state_function(
    input logic [3:0] counter_value,
    input string      test_phase
  );
    if (counter_value === 4'b0000) begin
      $display("[PASS] Reset State Check (%s): Counter = %0d", 
               test_phase, counter_value);
      passed_assertion_count++;
    end
    else begin
      $display("[FAIL] Reset State Check (%s): Counter = %0d (should be 0)", 
               test_phase, counter_value);
      failed_assertion_count++;
    end
  endfunction

  // Assertion function for range validation
  function void assert_counter_range_function(
    input logic [3:0] counter_value,
    input logic [3:0] min_value,
    input logic [3:0] max_value,
    input string      test_context
  );
    if (counter_value >= min_value && counter_value <= max_value) begin
      $display("[PASS] Range Check (%s): Counter=%0d within [%0d:%0d]", 
               test_context, counter_value, min_value, max_value);
      passed_assertion_count++;
    end
    else begin
      $display("[FAIL] Range Check (%s): Counter=%0d outside [%0d:%0d]", 
               test_context, counter_value, min_value, max_value);
      failed_assertion_count++;
    end
  endfunction

  // Test summary function
  function void display_test_summary_function();
    $display();
    $display("=== TEST SUMMARY ===");
    $display("Passed Assertions: %0d", passed_assertion_count);
    $display("Failed Assertions: %0d", failed_assertion_count);
    $display("Total Assertions:  %0d", 
             passed_assertion_count + failed_assertion_count);
    if (failed_assertion_count == 0)
      $display("*** ALL TESTS PASSED ***");
    else
      $display("*** %0d TESTS FAILED ***", failed_assertion_count);
    $display();
  endfunction

  // Main test sequence
  initial begin
    // Dump waves
    $dumpfile("counter_assertion_testbench.vcd");
    $dumpvars(0, counter_assertion_testbench);
    
    $display("=== Starting Assertion Functions Test ===");
    $display();
    
    // Initialize signals
    reset_signal = 1;
    enable_signal = 0;
    
    // Test 1: Reset functionality
    #10;
    assert_reset_state_function(counter_output, "Initial Reset");
    
    // Test 2: Release reset
    reset_signal = 0;
    #10;
    assert_equals_function(4'd0, counter_output, "After Reset Release");
    
    // Test 3: Enable counter and check increments
    enable_signal = 1;
    #10;
    assert_equals_function(4'd1, counter_output, "First Increment");
    
    #10;
    assert_equals_function(4'd2, counter_output, "Second Increment");
    
    #10;
    assert_equals_function(4'd3, counter_output, "Third Increment");
    
    // Test 4: Range validation during counting
    assert_counter_range_function(counter_output, 4'd0, 4'd15, 
                                  "Normal Count Range");
    
    // Test 5: Disable counter
    enable_signal = 0;
    #20;
    assert_equals_function(4'd3, counter_output, "Counter Disabled");
    
    // Test 6: Re-enable and continue
    enable_signal = 1;
    #10;
    assert_equals_function(4'd4, counter_output, "Re-enabled Counter");
    
    // Test 7: Reset during operation
    reset_signal = 1;
    #10;
    assert_reset_state_function(counter_output, "Reset During Operation");
    
    // Test 8: Counter overflow test (let it count to maximum)
    reset_signal = 0;
    enable_signal = 1;
    
    // Wait for counter to reach maximum value
    repeat(16) #10;
    
    // Check if counter wraps around correctly
    assert_counter_range_function(counter_output, 4'd0, 4'd15, 
                                  "After Overflow");
    
    // Display final test summary
    #10;
    display_test_summary_function();
    
    $finish;
  end

endmodule