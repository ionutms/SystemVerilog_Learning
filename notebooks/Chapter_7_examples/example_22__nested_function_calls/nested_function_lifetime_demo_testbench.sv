// nested_function_lifetime_demo_testbench.sv
module nested_function_lifetime_testbench;
  
  // Instantiate the design under test
  nested_function_lifetime_demo DESIGN_UNDER_TEST_INSTANCE();
  
  // Additional testbench function to demonstrate cross-module calls
  function automatic int testbench_wrapper_function(input int test_value);
    int wrapper_local;  // Automatic variable in testbench
    
    $display("Testbench wrapper called with value: %0d", test_value);
    wrapper_local = test_value + 100;
    
    // This would call design functions if they were accessible
    // For demonstration, we'll just return a calculated value
    return wrapper_local * 2;
  endfunction
  
  initial begin
    int testbench_result;
    
    // Dump waves for simulation
    $dumpfile("nested_function_lifetime_testbench.vcd");
    $dumpvars(0, nested_function_lifetime_testbench);
    
    #1;  // Wait for design to complete
    
    $display("=== Testbench Additional Tests ===");
    $display();
    
    // Test variable lifetime in testbench functions
    $display("Testing testbench function variable lifetime:");
    testbench_result = testbench_wrapper_function(25);
    $display("Testbench result: %0d", testbench_result);
    $display();
    
    testbench_result = testbench_wrapper_function(50);
    $display("Testbench result: %0d", testbench_result);
    $display();
    
    $display("=== Key Observations ===");
    $display("1. Automatic variables create new instances for each call");
    $display("2. Static variables persist across all function calls");
    $display("3. Nested calls maintain separate variable scopes");
    $display("4. Recursive calls each have their own variable copies");
    $display();
    
    $display("Simulation completed successfully!");
    
  end
  
endmodule