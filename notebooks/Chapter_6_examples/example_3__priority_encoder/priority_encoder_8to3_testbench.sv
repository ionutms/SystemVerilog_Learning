// priority_encoder_8to3_testbench.sv
module priority_encoder_testbench;

    // Test signals
    logic [7:0] test_data_in;
    logic [2:0] encoded_result;
    logic       valid_result;

    // Instantiate the design under test
    priority_encoder_8to3 DUT (
        .data_in(test_data_in),
        .encoded_out(encoded_result),
        .valid_out(valid_result)
    );

    initial begin
        // Setup waveform dumping
        $dumpfile("priority_encoder_testbench.vcd");
        $dumpvars(0, priority_encoder_testbench);
        
        $display("=== 8-to-3 Priority Encoder Test ===");
        $display();
        
        // Test 1: No inputs active
        $display("Test 1: No inputs active");
        test_data_in = 8'b00000000;
        #10;
        
        $display();
        
        // Test 2: Single bit tests (test each priority level)
        $display("Test 2: Testing each input individually");
        for (int i = 0; i < 8; i++) begin
            test_data_in = 8'b00000001 << i;
            #10;
            
            // Verify correct encoding
            if (valid_result && (encoded_result == i[2:0])) begin
                $display("Input bit %0d correctly encoded", i);
            end else begin
                $display("ERROR: Input bit %0d encoding failed!", i);
            end
        end
        
        $display();
        
        // Test 3: Priority tests (multiple bits active)
        $display("Test 3: Testing priority behavior");
        
        // High priority wins over low priority
        test_data_in = 8'b10000001; // Bit 7 and 0 active
        #10;
        if (encoded_result == 3'b111) begin
            $display("Bit 7 correctly wins over bit 0");
        end else begin
            $display("ERROR: Priority not working correctly!");
        end
        
        // Middle priority test
        test_data_in = 8'b00101010; // Bits 5, 3, 1 active
        #10;
        if (encoded_result == 3'b101) begin
            $display("Bit 5 correctly wins over bits 3,1");
        end else begin
            $display("ERROR: Middle priority test failed!");
        end
        
        // All bits active (highest should win)
        test_data_in = 8'b11111111;
        #10;
        if (encoded_result == 3'b111) begin
            $display("Bit 7 correctly wins when all bits active");
        end else begin
            $display("ERROR: All bits test failed!");
        end
        
        $display();
        
        // Test 4: Random priority patterns
        $display("Test 4: Testing various priority patterns");
        
        test_data_in = 8'b01100000; // Bits 6,5 active -> 6 wins
        #10;
        
        test_data_in = 8'b00011100; // Bits 4,3,2 active -> 4 wins
        #10;
        
        test_data_in = 8'b00000110; // Bits 2,1 active -> 2 wins
        #10;
        
        $display();
        $display("=== Priority Encoder Test Complete ===");
        $display("Priority order: Bit 7 (highest) down to Bit 0 (lowest)");
        $display("Valid signal: Indicates at least one input is active");
        $display("Encoding: Highest priority active input -> binary output");
        $display();
        
        $finish;
    end

    // Monitor for unexpected behavior
    always @(test_data_in) begin
        #1; // Small delay to let combinational logic settle
        if (test_data_in != 8'b00000000 && !valid_result) begin
            $display("WARNING: Valid should be high when inputs are active!");
        end
        if (test_data_in == 8'b00000000 && valid_result) begin
            $display("WARNING: Valid should be low when no inputs active!");
        end
    end

endmodule