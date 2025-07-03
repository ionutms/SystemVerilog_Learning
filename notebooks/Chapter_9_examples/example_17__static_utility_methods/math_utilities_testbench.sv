// math_utilities_testbench.sv
// Testbench demonstrating static utility methods

module math_utilities_testbench;
  
  initial begin
    // Setup VCD dumping
    $dumpfile("math_utilities_testbench.vcd");
    $dumpvars(0, math_utilities_testbench);
    
    $display("=== Static Utility Methods Demo ===");
    $display();
    
    // Test MathUtilities static methods (no instance needed!)
    $display("--- Math Utilities ---");
    $display("Max(15, 8) = %0d", MathUtilities::max(15, 8));
    $display("Min(15, 8) = %0d", MathUtilities::min(15, 8));
    $display("Abs(-42) = %0d", MathUtilities::abs(-42));
    $display("Abs(42) = %0d", MathUtilities::abs(42));
    $display("Is 10 even? %0s", MathUtilities::is_even(10) ? "Yes" : "No");
    $display("Is 7 even? %0s", MathUtilities::is_even(7) ? "Yes" : "No");
    $display("2^5 = %0d", MathUtilities::power_of_two(5));
    $display("2^3 = %0d", MathUtilities::power_of_two(3));
    $display("Clamp(25, 10, 20) = %0d", 
             MathUtilities::clamp(25, 10, 20));
    $display("Clamp(5, 10, 20) = %0d", 
             MathUtilities::clamp(5, 10, 20));
    $display("Clamp(15, 10, 20) = %0d", 
             MathUtilities::clamp(15, 10, 20));
    
    $display();
    
    // Test StringUtilities static methods
    $display("--- String Utilities ---");
    $display("Length of 'Hello' = %0d", 
             StringUtilities::str_length("Hello"));
    $display("Is '' empty? %0s", 
             StringUtilities::is_empty("") ? "Yes" : "No");
    $display("Is 'test' empty? %0s", 
             StringUtilities::is_empty("test") ? "Yes" : "No");
    $display("Upper first 'hello' = '%0s'", 
             StringUtilities::to_upper_first("hello"));
    $display("Upper first 'WORLD' = '%0s'", 
             StringUtilities::to_upper_first("WORLD"));
    $display("Upper first 'systemVerilog' = '%0s'", 
             StringUtilities::to_upper_first("systemVerilog"));
    
    $display();
    
    // Demonstrate that we don't need class instances
    $display("--- Key Point: No Class Instances Required ---");
    $display("All methods called using ClassName::method_name()");
    $display("This is the power of static methods!");
    
    $display();
    $display("=== Test Complete ===");
    
    #10;  // Wait a bit
    $finish;
  end
  
endmodule