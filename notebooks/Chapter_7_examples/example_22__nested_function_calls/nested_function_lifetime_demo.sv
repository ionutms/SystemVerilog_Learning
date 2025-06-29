// nested_function_lifetime_demo.sv
module nested_function_lifetime_demo;
  
  // Function with automatic variables (default)
  function automatic int calculate_outer_sum(input int base_value, 
                                           input int multiplier);
    int outer_accumulator;  // Automatic variable - new instance each call
    
    $display("Outer function called: base=%0d, mult=%0d", 
             base_value, multiplier);
    
    outer_accumulator = base_value;
    
    // Nested function call
    return outer_accumulator + calculate_inner_product(base_value, 
                                                      multiplier);
  endfunction
  
  // Nested function with static variable
  function automatic int calculate_inner_product(input int value, 
                                               input int factor);
    static int call_counter = 0;  // Static - persists across calls
    int inner_result;             // Automatic - new each call
    
    call_counter++;  // Increment static counter
    inner_result = value * factor;
    
    $display("  Inner function call #%0d: %0d * %0d = %0d", 
             call_counter, value, factor, inner_result);
    
    return inner_result;
  endfunction
  
  // Function demonstrating variable scope in nested calls
  function automatic int recursive_factorial_helper(input int number);
    int local_temp;  // Each recursion level has its own copy
    
    if (number <= 1) begin
      $display("    Base case reached: number=%0d", number);
      return 1;
    end
    else begin
      local_temp = number;
      $display("    Recursive call: number=%0d", number);
      return local_temp * recursive_factorial_helper(number - 1);
    end
  endfunction
  
  initial begin
    int first_result, second_result, third_result;
    int factorial_result;
    
    $display("=== Nested Function Call Variable Lifetime Demo ===");
    $display();
    
    // Demonstrate automatic variable behavior in nested calls
    $display("Test 1: First nested function call sequence");
    first_result = calculate_outer_sum(10, 3);  
    $display("First result: %0d", first_result);
    $display();
    
    $display("Test 2: Second nested function call sequence");
    second_result = calculate_outer_sum(5, 4);  
    $display("Second result: %0d", second_result);
    $display();
    
    $display("Test 3: Third nested function call sequence");
    third_result = calculate_outer_sum(7, 2);   
    $display("Third result: %0d", third_result);
    $display();
    
    // Demonstrate recursive function with automatic variables
    $display("Test 4: Recursive function with automatic variables");
    factorial_result = recursive_factorial_helper(4);
    $display("Factorial of 4: %0d", factorial_result);
    $display();
    
  end
  
endmodule