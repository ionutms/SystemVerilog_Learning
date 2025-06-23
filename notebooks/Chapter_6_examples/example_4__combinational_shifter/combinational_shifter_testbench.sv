// combinational_shifter_testbench.sv
module shifter_testbench;

    // Test signals
    logic [7:0] test_data;
    logic [2:0] test_shift_amt;
    logic [1:0] test_shift_op;
    logic [7:0] shifted_result;

    // Operation names for display
    string op_names[4] = '{"LSL", "LSR", "ASR", "ROR"};

    // Instantiate the design under test
    combinational_shifter DUT (
        .data_in(test_data),
        .shift_amt(test_shift_amt),
        .shift_op(test_shift_op),
        .data_out(shifted_result)
    );

    initial begin
        // Setup waveform dumping
        $dumpfile("shifter_testbench.vcd");
        $dumpvars(0, shifter_testbench);
        
        $display("=== Combinational Shifter Test ===");
        $display();
        
        // Test 1: Logical shift left (LSL)
        $display("Test 1: Logical Shift Left (LSL)");
        test_data = 8'b10110011;
        test_shift_op = 2'b00; // LSL
        
        for (int i = 0; i <= 4; i++) begin
            test_shift_amt = i[2:0];
            #10;
        end
        
        $display();
        
        // Test 2: Logical shift right (LSR)
        $display("Test 2: Logical Shift Right (LSR)");
        test_data = 8'b10110011;
        test_shift_op = 2'b01; // LSR
        
        for (int i = 0; i <= 4; i++) begin
            test_shift_amt = i[2:0];
            #10;
        end
        
        $display();
        
        // Test 3: Arithmetic shift right (ASR)
        $display("Test 3: Arithmetic Shift Right (ASR) - Negative number");
        test_data = 8'b11010110; // Negative in 2's complement
        test_shift_op = 2'b10; // ASR
        
        for (int i = 0; i <= 4; i++) begin
            test_shift_amt = i[2:0];
            #10;
        end
        
        $display();
        
        // Test 4: ASR with positive number
        $display("Test 4: Arithmetic Shift Right (ASR) - Positive number");
        test_data = 8'b01010110; // Positive number
        test_shift_op = 2'b10; // ASR
        
        for (int i = 0; i <= 3; i++) begin
            test_shift_amt = i[2:0];
            #10;
        end
        
        $display();
        
        // Test 5: Rotate right (ROR)
        $display("Test 5: Rotate Right (ROR)");
        test_data = 8'b10110001;
        test_shift_op = 2'b11; // ROR
        
        for (int i = 0; i <= 7; i++) begin
            test_shift_amt = i[2:0];
            #10;
        end
        
        $display();
        
        // Test 6: Edge cases
        $display("Test 6: Edge cases");
        
        // All zeros
        test_data = 8'b00000000;
        test_shift_op = 2'b00; // LSL
        test_shift_amt = 3'd3;
        #10;
        
        // All ones
        test_data = 8'b11111111;
        test_shift_op = 2'b01; // LSR
        test_shift_amt = 3'd2;
        #10;
        
        // Maximum shift
        test_data = 8'b10101010;
        test_shift_op = 2'b00; // LSL
        test_shift_amt = 3'd7;
        #10;
        
        $display();
        $display("=== Shifter Test Complete ===");
        $display("LSL: Logical shift left - zeros fill from right");
        $display("LSR: Logical shift right - zeros fill from left");
        $display("ASR: Arithmetic shift right - sign bit extends");
        $display("ROR: Rotate right - bits wrap around");
        $display();
        
        $finish;
    end

    // Function to verify LSL operation
    function logic [7:0] expected_lsl(logic [7:0] data, logic [2:0] amt);
        return data << amt;
    endfunction

    // Function to verify LSR operation
    function logic [7:0] expected_lsr(logic [7:0] data, logic [2:0] amt);
        return data >> amt;
    endfunction

    // Function to verify ASR operation
    function logic [7:0] expected_asr(logic [7:0] data, logic [2:0] amt);
        return $signed(data) >>> amt;
    endfunction

    // Function to verify ROR operation
    function logic [7:0] expected_ror(logic [7:0] data, logic [2:0] amt);
        case (amt)
            3'd0: return data;
            3'd1: return {data[0], data[7:1]};
            3'd2: return {data[1:0], data[7:2]};
            3'd3: return {data[2:0], data[7:3]};
            3'd4: return {data[3:0], data[7:4]};
            3'd5: return {data[4:0], data[7:5]};
            3'd6: return {data[5:0], data[7:6]};
            3'd7: return {data[6:0], data[7]};
        endcase
    endfunction

    // Monitor and verify all operations
    always @(shifted_result) begin
        #1; // Small delay for display
        case (test_shift_op)
            2'b00: begin // LSL verification
                if (shifted_result == expected_lsl(test_data, test_shift_amt)) begin
                    $display("LSL verification passed");
                end else begin
                    $display(
                        "LSL verification failed! Expected: %8b, Got: %8b", 
                        expected_lsl(test_data, test_shift_amt),
                        shifted_result);
                end
            end
            2'b01: begin // LSR verification
                if (shifted_result == expected_lsr(test_data, test_shift_amt)) begin
                    $display("LSR verification passed");
                end else begin
                    $display(
                        "LSR verification failed! Expected: %8b, Got: %8b", 
                        expected_lsr(test_data, test_shift_amt),
                        shifted_result);
                end
            end
            2'b10: begin // ASR verification
                if (shifted_result == expected_asr(test_data, test_shift_amt)) begin
                    $display("ASR verification passed");
                end else begin
                    $display(
                        "ASR verification failed! Expected: %8b, Got: %8b", 
                        expected_asr(test_data, test_shift_amt),
                        shifted_result);
                end
            end
            2'b11: begin // ROR verification
                if (shifted_result == expected_ror(test_data, test_shift_amt)) begin
                    $display("ROR verification passed");
                end else begin
                    $display(
                        "ROR verification failed! Expected: %8b, Got: %8b", 
                        expected_ror(test_data, test_shift_amt),
                        shifted_result);
                end
            end
            default: begin
                $display("Unknown operation: %2b", test_shift_op);
            end
        endcase
    end

endmodule