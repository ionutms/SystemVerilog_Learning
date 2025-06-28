// recursive_factorial_calculator_testbench.sv
module factorial_testbench_module;

  // Instantiate the recursive calculator design
  recursive_factorial_calculator_module RECURSIVE_CALC_INSTANCE();

  // Local automatic function for verification
  function automatic int unsigned verify_factorial_calculation(int unsigned num);
    if (num <= 1) begin
      return 1;
    end else begin
      return num * verify_factorial_calculation(num - 1);
    end
  endfunction

  initial begin
    int unsigned expected_result;
    int unsigned actual_result;
    bit all_tests_passed;
    
    // Dump waves for analysis
    $dumpfile("factorial_testbench_module.vcd");
    $dumpvars(0, factorial_testbench_module);
    
    #1;  // Wait for design to initialize
    
    $display("=== Testbench: Recursive Algorithm Verification ===");
    $display();
    
    all_tests_passed = 1'b1;
    
    // Verify factorial calculations
    for (int test_value = 0; test_value <= 5; test_value++) begin
      expected_result = verify_factorial_calculation(test_value);
      actual_result = RECURSIVE_CALC_INSTANCE.calculate_factorial(test_value);
      
      if (expected_result == actual_result) begin
        $display("Test PASSED: factorial(%0d) = %0d", 
                 test_value, actual_result);
      end else begin
        $display("Test FAILED: factorial(%0d) expected %0d, got %0d", 
                 test_value, expected_result, actual_result);
        all_tests_passed = 1'b0;
      end
    end
    
    $display();
    
    // Test boundary conditions
    $display("=== Boundary Condition Tests ===");
    
    // Test edge cases
    if (RECURSIVE_CALC_INSTANCE.calculate_factorial(0) == 1) begin
      $display("Boundary test PASSED: factorial(0) = 1");
    end else begin
      $display("Boundary test FAILED: factorial(0) should be 1");
      all_tests_passed = 1'b0;
    end
    
    if (RECURSIVE_CALC_INSTANCE.calculate_factorial(1) == 1) begin
      $display("Boundary test PASSED: factorial(1) = 1");
    end else begin
      $display("Boundary test FAILED: factorial(1) should be 1");
      all_tests_passed = 1'b0;
    end
    
    $display();
    
    // Final test summary
    if (all_tests_passed) begin
      $display("ALL RECURSIVE ALGORITHM TESTS PASSED!");
    end else begin
      $display("SOME TESTS FAILED - CHECK IMPLEMENTATION");
    end
    
    $display();
    $display("Testbench completed successfully!");
    $display();
    
    #10;  // Additional time for wave viewing
  end

endmodule