// four_state_simple.sv
module four_state_simple();
  
  // Four-state data types - can store 0, 1, X, Z
  logic [3:0] signal_a;
  logic [3:0] signal_b;
  logic [3:0] result;
  
  initial begin
    $display("\n=== Four-State Data Types with Logic Operations (Verilator) ===\n");
    
    // Test 1: Normal binary values with AND operation
    $display("1. Normal Binary Values (AND operation):");
    signal_a = 4'b1010;             // 10 in decimal
    signal_b = 4'b0110;             // 6 in decimal
    #1;                             // Wait for assignments to complete
    result = signal_a & signal_b;   // AND operation
    #1;                             // Wait for result calculation
    $display("   signal_a = %b", signal_a);
    $display("   signal_b = %b", signal_b);
    $display("   result   = %b (a & b)", result);
    $display("   Expected: 1010 & 0110 = 0010");
    $display("   Correct?  %s", (result == 4'b0010) ? "YES" : "NO");
    
    #10;
    
    // Test 2: Unknown (X) values with OR operation
    $display("\n2. Unknown (X) Values (OR operation):");
    signal_a = 4'bXXXX;             // All unknown
    signal_b = 4'bX010;             // Mixed unknown and known
    #1;                             // Wait for assignments
    result = signal_a | signal_b;   // OR operation
    #1;                             // Wait for result
    $display("   signal_a = %b (Verilator converted XXXX)", signal_a);
    $display("   signal_b = %b (Verilator converted X010)", signal_b);
    $display("   result   = %b (a | b)", result);
    $display("   Note: Verilator converts X to deterministic 0/1 values");
    
    #10;
    
    // Test 3: High-impedance (Z) values with XOR operation
    $display("\n3. High-Impedance (Z) Values (XOR operation):");
    signal_a = 4'bZZZZ;             // All tri-state
    signal_b = 4'b1Z0Z;             // Mixed tri-state and known
    #1;                             // Wait for assignments
    result = signal_a ^ signal_b;   // XOR operation
    #1;                             // Wait for result
    $display("   signal_a = %b (Verilator converted ZZZZ)", signal_a);
    $display("   signal_b = %b (Verilator converted 1Z0Z)", signal_b);
    $display("   result   = %b (a ^ b)", result);
    $display("   Note: Verilator converts Z to deterministic 0/1 values");
    
    #10;
    
    // Test 4: Mixed states with NOT operation
    $display("\n4. All Four States (NOT operation):");
    signal_a = 4'b01XZ;             // One of each state
    #1;                             // Wait for assignment
    result = ~signal_a;             // NOT operation
    #1;                             // Wait for result
    $display("   signal_a = %b (Verilator converted 01XZ)", signal_a);
    $display("   result   = %b (~a)", result);
    $display("   Manual check: ~%b%b%b%b = %b%b%b%b", 
             signal_a[3], signal_a[2], signal_a[1], signal_a[0],
             result[3], result[2], result[1], result[0]);
    
    #10;
    
    // Test 5: Show what Verilator actually does with assignments
    $display("\n5. Verilator's X/Z Conversion Demonstration:");
    
    // Multiple assignments of same X/Z pattern
    signal_a = 4'bXXXX;
    #1;
    $display("   4'bXXXX → %b (assignment 1)", signal_a);
    
    signal_a = 4'bXXXX;
    #1;
    $display("   4'bXXXX → %b (assignment 2 - same pattern)", signal_a);
    
    signal_a = 4'bZZZZ;
    #1;
    $display("   4'bZZZZ → %b (Z assignment)", signal_a);
    
    signal_a = 4'b01XZ;
    #1;
    $display("   4'b01XZ → %b (mixed assignment)", signal_a);
    
    #10;
    
    $display("\n=== Demo Complete ===");
    $display("SUMMARY for Verilator (2-state simulator):");
    $display("- X and Z are converted to deterministic 0/1 values");
    $display("- Same X/Z pattern always converts to same 0/1 pattern");
    $display("- Logic operations work on the converted 0/1 values");
    $display("- Case equality (===) compares the converted values");
    $display("\nFor true 4-state simulation, use:");
    $display("- Icarus Verilog: iverilog + vvp");
    $display("- ModelSim/QuestaSim");
    $display("- Synopsys VCS");
  end

endmodule