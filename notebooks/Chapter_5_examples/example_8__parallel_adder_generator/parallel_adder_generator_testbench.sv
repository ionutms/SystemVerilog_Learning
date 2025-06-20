// parallel_adder_generator_testbench.sv
module parallel_adder_generator_testbench;

    // === RIPPLE CARRY ADDER TEST ===
    logic [7:0] rca_a, rca_b, rca_sum;
    logic rca_cin, rca_cout;
    
    ripple_carry_adder #(.WIDTH(8)) rca_8bit (
        .a(rca_a), .b(rca_b), .cin(rca_cin),
        .sum(rca_sum), .cout(rca_cout)
    );
    
    // === CARRY-LOOKAHEAD ADDER TEST ===
    logic [15:0] cla_a, cla_b, cla_sum;
    logic cla_cin, cla_cout;
    
    carry_lookahead_adder #(.WIDTH(16), .BLOCK_SIZE(4)) cla_16bit (
        .a(cla_a), .b(cla_b), .cin(cla_cin),
        .sum(cla_sum), .cout(cla_cout)
    );
    
    // === PARALLEL PREFIX ADDER TEST ===
    logic [7:0] ppa_a, ppa_b, ppa_sum;
    logic ppa_cin, ppa_cout;
    
    parallel_prefix_adder #(.WIDTH(8)) ppa_8bit (
        .a(ppa_a), .b(ppa_b), .cin(ppa_cin),
        .sum(ppa_sum), .cout(ppa_cout)
    );
    
    // === MULTI-OPERAND ADDER TEST ===
    logic [7:0] multi_operands [7:0];
    logic [7:0] multi_sum;
    logic multi_overflow;
    
    multi_operand_adder #(.NUM_OPERANDS(8), .WIDTH(8)) multi_add (
        .operands(multi_operands),
        .sum(multi_sum),
        .overflow(multi_overflow)
    );
    
    // === PARALLEL ADDER ARRAY TEST ===
    parameter int ARRAY_SIZE = 4;
    logic [7:0] array_a [ARRAY_SIZE-1:0];
    logic [7:0] array_b [ARRAY_SIZE-1:0];
    logic [ARRAY_SIZE-1:0] array_cin;
    logic [7:0] array_sum_ripple [ARRAY_SIZE-1:0];
    logic [7:0] array_sum_cla [ARRAY_SIZE-1:0];
    logic [ARRAY_SIZE-1:0] array_cout_ripple;
    logic [ARRAY_SIZE-1:0] array_cout_cla;
    
    parallel_adder_array #(
        .NUM_ADDERS(ARRAY_SIZE), 
        .WIDTH(8), 
        .ADDER_TYPE("RIPPLE")
    ) adder_array_ripple (
        .a_array(array_a), .b_array(array_b), .cin_array(array_cin),
        .sum_array(array_sum_ripple), .cout_array(array_cout_ripple)
    );
    
    parallel_adder_array #(
        .NUM_ADDERS(ARRAY_SIZE), 
        .WIDTH(8), 
        .ADDER_TYPE("CLA")
    ) adder_array_cla (
        .a_array(array_a), .b_array(array_b), .cin_array(array_cin),
        .sum_array(array_sum_cla), .cout_array(array_cout_cla)
    );

    // Test function for comprehensive addition testing
    function automatic logic test_addition(
        input logic [15:0] a, b, 
        input logic cin,
        input logic [15:0] expected_sum,
        input logic expected_cout,
        input string test_name
    );
        logic [15:0] actual_sum;
        logic actual_cout;
        
        // Use CLA for testing (adapt width)
        if (a <= 255 && b <= 255) begin
            // 8-bit test - use ripple carry
            {actual_cout, actual_sum[7:0]} = a[7:0] + b[7:0] + {7'b0, cin};
            actual_sum[15:8] = 8'b0;
        end else begin
            // 16-bit test - use CLA
            {actual_cout, actual_sum} = a + b + {15'b0, cin};
        end
        
        if (actual_sum == expected_sum && actual_cout == expected_cout) begin
            $display("  ✓ %s: %d + %d + %d = %d (carry=%b)", 
                    test_name, a, b, cin, actual_sum, actual_cout);
            return 1'b1;
        end else begin
            $display("  ✗ %s: Expected %d (carry=%b), got %d (carry=%b)", 
                    test_name, expected_sum, expected_cout, actual_sum, actual_cout);
            return 1'b0;
        end
    endfunction

    initial begin
        $dumpfile("parallel_adder_generator_testbench.vcd");
        $dumpvars(0, parallel_adder_generator_testbench);
        
        $display("\n=== Parallel Adder Generator Testbench ===");
        $display("Demonstrating generate for loops for repetitive structures\n");
        
        // Wait for initial displays from modules
        #1;
        
        // === TEST 1: RIPPLE CARRY ADDER ===
        $display("\n--- Test 1: Ripple Carry Adder (8-bit) ---");
        
        // Test case 1: Simple addition
        rca_a = 8'd45; rca_b = 8'd78; rca_cin = 1'b0;
        #1;
        $display("Test: %d + %d + %d = %d (carry=%b)", 
                rca_a, rca_b, rca_cin, rca_sum, rca_cout);
        
        // Test case 2: Addition with carry in
        rca_a = 8'd200; rca_b = 8'd100; rca_cin = 1'b1;
        #1;
        $display("Test: %d + %d + %d = %d (carry=%b)", 
                rca_a, rca_b, rca_cin, rca_sum, rca_cout);
        
        // Test case 3: Overflow
        rca_a = 8'd255; rca_b = 8'd1; rca_cin = 1'b0;
        #1;
        $display("Test: %d + %d + %d = %d (carry=%b)", 
                rca_a, rca_b, rca_cin, rca_sum, rca_cout);
        
        // === TEST 2: CARRY-LOOKAHEAD ADDER ===
        $display("\n--- Test 2: Carry-Lookahead Adder (16-bit) ---");
        
        // Test case 1: Large numbers
        cla_a = 16'd12345; cla_b = 16'd23456; cla_cin = 1'b0;
        #1;
        $display("Test: %d + %d + %d = %d (carry=%b)", 
                cla_a, cla_b, cla_cin, cla_sum, cla_cout);
        
        // Test case 2: Near overflow
        cla_a = 16'd65000; cla_b = 16'd500; cla_cin = 1'b1;
        #1;
        $display("Test: %d + %d + %d = %d (carry=%b)", 
                cla_a, cla_b, cla_cin, cla_sum, cla_cout);
        
        // === TEST 3: PARALLEL PREFIX ADDER ===
        $display("\n--- Test 3: Parallel Prefix Adder (8-bit) ---");
        
        // Test case 1: Pattern that exercises prefix network
        ppa_a = 8'b10101010; ppa_b = 8'b01010101; ppa_cin = 1'b0;
        #1;
        $display("Test: 0x%02h + 0x%02h + %d = 0x%02h (carry=%b)", 
                ppa_a, ppa_b, ppa_cin, ppa_sum, ppa_cout);
        
        // Test case 2: All ones (worst case)
        ppa_a = 8'b11111111; ppa_b = 8'b00000001; ppa_cin = 1'b0;
        #1;
        $display("Test: 0x%02h + 0x%02h + %d = 0x%02h (carry=%b)", 
                ppa_a, ppa_b, ppa_cin, ppa_sum, ppa_cout);
        
        // === TEST 4: MULTI-OPERAND ADDER ===
        $display("\n--- Test 4: Multi-Operand Adder (8 operands) ---");
        
        // Initialize operands
        for (int i = 0; i < 8; i++) begin
            multi_operands[i] = 8'(i * 10 + 5); // 5, 15, 25, 35, 45, 55, 65, 75
        end
        
        #1;
        $display("Operands: ", $time);
        for (int i = 0; i < 8; i++) begin
            $write("%d ", multi_operands[i]);
        end
        $display("");
        $display("Sum: %d, Overflow: %b", multi_sum, multi_overflow);
        
        // Verify manually
        begin
            int manual_sum = 0;
            for (int i = 0; i < 8; i++) begin
                manual_sum += int'(multi_operands[i]);
            end
            $display("Manual verification: %d", manual_sum);
        end
        
        // === TEST 5: PARALLEL ADDER ARRAY ===
        $display("\n--- Test 5: Parallel Adder Array (4 adders) ---");
        
        // Initialize array inputs
        for (int i = 0; i < ARRAY_SIZE; i++) begin
            array_a[i] = 8'(i * 20 + 10);
            array_b[i] = 8'(i * 15 + 25);
            array_cin[i] = i[0]; // Alternating 0,1,0,1
        end
        
        #1;
        $display("Array Test Results:");
        $display("  Adder | A   | B   | Cin | Sum(RCA) | Cout | Sum(CLA) | Cout");
        $display("  ------|-----|-----|-----|----------|------|----------|------");
        for (int i = 0; i < ARRAY_SIZE; i++) begin
            $display("    %0d   | %3d | %3d |  %1d  |   %3d    |  %1d   |   %3d    |  %1d", 
                    i, array_a[i], array_b[i], array_cin[i], 
                    array_sum_ripple[i], array_cout_ripple[i],
                    array_sum_cla[i], array_cout_cla[i]);
        end
        
        // === COMPARISON TEST ===
        $display("\n--- Comparison Test: All Adder Types ---");
        $display("Testing same inputs on different adder architectures");
        
        // Set same inputs for all 8-bit adders
        rca_a = 8'd123; rca_b = 8'd134; rca_cin = 1'b1;
        ppa_a = 8'd123; ppa_b = 8'd134; ppa_cin = 1'b1;
        
        #1;
        $display("Input: A=%d, B=%d, Cin=%d", rca_a, rca_b, rca_cin);
        $display("Ripple Carry:     Sum=%d, Cout=%b", rca_sum, rca_cout);
        $display("Parallel Prefix:  Sum=%d, Cout=%b", ppa_sum, ppa_cout);
        
        // Verify they match
        if (rca_sum == ppa_sum && rca_cout == ppa_cout) begin
            $display("✓ All adder types produce identical results");
        end else begin
            $display("✗ Adder results don't match!");
        end
        
        // === STRESS TEST ===
        $display("\n--- Stress Test: Random Inputs ---");
        
        for (int test = 0; test < 10; test++) begin
            logic [7:0] rand_a, rand_b;
            logic rand_cin;
            logic [8:0] expected;
            
            rand_a = 8'($random & 8'hFF);
            rand_b = 8'($random & 8'hFF);
            rand_cin = 1'($random & 1'b1);
            
            rca_a = rand_a; rca_b = rand_b; rca_cin = rand_cin;
            ppa_a = rand_a; ppa_b = rand_b; ppa_cin = rand_cin;
            
            #1;
            
            // Expected result
            expected = 9'(rand_a) + 9'(rand_b) + 9'(rand_cin);
            
            if (rca_sum == expected[7:0] && rca_cout == expected[8] &&
                ppa_sum == expected[7:0] && ppa_cout == expected[8]) begin
                $display("  Test %2d: ✓ %d + %d + %d = %d (carry=%b)", 
                        test+1, rand_a, rand_b, rand_cin, expected[7:0], expected[8]);
            end else begin
                $display("  Test %2d: ✗ Mismatch for %d + %d + %d", 
                        test+1, rand_a, rand_b, rand_cin);
            end
        end
        
        $display("\n--- Summary ---");
        $display("This example demonstrated generate for loops for:");
        $display("1. Creating repetitive structures (full adders in ripple carry)");
        $display("2. Hierarchical generation (CLA blocks)");
        $display("3. Multi-level tree structures (parallel prefix network)");
        $display("4. Parameterized structure generation (adder trees)");
        $display("5. Conditional generation (different adder types)");
        
        $display("\nKey generate for loop benefits:");
        $display("- Scalable hardware generation");
        $display("- Parameterized repetitive structures");
        $display("- Compile-time loop unrolling");
        $display("- Hierarchical design patterns");
        $display("- Clean, maintainable code");
        
        $display("\n=== Testbench Complete ===");
        $finish;
    end

endmodule