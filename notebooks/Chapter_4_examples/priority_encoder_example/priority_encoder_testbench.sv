// priority_encoder_testbench.sv
module priority_encoder_testbench;  // Testbench module
    
    // Testbench signals
    logic [7:0] data_in;
    logic [2:0] encoded_out;
    logic valid;
    
    // Test counter
    integer test_count = 0;
    integer pass_count = 0;
    
    // Instantiate design under test
    priority_encoder DUT (
        .data_in(data_in),
        .encoded_out(encoded_out),
        .valid(valid)
    );

    // Task to run a test case
    task run_test(
        input [7:0] test_data,
        input [2:0] expected_out,
        input expected_valid,
        input string test_name
    );
        test_count++;
        data_in = test_data;
        #1; // Wait for combinational logic to settle
        
        $display("Test %0d: %s", test_count, test_name);
        $display("  Input: 8'b%08b (0x%02h)", data_in, data_in);
        $display("  Output: encoded_out=%0d, valid=%b", encoded_out, valid);
        $display("  Expected: encoded_out=%0d, valid=%b", expected_out, expected_valid);
        
        if (encoded_out == expected_out && valid == expected_valid) begin
            $display("PASS");
            pass_count++;
        end else begin
            $display("FAIL");
            $error("Test %0d failed: Expected encoded_out=%0d, valid=%b, got encoded_out=%0d, valid=%b", 
                   test_count, expected_out, expected_valid, encoded_out, valid);
        end
        $display();
    endtask

    initial begin
        // Dump waves
        $dumpfile("priority_encoder_testbench.vcd");       // Specify the VCD file
        $dumpvars(0, priority_encoder_testbench);          // Dump all variables in the test module
        
        $display();
        $display("Hello from testbench!");
        $display("Starting Priority Encoder Tests");
        $display("==============================");
        $display();
        $display("Priority Encoder: Encodes the position of the highest priority (MSB) active bit");
        $display("- 8-bit input, 3-bit encoded output");
        $display("- Bit 7 has highest priority, Bit 0 has lowest priority");
        $display("- Valid output indicates if any input bit is active");
        $display();

        // Test 1: No input (all zeros)
        run_test(8'b00000000, 3'd0, 1'b0, "All zeros - no valid input");

        // Test 2: Single bit tests (one bit at a time)
        run_test(8'b00000001, 3'd0, 1'b1, "Only bit 0 active");
        run_test(8'b00000010, 3'd1, 1'b1, "Only bit 1 active");
        run_test(8'b00000100, 3'd2, 1'b1, "Only bit 2 active");
        run_test(8'b00001000, 3'd3, 1'b1, "Only bit 3 active");
        run_test(8'b00010000, 3'd4, 1'b1, "Only bit 4 active");
        run_test(8'b00100000, 3'd5, 1'b1, "Only bit 5 active");
        run_test(8'b01000000, 3'd6, 1'b1, "Only bit 6 active");
        run_test(8'b10000000, 3'd7, 1'b1, "Only bit 7 active (highest priority)");

        // Test 3: Multiple bits - priority should go to highest bit
        run_test(8'b10000001, 3'd7, 1'b1, "Bits 7 and 0 - priority to bit 7");
        run_test(8'b01000010, 3'd6, 1'b1, "Bits 6 and 1 - priority to bit 6");
        run_test(8'b00100100, 3'd5, 1'b1, "Bits 5 and 2 - priority to bit 5");
        run_test(8'b00011000, 3'd4, 1'b1, "Bits 4 and 3 - priority to bit 4");

        // Test 4: Sequential patterns
        run_test(8'b11111111, 3'd7, 1'b1, "All bits set - priority to bit 7");
        run_test(8'b01111111, 3'd6, 1'b1, "Bits 6-0 set - priority to bit 6");
        run_test(8'b00111111, 3'd5, 1'b1, "Bits 5-0 set - priority to bit 5");
        run_test(8'b00011111, 3'd4, 1'b1, "Bits 4-0 set - priority to bit 4");
        run_test(8'b00001111, 3'd3, 1'b1, "Bits 3-0 set - priority to bit 3");
        run_test(8'b00000111, 3'd2, 1'b1, "Bits 2-0 set - priority to bit 2");
        run_test(8'b00000011, 3'd1, 1'b1, "Bits 1-0 set - priority to bit 1");

        // Test 5: Random patterns to verify priority
        run_test(8'b10101010, 3'd7, 1'b1, "Alternating pattern starting with bit 7");
        run_test(8'b01010101, 3'd6, 1'b1, "Alternating pattern starting with bit 6");
        run_test(8'b00110011, 3'd5, 1'b1, "Pattern 00110011 - priority to bit 5");
        run_test(8'b00001100, 3'd3, 1'b1, "Pattern 00001100 - priority to bit 3");

        // Test 6: Edge cases
        run_test(8'b11000000, 3'd7, 1'b1, "Only upper bits (7,6) - priority to bit 7");
        run_test(8'b00000011, 3'd1, 1'b1, "Only lower bits (1,0) - priority to bit 1");

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
        $display("Priority Encoder Testing Complete!");
        $display("=================================");
        $display();
        
        $finish;  // End simulation
    end

endmodule