// ripple_carry_adder_testbench.sv
module ripple_carry_adder_testbench;
    // Parameters for different width testing
    parameter WIDTH_8 = 8;
    parameter WIDTH_4 = 4;
    
    // Testbench signals for 8-bit adder
    logic [WIDTH_8-1:0] a8, b8, sum8;
    logic cin8, cout8;
    
    // Testbench signals for 4-bit adder
    logic [WIDTH_4-1:0] a4, b4, sum4;
    logic cin4, cout4;
    
    // Expected results
    logic [WIDTH_8:0] expected_result8;
    logic [WIDTH_4:0] expected_result4;
    
    // Instantiate 8-bit ripple carry adder
    ripple_carry_adder #(.WIDTH(WIDTH_8)) DUT_8bit (
        .a(a8),
        .b(b8),
        .cin(cin8),
        .sum(sum8),
        .cout(cout8)
    );
    
    // Instantiate 4-bit ripple carry adder
    ripple_carry_adder #(.WIDTH(WIDTH_4)) DUT_4bit (
        .a(a4),
        .b(b4),
        .cin(cin4),
        .sum(sum4),
        .cout(cout4)
    );
    
    // Task to test 8-bit adder
    task test_8bit_adder(logic [7:0] test_a, logic [7:0] test_b, logic test_cin, string description);
        a8 = test_a;
        b8 = test_b;
        cin8 = test_cin;
        expected_result8 = {1'b0, test_a} + {1'b0, test_b} + {8'b0, test_cin};
        #1; // Wait for combinational logic
        
        $display("8-bit Test: %s", description);
        $display("  A = %8b (%3d), B = %8b (%3d), Cin = %b", a8, a8, b8, b8, cin8);
        $display("  Sum = %8b (%3d), Cout = %b", sum8, sum8, cout8);
        $display("  Expected: %9b (%3d)", expected_result8, expected_result8);
        $display("  Result: %s", ({cout8, sum8} == expected_result8) ? "PASS" : "FAIL");
        $display("  Carry chain: %b", DUT_8bit.carry);
        $display();
    endtask
    
    // Task to test 4-bit adder
    task test_4bit_adder(logic [3:0] test_a, logic [3:0] test_b, logic test_cin, string description);
        a4 = test_a;
        b4 = test_b;
        cin4 = test_cin;
        expected_result4 = {1'b0, test_a} + {1'b0, test_b} + {4'b0, test_cin};
        #1; // Wait for combinational logic
        
        $display("4-bit Test: %s", description);
        $display("  A = %4b (%2d), B = %4b (%2d), Cin = %b", a4, a4, b4, b4, cin4);
        $display("  Sum = %4b (%2d), Cout = %b", sum4, sum4, cout4);
        $display("  Expected: %5b (%2d)", expected_result4, expected_result4);
        $display("  Result: %s", ({cout4, sum4} == expected_result4) ? "PASS" : "FAIL");
        $display("  Carry chain: %b", DUT_4bit.carry);
        $display();
    endtask
    
    // Test stimulus
    initial begin
        // Dump waves
        $dumpfile("ripple_carry_adder_testbench.vcd");
        $dumpvars(0, ripple_carry_adder_testbench);
        
        $display("Starting Ripple Carry Adder Test");
        $display("================================");
        $display();
        
        // === 8-BIT ADDER TESTS ===
        $display("=== 8-BIT RIPPLE CARRY ADDER TESTS ===");
        $display();
        
        // Basic addition tests
        test_8bit_adder(8'd0, 8'd0, 1'b0, "Zero + Zero");
        test_8bit_adder(8'd15, 8'd10, 1'b0, "15 + 10");
        test_8bit_adder(8'd255, 8'd0, 1'b0, "255 + 0");
        test_8bit_adder(8'd128, 8'd127, 1'b0, "128 + 127");
        
        // Test with carry in
        test_8bit_adder(8'd100, 8'd50, 1'b1, "100 + 50 + 1 (with carry in)");
        test_8bit_adder(8'd255, 8'd255, 1'b1, "255 + 255 + 1 (maximum with carry)");
        
        // Overflow tests
        test_8bit_adder(8'd255, 8'd1, 1'b0, "255 + 1 (overflow)");
        test_8bit_adder(8'd200, 8'd100, 1'b0, "200 + 100 (overflow)");
        
        // Pattern tests
        test_8bit_adder(8'b10101010, 8'b01010101, 1'b0, "Alternating patterns");
        test_8bit_adder(8'b11110000, 8'b00001111, 1'b0, "Complementary patterns");
        
        $display("=== 4-BIT RIPPLE CARRY ADDER TESTS ===");
        $display();
        
        // === 4-BIT ADDER TESTS ===
        test_4bit_adder(4'd0, 4'd0, 1'b0, "Zero + Zero");
        test_4bit_adder(4'd7, 4'd8, 1'b0, "7 + 8");
        test_4bit_adder(4'd15, 4'd0, 1'b0, "15 + 0");
        test_4bit_adder(4'd9, 4'd6, 1'b1, "9 + 6 + 1 (with carry in)");
        test_4bit_adder(4'd15, 4'd15, 1'b0, "15 + 15 (maximum)");
        test_4bit_adder(4'd15, 4'd15, 1'b1, "15 + 15 + 1 (maximum with carry)");
        
        // Overflow tests
        test_4bit_adder(4'd15, 4'd1, 1'b0, "15 + 1 (overflow)");
        test_4bit_adder(4'd10, 4'd8, 1'b0, "10 + 8 (overflow)");
        
        // === EXHAUSTIVE 4-BIT TEST ===
        $display("=== EXHAUSTIVE 4-BIT TEST (selected cases) ===");
        $display();
        
        // Test a few representative cases from exhaustive testing
        for (int i = 0; i < 16; i += 5) begin
            for (int j = 0; j < 16; j += 7) begin
                for (int c = 0; c < 2; c++) begin
                    test_4bit_adder(i[3:0], j[3:0], c[0], $sformatf("Exhaustive: %d + %d + %d", i, j, c));
                end
            end
        end
        
        // === TIMING TEST ===
        $display("=== PROPAGATION DELAY TEST ===");
        $display();
        
        // Test carry propagation through all stages
        a8 = 8'b11111111;
        b8 = 8'b00000000;
        cin8 = 1'b1;
        $display("Testing carry propagation: 11111111 + 00000000 + 1");
        $display("This should cause carry to ripple through all stages");
        
        #1;
        $display("Final result: Sum = %8b, Cout = %b", sum8, cout8);
        $display("Carry chain: %b", DUT_8bit.carry);
        $display();
        
        $display("================================");
        $display("All tests completed!");
        $display("================================");
        
        $finish;
    end

endmodule