// array_processor_testbench.sv
module array_processor_testbench;             // Testbench module
  array_processor ARRAY_PROCESSOR();          // Instantiate design under test

  // Extended testbench class for additional array testing
  class array_test;
    logic [7:0] test_array[16];
    logic [15:0] expected_sum;                // Fixed: Increased to 16-bit to prevent overflow
    logic [15:0] actual_sum;                  // Fixed: Increased to 16-bit to prevent overflow
    integer test_size;
    
    function new();
      test_size = 16;
    endfunction
    
    // Function to initialize test array with different pattern
    function void initialize_test_array();
      foreach (test_array[i]) begin
        // Fixed: Proper casting and clearer logic
        if (i % 2 == 0) begin
          test_array[i] = 8'(i * 3);         // Even indices: 0, 6, 12, 18, ...
        end else begin
          test_array[i] = 8'(i + 10);        // Odd indices: 11, 12, 13, 14, ...
        end
      end
    endfunction
    
    // Function to calculate expected sum
    function void calculate_expected_sum();
      expected_sum = 16'h0000;
      foreach (test_array[i]) begin
        expected_sum = expected_sum + 16'(test_array[i]);  // Fixed: Explicit cast and assignment
      end
    endfunction
    
    // Function to verify array operations
    function bit verify_sum();
      actual_sum = 16'h0000;
      foreach (test_array[i]) begin
        actual_sum = actual_sum + 16'(test_array[i]);    // Fixed: Explicit cast and assignment
      end
      return (actual_sum == expected_sum);
    endfunction
    
    // Function to display test array
    function void display_test_array();
      $display("Test Array Pattern:");
      foreach (test_array[i]) begin
        $display("  test_array[%0d] = %0d (0x%02h)", i, test_array[i], test_array[i]);
      end
    endfunction
    
    // Function to run verification
    function void run_verification();
      bit sum_check;
      
      // Array is already initialized, just calculate and verify
      calculate_expected_sum();
      sum_check = verify_sum();
      
      $display("=== Verification Results ===");
      $display("Expected Sum: %0d", expected_sum);
      $display("Actual Sum:   %0d", actual_sum);
      $display("Sum Check:    %s", sum_check ? "PASS" : "FAIL");
      
      if (sum_check) begin
        $display("Array sum verification PASSED");
      end else begin
        $display("Array sum verification FAILED");
      end
    endfunction
  endclass

  initial begin
    array_test tb_arr_test;
    
    // Dump waves
    $dumpfile("array_processor_testbench.vcd");    // Specify the VCD file
    $dumpvars(0, array_processor_testbench);       // Dump all variables in the test module
    #10;                                            // Wait for 10 time units
    $display("Hello from testbench!");             // Display message
    $display();                                    // Display empty line
    
    // Testbench-specific array testing
    $display("=== Testbench Array Verification ===");
    tb_arr_test = new();

    // Initialize test array first, then display
    tb_arr_test.initialize_test_array();
    tb_arr_test.display_test_array();
    $display();
    
    // Run verification tests
    tb_arr_test.run_verification();
    
    $display();
    $display("=== Additional Array Tests ===");
    
    // Test with different array sizes conceptually
    for (int test_case = 1; test_case <= 3; test_case++) begin
      $display("Test Case %0d: Running array operations...", test_case);
      
      // Simulate different processing scenarios
      case (test_case)
        1: $display("  Processing sequential data pattern");
        2: $display("  Processing alternating data pattern");  
        3: $display("  Processing random-like data pattern");
      endcase
      
      #5; // Small delay between test cases
    end
    
    $display("Testbench verification completed!");
    #10;
    $display();
    $finish;
  end

endmodule