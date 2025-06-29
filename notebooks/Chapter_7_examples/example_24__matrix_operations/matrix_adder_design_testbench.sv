// matrix_adder_design_testbench.sv
module matrix_adder_testbench;

  // Parameters matching the design
  parameter MATRIX_SIZE = 4;
  parameter DATA_WIDTH  = 8;
  parameter CLOCK_PERIOD = 10;

  // Testbench signals
  logic clock_signal;
  logic reset_signal;
  logic start_operation;
  logic [DATA_WIDTH-1:0] test_matrix_a [MATRIX_SIZE-1:0] [MATRIX_SIZE-1:0];
  logic [DATA_WIDTH-1:0] test_matrix_b [MATRIX_SIZE-1:0] [MATRIX_SIZE-1:0];
  logic [DATA_WIDTH-1:0] expected_result [MATRIX_SIZE-1:0] [MATRIX_SIZE-1:0];
  logic [DATA_WIDTH-1:0] actual_result [MATRIX_SIZE-1:0] [MATRIX_SIZE-1:0];
  logic operation_complete;

  // Test result tracking
  int successful_tests = 0;
  int total_tests = 0;

  // Instantiate the design under test
  matrix_adder_processor #(
    .MATRIX_SIZE(MATRIX_SIZE),
    .DATA_WIDTH(DATA_WIDTH)
  ) matrix_processor_instance (
    .clock_signal(clock_signal),
    .reset_signal(reset_signal),
    .start_operation(start_operation),
    .matrix_a_input(test_matrix_a),
    .matrix_b_input(test_matrix_b),
    .matrix_result_output(actual_result),
    .operation_complete(operation_complete)
  );

  // Clock generation
  always #(CLOCK_PERIOD/2) clock_signal = ~clock_signal;

  // Task to initialize test matrices
  task automatic initialize_test_matrices();
    // Initialize Matrix A with incremental values
    for (int row = 0; row < MATRIX_SIZE; row++) begin
      for (int col = 0; col < MATRIX_SIZE; col++) begin
        test_matrix_a[row][col] = DATA_WIDTH'(row * MATRIX_SIZE + col + 1);
      end
    end
    
    // Initialize Matrix B with different pattern
    for (int row = 0; row < MATRIX_SIZE; row++) begin
      for (int col = 0; col < MATRIX_SIZE; col++) begin
        test_matrix_b[row][col] = DATA_WIDTH'((row + col) * 2);
      end
    end
  endtask

  // Task to calculate expected results
  task automatic calculate_expected_result();
    for (int row = 0; row < MATRIX_SIZE; row++) begin
      for (int col = 0; col < MATRIX_SIZE; col++) begin
        expected_result[row][col] = test_matrix_a[row][col] + 
                                   test_matrix_b[row][col];
      end
    end
  endtask

  // Task to perform matrix addition test
  task automatic perform_matrix_addition_test();
    total_tests++;
    
    $display("=== Test %0d: Matrix Addition ===", total_tests);
    
    // Initialize matrices
    initialize_test_matrices();
    calculate_expected_result();
    
    // Start operation
    start_operation = 1'b1;
    @(posedge clock_signal);
    start_operation = 1'b0;
    
    // Wait for completion
    wait(operation_complete);
    @(posedge clock_signal);
    
    // Display matrices
    matrix_processor_instance.display_matrix_operation();
    
    // Verify results
    if (verify_matrix_results()) begin
      $display("Matrix addition test PASSED");
      successful_tests++;
    end else begin
      $display("Matrix addition test FAILED");
    end
    
    $display();
  endtask

  // Function to verify matrix results
  function automatic bit verify_matrix_results();
    bit test_passed = 1'b1;
    
    for (int row = 0; row < MATRIX_SIZE; row++) begin
      for (int col = 0; col < MATRIX_SIZE; col++) begin
        if (actual_result[row][col] !== expected_result[row][col]) begin
          $display("Mismatch at [%0d][%0d]: Expected=%0d, Got=%0d",
                  row, col, expected_result[row][col], 
                  actual_result[row][col]);
          test_passed = 1'b0;
        end
      end
    end
    
    return test_passed;
  endfunction

  // Task to perform system reset
  task automatic perform_system_reset();
    $display("Performing system reset...");
    reset_signal = 1'b1;
    repeat(3) @(posedge clock_signal);
    reset_signal = 1'b0;
    @(posedge clock_signal);
    $display("Reset complete");
    $display();
  endtask

  // Main test sequence
  initial begin
    // Initialize signals
    clock_signal = 1'b0;
    reset_signal = 1'b0;
    start_operation = 1'b0;
    
    // Setup waveform dumping
    $dumpfile("matrix_adder_testbench.vcd");
    $dumpvars(0, matrix_adder_testbench);
    
    $display("Starting Matrix Operations Testbench");
    $display("=====================================");
    $display();
    
    // Perform reset
    perform_system_reset();
    
    // Run matrix addition tests
    perform_matrix_addition_test();
    
    // Add small delay for waveform clarity
    repeat(5) @(posedge clock_signal);
    
    // Display final results
    $display("=== Test Summary ===");
    $display("Total Tests: %0d", total_tests);
    $display("Passed: %0d", successful_tests);
    $display("Failed: %0d", total_tests - successful_tests);
    
    if (successful_tests == total_tests) begin
      $display("All tests PASSED!");
    end else begin
      $display("Some tests FAILED!");
    end
    
    $display();
    $display("Matrix operations testbench complete!");
    $finish;
  end

  // Timeout watchdog
  initial begin
    #(CLOCK_PERIOD * 1000);
    $display("ERROR: Testbench timeout!");
    $finish;
  end

endmodule