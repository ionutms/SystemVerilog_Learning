// complex_arithmetic_processor.sv
module complex_arithmetic_processor ();

  // Define complex number structure
  typedef struct packed {
    logic signed [15:0] real_component;
    logic signed [15:0] imaginary_component;
  } complex_number_type;

  // Function to add two complex numbers and return structured result
  function complex_number_type add_complex_numbers(
    complex_number_type first_complex_operand,
    complex_number_type second_complex_operand
  );
    complex_number_type addition_result;
    addition_result.real_component = first_complex_operand.real_component + 
                                     second_complex_operand.real_component;
    addition_result.imaginary_component = 
      first_complex_operand.imaginary_component + 
      second_complex_operand.imaginary_component;
    return addition_result;
  endfunction

  // Function to multiply two complex numbers and return structured result
  function complex_number_type multiply_complex_numbers(
    complex_number_type first_complex_operand,
    complex_number_type second_complex_operand
  );
    complex_number_type multiplication_result;
    // (a + bi) * (c + di) = (ac - bd) + (ad + bc)i
    multiplication_result.real_component = 
      (first_complex_operand.real_component * 
       second_complex_operand.real_component) -
      (first_complex_operand.imaginary_component * 
       second_complex_operand.imaginary_component);
    
    multiplication_result.imaginary_component = 
      (first_complex_operand.real_component * 
       second_complex_operand.imaginary_component) +
      (first_complex_operand.imaginary_component * 
       second_complex_operand.real_component);
    
    return multiplication_result;
  endfunction

  // Function to calculate magnitude squared (avoids square root)
  function logic [31:0] calculate_magnitude_squared(
    complex_number_type input_complex_number
  );
    return (input_complex_number.real_component * 
            input_complex_number.real_component) +
           (input_complex_number.imaginary_component * 
            input_complex_number.imaginary_component);
  endfunction

  initial begin
    complex_number_type first_number = '{real_component: 16'd3, 
                                          imaginary_component: 16'd4};
    complex_number_type second_number = '{real_component: 16'd1, 
                                           imaginary_component: 16'd2};
    complex_number_type addition_result;
    complex_number_type multiplication_result;
    logic [31:0] magnitude_squared_result;

    $display();
    $display("Complex Number Arithmetic Operations Demo");
    $display("==========================================");
    
    // Display input numbers
    $display("First Number:  %0d + %0di", 
             first_number.real_component, 
             first_number.imaginary_component);
    $display("Second Number: %0d + %0di", 
             second_number.real_component, 
             second_number.imaginary_component);
    $display();

    // Perform addition
    addition_result = add_complex_numbers(first_number, second_number);
    $display("Addition Result: %0d + %0di", 
             addition_result.real_component, 
             addition_result.imaginary_component);

    // Perform multiplication
    multiplication_result = multiply_complex_numbers(first_number, 
                                                     second_number);
    $display("Multiplication Result: %0d + %0di", 
             multiplication_result.real_component, 
             multiplication_result.imaginary_component);

    // Calculate magnitude squared of first number
    magnitude_squared_result = calculate_magnitude_squared(first_number);
    $display("Magnitude Squared of First Number: %0d", 
             magnitude_squared_result);
    $display();
  end

endmodule