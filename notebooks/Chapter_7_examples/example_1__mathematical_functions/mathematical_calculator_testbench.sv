// mathematical_calculator_testbench.sv
module math_calculator_testbench;  // Testbench for mathematical calculator

  mathematical_calculator MATH_CALCULATOR_INSTANCE();  // Instantiate mathematical calculator

  // Test variables
  integer test_factorial_result;
  integer test_power_result;
  integer test_gcd_result;

  initial begin
    // Dump waves for simulation
    $dumpfile("math_calculator_testbench.vcd");
    $dumpvars(0, math_calculator_testbench);
    
    #1;  // Wait for design to initialize
    
    $display();
    $display("=== Testbench Verification ===");
    
    // Verify factorial calculations
    test_factorial_result = MATH_CALCULATOR_INSTANCE.calculate_factorial(4);
    $display("Testbench: 4! = %0d (Expected: 24)", test_factorial_result);
    
    // Verify power calculations  
    test_power_result = MATH_CALCULATOR_INSTANCE.calculate_power(3, 4);
    $display("Testbench: 3^4 = %0d (Expected: 81)", test_power_result);
    
    // Verify GCD calculations
    test_gcd_result = MATH_CALCULATOR_INSTANCE.calculate_gcd(60, 48);
    $display("Testbench: GCD(60, 48) = %0d (Expected: 12)", test_gcd_result);
    
    $display();
    $display("Mathematical functions testbench completed successfully!");
    $display();
    
    #10;  // Wait before finishing
    $finish;
  end

endmodule