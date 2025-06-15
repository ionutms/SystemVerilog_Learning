// alu_testbench.sv
module alu_testbench;  // Testbench module
    
    // Testbench signals
    logic [3:0] opcode;
    logic [7:0] a, b;
    logic [7:0] result;
    logic zero;
    
    // Test counters
    integer test_count = 0;
    integer pass_count = 0;
    
    // ALU operation names for display
    string op_names[8] = '{
        "ADD", "SUB", "AND", "OR", "XOR", "NOT", "SHL", "SHR"
    };
    
    // Instantiate design under test
    alu DUT (
        .opcode(opcode),
        .a(a),
        .b(b),
        .result(result),
        .zero(zero)
    );

    // Task to run a test case
    task run_test(
        input [3:0] test_opcode,
        input [7:0] test_a, test_b,
        input [7:0] expected_result,
        input expected_zero,
        input string test_description
    );
        test_count++;
        opcode = test_opcode;
        a = test_a;
        b = test_b;
        #1; // Wait for combinational logic to settle
        
        $display("Test %0d: %s", test_count, test_description);
        if (test_opcode <= 4'b0111) begin
            $display("  Operation: %s (opcode=4'b%04b)", op_names[test_opcode[2:0]], test_opcode);
        end else begin
            $display("  Operation: INVALID (opcode=4'b%04b)", test_opcode);
        end
        $display("  Inputs: a=8'h%02h (%0d), b=8'h%02h (%0d)", a, a, b, b);
        $display("  Result: 8'h%02h (%0d), zero=%b", result, result, zero);
        $display("  Expected: 8'h%02h (%0d), zero=%b", expected_result, expected_result, expected_zero);
        
        if (result == expected_result && zero == expected_zero) begin
            $display("PASS");
            pass_count++;
        end else begin
            $display("FAIL");
            $error("Test %0d failed: Expected result=8'h%02h, zero=%b, got result=8'h%02h, zero=%b", 
                   test_count, expected_result, expected_zero, result, zero);
        end
        $display();
    endtask

    initial begin
        // Dump waves
        $dumpfile("alu_testbench.vcd");       // Specify the VCD file
        $dumpvars(0, alu_testbench);          // Dump all variables in the test module
        
        $display("Hello from testbench!");
        $display("Starting ALU Tests");
        $display("==================");
        $display();
        $display("8-bit ALU with 4-bit opcode");
        $display("Operations: ADD(0), SUB(1), AND(2), OR(3), XOR(4), NOT(5), SHL(6), SHR(7)");
        $display("Zero flag indicates when result equals 0");
        $display();

        // Test 1: ADD operations
        run_test(4'b0000, 8'h0F, 8'h10, 8'h1F, 1'b0, "ADD: 15 + 16 = 31");
        run_test(4'b0000, 8'hFF, 8'h01, 8'h00, 1'b1, "ADD: 255 + 1 = 0 (overflow, zero flag set)");
        run_test(4'b0000, 8'h00, 8'h00, 8'h00, 1'b1, "ADD: 0 + 0 = 0 (zero flag set)");
        run_test(4'b0000, 8'h7F, 8'h7F, 8'hFE, 1'b0, "ADD: 127 + 127 = 254");

        // Test 2: SUB operations
        run_test(4'b0001, 8'h20, 8'h10, 8'h10, 1'b0, "SUB: 32 - 16 = 16");
        run_test(4'b0001, 8'h10, 8'h10, 8'h00, 1'b1, "SUB: 16 - 16 = 0 (zero flag set)");
        run_test(4'b0001, 8'h10, 8'h20, 8'hF0, 1'b0, "SUB: 16 - 32 = -16 (underflow)");
        run_test(4'b0001, 8'hFF, 8'h01, 8'hFE, 1'b0, "SUB: 255 - 1 = 254");

        // Test 3: AND operations
        run_test(4'b0010, 8'hFF, 8'hAA, 8'hAA, 1'b0, "AND: 0xFF & 0xAA = 0xAA");
        run_test(4'b0010, 8'hF0, 8'h0F, 8'h00, 1'b1, "AND: 0xF0 & 0x0F = 0x00 (zero flag set)");
        run_test(4'b0010, 8'hFF, 8'hFF, 8'hFF, 1'b0, "AND: 0xFF & 0xFF = 0xFF");
        run_test(4'b0010, 8'h55, 8'hAA, 8'h00, 1'b1, "AND: 0x55 & 0xAA = 0x00");

        // Test 4: OR operations
        run_test(4'b0011, 8'hF0, 8'h0F, 8'hFF, 1'b0, "OR: 0xF0 | 0x0F = 0xFF");
        run_test(4'b0011, 8'h00, 8'h00, 8'h00, 1'b1, "OR: 0x00 | 0x00 = 0x00 (zero flag set)");
        run_test(4'b0011, 8'h55, 8'hAA, 8'hFF, 1'b0, "OR: 0x55 | 0xAA = 0xFF");
        run_test(4'b0011, 8'h12, 8'h34, 8'h36, 1'b0, "OR: 0x12 | 0x34 = 0x36");

        // Test 5: XOR operations
        run_test(4'b0100, 8'hFF, 8'hFF, 8'h00, 1'b1, "XOR: 0xFF ^ 0xFF = 0x00 (zero flag set)");
        run_test(4'b0100, 8'h55, 8'hAA, 8'hFF, 1'b0, "XOR: 0x55 ^ 0xAA = 0xFF");
        run_test(4'b0100, 8'hF0, 8'h0F, 8'hFF, 1'b0, "XOR: 0xF0 ^ 0x0F = 0xFF");
        run_test(4'b0100, 8'h12, 8'h12, 8'h00, 1'b1, "XOR: 0x12 ^ 0x12 = 0x00");

        // Test 6: NOT operations (b input ignored)
        run_test(4'b0101, 8'hFF, 8'h00, 8'h00, 1'b1, "NOT: ~0xFF = 0x00 (zero flag set)");
        run_test(4'b0101, 8'h00, 8'hFF, 8'hFF, 1'b0, "NOT: ~0x00 = 0xFF");
        run_test(4'b0101, 8'hAA, 8'h00, 8'h55, 1'b0, "NOT: ~0xAA = 0x55");
        run_test(4'b0101, 8'hF0, 8'h00, 8'h0F, 1'b0, "NOT: ~0xF0 = 0x0F");

        // Test 7: Shift Left operations (b input ignored)
        run_test(4'b0110, 8'h01, 8'h00, 8'h02, 1'b0, "SHL: 0x01 << 1 = 0x02");
        run_test(4'b0110, 8'h80, 8'h00, 8'h00, 1'b1, "SHL: 0x80 << 1 = 0x00 (MSB lost, zero flag set)");
        run_test(4'b0110, 8'h55, 8'h00, 8'hAA, 1'b0, "SHL: 0x55 << 1 = 0xAA");
        run_test(4'b0110, 8'h7F, 8'h00, 8'hFE, 1'b0, "SHL: 0x7F << 1 = 0xFE");

        // Test 8: Shift Right operations (b input ignored)
        run_test(4'b0111, 8'h02, 8'h00, 8'h01, 1'b0, "SHR: 0x02 >> 1 = 0x01");
        run_test(4'b0111, 8'h01, 8'h00, 8'h00, 1'b1, "SHR: 0x01 >> 1 = 0x00 (LSB lost, zero flag set)");
        run_test(4'b0111, 8'hAA, 8'h00, 8'h55, 1'b0, "SHR: 0xAA >> 1 = 0x55");
        run_test(4'b0111, 8'hFE, 8'h00, 8'h7F, 1'b0, "SHR: 0xFE >> 1 = 0x7F");

        // Test 9: Invalid opcodes (default case)
        run_test(4'b1000, 8'hFF, 8'hFF, 8'h00, 1'b1, "Invalid opcode 8 -> default result 0x00");
        run_test(4'b1111, 8'hAA, 8'h55, 8'h00, 1'b1, "Invalid opcode 15 -> default result 0x00");

        // Test 10: Edge cases
        run_test(4'b0000, 8'h80, 8'h80, 8'h00, 1'b1, "ADD edge: 0x80 + 0x80 = 0x00 (overflow)");
        run_test(4'b0001, 8'h00, 8'h01, 8'hFF, 1'b0, "SUB edge: 0x00 - 0x01 = 0xFF (underflow)");

        // Summary
        $display("Test Summary:");
        $display("============");
        $display("Total tests: %0d", test_count);
        $display("Passed: %0d", pass_count);
        $display("Failed: %0d", test_count - pass_count);
        
        if (pass_count == test_count) begin
            $display("ALL TESTS PASSED!");
        end else begin
            $display("Some tests failed. Please review.");
        end
        
        $display();
        $display("ALU Testing Complete!");
        $display("====================");
        $display();
        
        $finish;  // End simulation
    end

endmodule