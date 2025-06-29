// input_validator_module_testbench.sv
module input_validator_testbench;

  // Instantiate design under test
  input_validator_module INPUT_VALIDATOR_DUT();

  // Test variables
  logic        range_check_result;
  logic [1:0]  password_strength_level;
  integer      test_counter;

  initial begin
    // Initialize VCD dump
    $dumpfile("input_validator_testbench.vcd");
    $dumpvars(0, input_validator_testbench);
    
    test_counter = 0;
    
    $display("=== Input Validation Functions Testbench ===");
    $display("Testing functions with multiple return points");
    $display();
    
    // Additional comprehensive range validation tests
    $display("--- Extended Range Validation Tests ---");
    
    test_counter++;
    $display("Test %0d: Valid boundary values", test_counter);
    range_check_result = INPUT_VALIDATOR_DUT.validate_range(10, 10, 10);
    range_check_result = INPUT_VALIDATOR_DUT.validate_range(0, 0, 255);
    #1;
    
    test_counter++;
    $display("Test %0d: Edge case testing", test_counter);
    range_check_result = INPUT_VALIDATOR_DUT.validate_range(255, 0, 255);
    range_check_result = INPUT_VALIDATOR_DUT.validate_range(128, 50, 200);
    #1;
    
    test_counter++;
    $display("Test %0d: Error condition testing", test_counter);
    range_check_result = INPUT_VALIDATOR_DUT.validate_range(100, 200, 50);
    range_check_result = INPUT_VALIDATOR_DUT.validate_range(25, 50, 40);
    #1;
    
    $display();
    
    // Additional comprehensive password strength tests
    $display("--- Extended Password Strength Tests ---");
    
    test_counter++;
    $display("Test %0d: Minimum length boundary", test_counter);
    password_strength_level = INPUT_VALIDATOR_DUT.check_password_strength(
                                8, 1'b1, 1'b1, 1'b1);
    password_strength_level = INPUT_VALIDATOR_DUT.check_password_strength(
                                7, 1'b1, 1'b1, 1'b1);
    #1;
    
    test_counter++;
    $display("Test %0d: Various combinations", test_counter);
    password_strength_level = INPUT_VALIDATOR_DUT.check_password_strength(
                                15, 1'b1, 1'b0, 1'b1);
    password_strength_level = INPUT_VALIDATOR_DUT.check_password_strength(
                                20, 1'b1, 1'b1, 1'b0);
    #1;
    
    test_counter++;
    $display("Test %0d: Weak password scenarios", test_counter);
    password_strength_level = INPUT_VALIDATOR_DUT.check_password_strength(
                                12, 1'b0, 1'b1, 1'b1);
    password_strength_level = INPUT_VALIDATOR_DUT.check_password_strength(
                                4, 1'b1, 1'b1, 1'b1);
    #1;
    
    $display();
    $display("=== Testbench completed successfully ===");
    $display("Demonstrated multiple return points in validation functions");
    #10;
    
    $finish;
  end

endmodule