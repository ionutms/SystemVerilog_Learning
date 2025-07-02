// method_return_demo.sv
// Demonstrates methods with return types vs. void methods

class calculator_class;
  int accumulator;
  
  // Constructor
  function new();
    accumulator = 0;
  endfunction
  
  // Method that returns a value (int return type)
  function int add_numbers(int a, int b);
    return a + b;
  endfunction
  
  // Method that returns a value and uses internal state
  function int get_accumulator();
    return accumulator;
  endfunction
  
  // Method that performs action without returning data (void)
  function void set_accumulator(int value);
    accumulator = value;
  endfunction
  
  // Method that performs action and updates state (void)
  function void add_to_accumulator(int value);
    accumulator += value;
  endfunction
  
  // Method that performs action for display (void)
  function void display_status();
    $display("Current accumulator value: %0d", accumulator);
  endfunction
  
  // Method that returns boolean result
  function bit is_positive();
    return (accumulator > 0);
  endfunction
  
  // Method that returns string for status
  function string get_status_string();
    if (accumulator > 0)
      return "POSITIVE";
    else if (accumulator < 0)
      return "NEGATIVE";
    else
      return "ZERO";
  endfunction
  
endclass

module method_return_demo;
  
  calculator_class calc;
  int result;
  bit status;
  string status_str;
  
  initial begin
    $display("=== Method Return Types Demo ===");
    $display();
    
    // Create calculator instance
    calc = new();
    
    // Using methods that return values
    result = calc.add_numbers(15, 25);
    $display("add_numbers(15, 25) returned: %0d", result);
    
    result = calc.get_accumulator();
    $display("get_accumulator() returned: %0d", result);
    
    // Using void methods (no return value)
    calc.set_accumulator(42);
    $display("Called set_accumulator(42) - no return value");
    
    calc.display_status();  // This method displays internally
    
    calc.add_to_accumulator(8);
    $display("Called add_to_accumulator(8) - no return value");
    
    // Using methods that return values again
    result = calc.get_accumulator();
    $display("get_accumulator() now returns: %0d", result);
    
    status = calc.is_positive();
    $display("is_positive() returned: %0b", status);
    
    status_str = calc.get_status_string();
    $display("get_status_string() returned: %s", status_str);
    
    $display();
    $display("=== Testing with negative value ===");
    calc.set_accumulator(-10);
    calc.display_status();
    
    status = calc.is_positive();
    $display("is_positive() returned: %0b", status);
    
    status_str = calc.get_status_string();
    $display("get_status_string() returned: %s", status_str);
    
  end
  
endmodule