// mathematical_calculator.sv
module mathematical_calculator ();               // Mathematical functions design

  // Function to calculate factorial
  function automatic integer calculate_factorial;
    input integer number_input;
    integer factorial_result;
    begin
      if (number_input <= 1)
        factorial_result = 1;
      else
        factorial_result = number_input * calculate_factorial(number_input - 1);
      calculate_factorial = factorial_result;
    end
  endfunction

  // Function to calculate power (base^exponent)
  function automatic integer calculate_power;
    input integer base_value;
    input integer exponent_value;
    integer power_result;
    integer loop_counter;
    begin
      power_result = 1;
      for (loop_counter = 0; loop_counter < exponent_value; loop_counter = loop_counter + 1)
        power_result = power_result * base_value;
      calculate_power = power_result;
    end
  endfunction

  // Function to calculate greatest common divisor using Euclidean algorithm
  function automatic integer calculate_gcd;
    input integer first_number;
    input integer second_number;
    integer temp_remainder;
    begin
      while (second_number != 0) begin
        temp_remainder = first_number % second_number;
        first_number = second_number;
        second_number = temp_remainder;
      end
      calculate_gcd = first_number;
    end
  endfunction

  initial begin
    $display();
    $display("=== Mathematical Functions Demonstration ===");
    
    // Test factorial function
    $display("Factorial Tests:");
    $display("  5! = %0d", calculate_factorial(5));
    $display("  0! = %0d", calculate_factorial(0));
    $display("  3! = %0d", calculate_factorial(3));
    
    // Test power function
    $display("Power Tests:");
    $display("  2^3 = %0d", calculate_power(2, 3));
    $display("  5^2 = %0d", calculate_power(5, 2));
    $display("  10^0 = %0d", calculate_power(10, 0));
    
    // Test GCD function
    $display("Greatest Common Divisor Tests:");
    $display("  GCD(48, 18) = %0d", calculate_gcd(48, 18));
    $display("  GCD(100, 25) = %0d", calculate_gcd(100, 25));
    $display("  GCD(17, 13) = %0d", calculate_gcd(17, 13));
    
    $display();
  end

endmodule