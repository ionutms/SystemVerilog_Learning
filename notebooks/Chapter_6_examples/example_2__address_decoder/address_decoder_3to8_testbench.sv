// address_decoder_3to8_testbench.sv
module address_decoder_testbench;

    // Test signals
    logic [2:0] test_address;
    logic       test_enable;
    logic [7:0] decoded_outputs;

    // Instantiate the design under test
    address_decoder_3to8 DUT (
        .address(test_address),
        .enable(test_enable),
        .decoded_out(decoded_outputs)
    );

    initial begin
        // Setup waveform dumping
        $dumpfile("address_decoder_3to8_testbench.vcd");
        $dumpvars(0, address_decoder_3to8_testbench);
        
        $display("=== 3-to-8 Address Decoder Test ===");
        $display();
        
        // Test 1: Decoder disabled (enable = 0)
        $display("Test 1: Testing with Enable = 0 (decoder disabled)");
        test_enable = 1'b0;
        
        for (int i = 0; i < 8; i++) begin
            test_address = i[2:0];
            #10;
        end
        
        $display();
        
        // Test 2: Decoder enabled, test all addresses
        $display("Test 2: Testing with Enable = 1 (decoder enabled)");
        test_enable = 1'b1;
        
        for (int i = 0; i < 8; i++) begin
            test_address = i[2:0];
            #10;
            
            // Verify one-hot encoding
            if ($countones(decoded_outputs) == 1) begin
                $display("Address %0d correctly decoded to one-hot", i);
            end else begin
                $display("ERROR: Address %0d not one-hot output!", i);
            end
        end
        
        $display();
        
        // Test 3: Enable/disable transitions
        $display("Test 3: Testing enable/disable transitions");
        test_address = 3'b101; // Address 5
        
        $display("Setting address to 5, then toggling enable...");
        test_enable = 1'b1;
        #10;
        test_enable = 1'b0;
        #10;
        test_enable = 1'b1;
        #10;
        
        $display();
        $display("=== Address Decoder Test Complete ===");
        $display("One-hot encoding: Only one output bit high per address");
        $display("Enable control: All outputs 0 when enable is low");
        $display("Address range: 3-bit input covers addresses 0-7");
        
        $finish;
    end

    // Monitor for any unexpected behavior
    always @(decoded_outputs) begin
        if (test_enable && ($countones(decoded_outputs) != 1)) begin
            $display("WARNING: Non one-hot output detected when enabled!");
        end
    end

endmodule