// method_return_demo_testbench.sv
// Testbench for method return types demonstration

module method_return_testbench;
  
  // Instantiate design under test
  method_return_demo METHOD_RETURN_INSTANCE();
  
  initial begin
    // Dump waves for debugging
    $dumpfile("method_return_testbench.vcd");
    $dumpvars(0, method_return_testbench);
    
    // Wait for design to complete
    #1;
    
    $display("Hello from method return types testbench!");
    $display("Design execution completed successfully.");
    $display();
    
    // Additional test scenarios in testbench
    $display("=== Additional Testbench Verification ===");
    test_return_value_methods();
    test_void_methods();
    
    $display("=== Testbench completed ===");
    $finish;
  end
  
  // Task to test methods that return values
  task test_return_value_methods();
    calculator_class test_calc;
    int math_result;
    bit bool_result;
    string str_result;
    
    $display("Testing methods with return values:");
    
    test_calc = new();
    
    // Test mathematical operation
    math_result = test_calc.add_numbers(100, 200);
    $display("  add_numbers(100, 200) = %0d", math_result);
    
    // Test getter method
    test_calc.set_accumulator(75);
    math_result = test_calc.get_accumulator();
    $display("  get_accumulator() = %0d", math_result);
    
    // Test boolean return
    bool_result = test_calc.is_positive();
    $display("  is_positive() = %0b", bool_result);
    
    // Test string return
    str_result = test_calc.get_status_string();
    $display("  get_status_string() = %s", str_result);
    
    $display();
  endtask
  
  // Task to test void methods
  task test_void_methods();
    calculator_class test_calc;
    
    $display("Testing void methods (no return value):");
    
    test_calc = new();
    
    // These methods don't return values, just perform actions
    $display("  Calling set_accumulator(99)...");
    test_calc.set_accumulator(99);
    
    $display("  Calling add_to_accumulator(-50)...");
    test_calc.add_to_accumulator(-50);
    
    $display("  Calling display_status()...");
    test_calc.display_status();
    
    $display("  All void methods executed successfully.");
    $display();
  endtask
  
endmodule