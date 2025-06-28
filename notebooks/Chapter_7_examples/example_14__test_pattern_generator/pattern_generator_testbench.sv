// pattern_generator_testbench.sv
module pattern_generator_testbench;

  // Testbench signals
  logic       clock_stimulus;
  logic       reset_stimulus;
  logic [1:0] pattern_select_stimulus;
  logic [7:0] test_pattern_result;
  
  // Clock generation
  initial begin
    clock_stimulus = 0;
    forever #5 clock_stimulus = ~clock_stimulus;
  end
  
  // Design under test instantiation
  pattern_generator_design PATTERN_GEN_INSTANCE (
    .clock_signal(clock_stimulus),
    .reset_signal(reset_stimulus),
    .pattern_select(pattern_select_stimulus),
    .test_pattern_output(test_pattern_result)
  );
  
  // Test pattern verification task
  task automatic verify_pattern_output(
    input logic [1:0] expected_select,
    input logic [7:0] expected_count,
    input logic [7:0] actual_output
  );
    logic [7:0] expected_pattern;
    
    case (expected_select)
      2'b00: expected_pattern = expected_count;
      2'b01: expected_pattern = ~expected_count;
      2'b10: expected_pattern = {expected_count[0], expected_count[1], 
                                expected_count[2], expected_count[3],
                                expected_count[4], expected_count[5], 
                                expected_count[6], expected_count[7]};
      2'b11: expected_pattern = expected_count ^ 8'hAA;
    endcase
    
    if (actual_output === expected_pattern) begin
      $display("PASS: Pattern %0d, Count %02h, Output %02h", 
               expected_select, expected_count, actual_output);
    end else begin
      $display("FAIL: Pattern %0d, Count %02h, Expected %02h, Got %02h", 
               expected_select, expected_count, expected_pattern, 
               actual_output);
    end
  endtask
  
  // Test stimulus generation task
  task automatic run_pattern_test(input logic [1:0] pattern_type);
    integer test_cycles;
    logic [7:0] observed_count;
    
    $display("Testing pattern type %0d:", pattern_type);
    pattern_select_stimulus = pattern_type;
    
    for (test_cycles = 0; test_cycles < 8; test_cycles++) begin
      @(posedge clock_stimulus);
      #1; // Small delay for signal propagation
      // Get the actual counter value from the design
      observed_count = PATTERN_GEN_INSTANCE.counter_value;
      verify_pattern_output(pattern_type, observed_count, 
                           test_pattern_result);
    end
    $display();
  endtask

  // Main test sequence
  initial begin
    // Dump waves
    $dumpfile("pattern_generator_testbench.vcd");
    $dumpvars(0, pattern_generator_testbench);
    
    // Initialize signals
    reset_stimulus = 1;
    pattern_select_stimulus = 2'b00;
    
    // Display test header
    $display("=== Test Pattern Generator Verification ===");
    $display();
    
    // Apply reset
    repeat(2) @(posedge clock_stimulus);
    reset_stimulus = 0;
    
    // Test all pattern types
    run_pattern_test(2'b00);  // Incrementing pattern
    run_pattern_test(2'b01);  // Inverted pattern
    run_pattern_test(2'b10);  // Bit-reversed pattern
    run_pattern_test(2'b11);  // XOR pattern
    
    // Reset and test pattern switching
    $display("Testing pattern switching:");
    reset_stimulus = 1;
    repeat(2) @(posedge clock_stimulus);
    reset_stimulus = 0;
    
    pattern_select_stimulus = 2'b00;
    repeat(3) @(posedge clock_stimulus);
    pattern_select_stimulus = 2'b11;
    repeat(3) @(posedge clock_stimulus);
    pattern_select_stimulus = 2'b01;
    repeat(3) @(posedge clock_stimulus);
    
    $display("=== Test Pattern Generator Complete ===");
    $finish;
  end

endmodule