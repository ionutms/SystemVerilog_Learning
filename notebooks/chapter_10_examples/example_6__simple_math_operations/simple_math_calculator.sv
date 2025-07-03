// simple_math_calculator.sv
module simple_math_calculator_module();

  // Base Calculator class with virtual calculate method
  virtual class Calculator;
    protected int operand_a;
    protected int operand_b;
    
    function new(int a, int b);
      operand_a = a;
      operand_b = b;
    endfunction
    
    // Virtual method to be overridden by derived classes
    pure virtual function int calculate();
    
    function void display_operands();
      $display("Operand A: %0d, Operand B: %0d", operand_a, operand_b);
    endfunction
  endclass

  // Add class - performs addition
  class Add extends Calculator;
    function new(int a, int b);
      super.new(a, b);
    endfunction
    
    virtual function int calculate();
      return operand_a + operand_b;
    endfunction
  endclass

  // Subtract class - performs subtraction
  class Subtract extends Calculator;
    function new(int a, int b);
      super.new(a, b);
    endfunction
    
    virtual function int calculate();
      return operand_a - operand_b;
    endfunction
  endclass

  // Multiply class - performs multiplication
  class Multiply extends Calculator;
    function new(int a, int b);
      super.new(a, b);
    endfunction
    
    virtual function int calculate();
      return operand_a * operand_b;
    endfunction
  endclass

  initial begin
    Add add_calc;
    Subtract sub_calc;
    Multiply mul_calc;
    Calculator calc_handle;
    int result;
    
    $display();
    $display("=== Simple Math Operations Example ===");
    $display();
    
    // Test Addition
    add_calc = new(15, 7);
    calc_handle = add_calc;
    calc_handle.display_operands();
    result = calc_handle.calculate();
    $display("Addition Result: %0d", result);
    $display();
    
    // Test Subtraction
    sub_calc = new(20, 8);
    calc_handle = sub_calc;
    calc_handle.display_operands();
    result = calc_handle.calculate();
    $display("Subtraction Result: %0d", result);
    $display();
    
    // Test Multiplication
    mul_calc = new(6, 9);
    calc_handle = mul_calc;
    calc_handle.display_operands();
    result = calc_handle.calculate();
    $display("Multiplication Result: %0d", result);
    $display();
    
    $display("=== Math Operations Complete ===");
  end

endmodule