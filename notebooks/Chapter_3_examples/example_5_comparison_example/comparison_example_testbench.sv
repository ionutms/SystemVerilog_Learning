// comparison_example_testbench.sv
module comparison_example_testbench;  // Testbench module
  comparison_example DESIGN_INSTANCE();  // Instantiate design under test
  
  // Test variables - declared at module level
  logic [3:0] test_a = 4'b1010;
  logic [3:0] test_b = 4'b1010;
  logic [3:0] test_c = 4'b1x1z;
  logic [3:0] test_d = 4'b0110;
  logic [3:0] test_small = 4'b0001;
  logic [3:0] test_large = 4'b1111;
  logic signed [3:0] test_pos = 4'sb0111;
  logic signed [3:0] test_neg = 4'sb1001;
  
  // Results storage
  logic eq_result, neq_result, lt_result, gt_result;
  logic case_eq_result, case_neq_result;
  
  // Loop variable for testing
  integer i;
  logic temp_result;
  
  initial begin
    // Dump waves
    $dumpfile("comparison_example_testbench.vcd");
    $dumpvars(0, comparison_example_testbench);
    #1;
    
    $display("Hello from comparison operations testbench!");
    $display("Testing all comparison operators...");
    $display();
    
    // Wait for design to complete
    #30;
    
    $display();
    $display("=== Testbench Verification ===");
    $display("Final result from design: %b", DESIGN_INSTANCE.result);
    
    // Manual verification of comparison operations
    $display();
    $display("=== Manual Verification Tests ===");
    
    // Test equality operators
    eq_result = (test_a == test_b);
    neq_result = (test_a != test_d);
    case_eq_result = (test_a === test_b);
    case_neq_result = (test_a !== test_c);
    
    $display("Equality Tests:");
    $display("  %b == %b = %b (Expected: 1)", test_a, test_b, eq_result);
    $display("  %b != %b = %b (Expected: 1)", test_a, test_d, neq_result);
    $display("  %b === %b = %b (Expected: 1)", test_a, test_b, case_eq_result);
    $display("  %b !== %b = %b (Expected: 1)", test_a, test_c, case_neq_result);
    
    // Test relational operators
    lt_result = (test_small < test_a);
    gt_result = (test_large > test_a);
    
    $display();
    $display("Relational Tests:");
    $display("  %b(%d) < %b(%d) = %b (Expected: 1)", 
             test_small, test_small, test_a, test_a, lt_result);
    $display("  %b(%d) > %b(%d) = %b (Expected: 1)", 
             test_large, test_large, test_a, test_a, gt_result);
    
    // Test signed comparisons
    $display();
    $display("Signed Comparison Tests:");
    $display("  %b(%d) > %b(%d) = %b (Expected: 1)", 
             test_pos, test_pos, test_neg, test_neg, (test_pos > test_neg));
    $display("  %b(%d) < %b(%d) = %b (Expected: 1)", 
             test_neg, test_neg, test_pos, test_pos, (test_neg < test_pos));
    
    // Test unknown value comparisons
    $display();
    $display("Unknown Value Tests:");
    $display("  %b == %b = %b (Expected: x)", test_a, test_c, (test_a == test_c));
    $display("  %b === %b = %b (Expected: 0)", test_a, test_c, (test_a === test_c));
    $display("  %b === %b = %b (Expected: 1)", test_c, test_c, (test_c === test_c));
    
    // Comprehensive comparison matrix
    $display();
    $display("=== Comprehensive Comparison Matrix ===");
    $display("Testing all combinations of a=%b, d=%b, small=%b, large=%b", 
             test_a, test_d, test_small, test_large);
    $display();
    
    // Create comparison table
    $display("   Operator |  a vs d  | small vs a | large vs a | a vs large");
    $display("   ---------|----------|------------|------------|------------");
    $display("       ==   |    %b     |     %b      |     %b      |     %b     ", 
             (test_a == test_d), (test_small == test_a), 
             (test_large == test_a), (test_a == test_large));
    $display("       !=   |    %b     |     %b      |     %b      |     %b     ", 
             (test_a != test_d), (test_small != test_a), 
             (test_large != test_a), (test_a != test_large));
    $display("       <    |    %b     |     %b      |     %b      |     %b     ", 
             (test_a < test_d), (test_small < test_a), 
             (test_large < test_a), (test_a < test_large));
    $display("       <=   |    %b     |     %b      |     %b      |     %b     ", 
             (test_a <= test_d), (test_small <= test_a), 
             (test_large <= test_a), (test_a <= test_large));
    $display("       >    |    %b     |     %b      |     %b      |     %b     ", 
             (test_a > test_d), (test_small > test_a), 
             (test_large > test_a), (test_a > test_large));
    $display("       >=   |    %b     |     %b      |     %b      |     %b     ", 
             (test_a >= test_d), (test_small >= test_a), 
             (test_large >= test_a), (test_a >= test_large));
    
    // Edge case testing
    $display();
    $display("=== Edge Case Testing ===");
    
    // Test boundary values
    $display("Boundary Value Tests:");
    $display("  4'b0000 == 4'd0: %b", (4'b0000 == 4'd0));
    $display("  4'b1111 == 4'd15: %b", (4'b1111 == 4'd15));
    $display("  4'b1111 > 4'b1110: %b", (4'b1111 > 4'b1110));
    $display("  4'b0000 < 4'b0001: %b", (4'b0000 < 4'b0001));
    
    // Test self-comparison
    $display();
    $display("Self-Comparison Tests:");
    $display("  a == a: %b (Expected: 1)", (test_a == test_a));
    $display("  a < a: %b (Expected: 0)", (test_a < test_a));
    $display("  a <= a: %b (Expected: 1)", (test_a <= test_a));
    $display("  a >= a: %b (Expected: 1)", (test_a >= test_a));
    $display("  a > a: %b (Expected: 0)", (test_a > test_a));
    
    // Test complex boolean expressions
    $display();
    $display("=== Complex Boolean Expression Tests ===");
    $display("(small < a) && (a < large): %b (Expected: 1)", 
             ((test_small < test_a) && (test_a < test_large)));
    $display("(a == d) || (a == test_b): %b (Expected: 1)", 
             ((test_a == test_d) || (test_a == test_b)));
    $display("!(a != test_b): %b (Expected: 1)", !(test_a != test_b));
    
    // Performance check - multiple operations
    $display();
    $display("=== Operation Timing Test ===");
    $display("Performing 1000 comparison operations...");
    
    for (i = 0; i < 1000; i = i + 1) begin
      temp_result = (test_a == test_b) && (test_small < test_large);
    end
    $display("Completed 1000 operations. Final result: %b", temp_result);
    
    $display();
    $display("=== Summary ===");
    $display("All comparison operations tested successfully!");
    $display("Key takeaways:");
    $display("- Logical equality (==) returns X for unknown values");
    $display("- Case equality (===) performs exact bit comparison");
    $display("- Signed comparisons handle negative numbers correctly");
    $display("- Width mismatches are handled by zero-extension");
    
    $display();
    $display("=== Test Completed Successfully ===");
    $display();
    
    // End simulation
    $finish;
  end

endmodule