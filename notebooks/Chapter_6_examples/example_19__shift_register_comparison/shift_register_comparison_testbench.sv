// shift_register_comparison_testbench.sv
module shift_register_testbench;

    // Testbench signals
    logic       clk;
    logic       reset_n;
    logic       shift_enable;
    logic       serial_in;
    logic [7:0] parallel_out_correct;
    logic [7:0] parallel_out_incorrect;
    logic       serial_out_correct;
    logic       serial_out_incorrect;
    
    // Test pattern for serial input
    logic test_pattern [0:15] = '{1,0,1,1,0,0,1,0,1,1,1,0,0,1,1,0};
    int pattern_index = 0;
    int cycle_count = 0;
    
    // Instantiate the shift register comparison
    shift_register_comparison SHIFT_REG_INSTANCE (
        .clk(clk),
        .reset_n(reset_n),
        .shift_enable(shift_enable),
        .serial_in(serial_in),
        .parallel_out_correct(parallel_out_correct),
        .parallel_out_incorrect(parallel_out_incorrect),
        .serial_out_correct(serial_out_correct),
        .serial_out_incorrect(serial_out_incorrect)
    );
    
    // Clock generation - 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test sequence
    initial begin
        // Dump waves for detailed analysis
        $dumpfile("shift_register_testbench.vcd");
        $dumpvars(0, shift_register_testbench);
        
        // Initialize signals
        reset_n = 0;
        shift_enable = 0;
        serial_in = 0;
        
        $display("\n=== Shift Register Assignment Comparison ===");
        $display("8-bit shift register: MSB <- serial_in ... LSB -> serial_out");
        
        // Reset sequence
        repeat(2) @(posedge clk);
        reset_n = 1;
        shift_enable = 1;
        
        $display("\n--- Test 1: Single '1' bit propagation ---");
        
        // Test 1: Send single '1' bit and observe propagation
        @(posedge clk);
        serial_in = 1;
        cycle_count++;
        $display("Cycle %0d: Input='1' -> Correct=%8b (%0d), Incorrect=%8b (%0d)", 
                 cycle_count, parallel_out_correct, parallel_out_correct, 
                 parallel_out_incorrect, parallel_out_incorrect);
        
        // Follow with zeros to see the '1' propagate
        for (int i = 0; i < 10; i++) begin
            @(posedge clk);
            serial_in = 0;
            cycle_count++;
            $display("Cycle %0d: Input='0' -> Correct=%8b (%0d), Incorrect=%8b (%0d)", 
                     cycle_count, parallel_out_correct, parallel_out_correct, 
                     parallel_out_incorrect, parallel_out_incorrect);
        end
        
        $display("\n--- Test 2: Pattern shifting ---");
        
        // Reset for pattern test
        @(posedge clk);
        reset_n = 0;
        @(posedge clk);
        reset_n = 1;
        cycle_count = 0;
        
        // Shift in test pattern
        for (int i = 0; i < 16; i++) begin
            @(posedge clk);
            serial_in = test_pattern[i];
            cycle_count++;
            
            $display("Cycle %0d: Input='%0d' -> Correct=%8b, Incorrect=%8b", 
                     cycle_count, serial_in, parallel_out_correct, parallel_out_incorrect);
            $display("         Serial Out: Correct='%0d', Incorrect='%0d'", 
                     serial_out_correct, serial_out_incorrect);
        end
        
        $display("\n--- Test 3: Demonstrating the key difference ---");
        
        // Reset and show the critical difference
        @(posedge clk);
        reset_n = 0;
        @(posedge clk);
        reset_n = 1;
        
        // Show what happens when we input '1' after reset
        $display("\nAfter reset, both registers are 00000000");
        $display("Now inputting '1'...");
        
        @(posedge clk);
        serial_in = 1;
        $display("After 1 clock with input='1':");
        $display("  CORRECT:   %8b (1 shifted to bit 7 only)", parallel_out_correct);
        $display("  INCORRECT: %8b (1 propagated through ALL bits!)", parallel_out_incorrect);
        
        @(posedge clk);
        serial_in = 0;
        $display("After 2nd clock with input='0':");
        $display("  CORRECT:   %8b (1 shifted from bit 7 to bit 6)", parallel_out_correct);
        $display("  INCORRECT: %8b (all 0s because 1 'fell out' immediately)", parallel_out_incorrect);
        
        $display("\n--- Analysis Summary ---");
        $display("BLOCKING ASSIGNMENTS (=) PROBLEM:");
        $display("- Execute sequentially within same clock cycle");
        $display("- Each assignment uses the NEW value from previous assignment");
        $display("- Creates 'shift-through' effect - data propagates through ALL stages");
        $display("- Serial input appears at serial output in SAME clock cycle!");
        $display("- NOT a real shift register - just a wire with delay");
        
        $display("\nNON-BLOCKING ASSIGNMENTS (<=) CORRECT:");
        $display("- All assignments scheduled simultaneously");
        $display("- Each assignment uses OLD values from previous clock cycle");
        $display("- Creates proper shift register behavior");
        $display("- Takes 8 clock cycles for serial input to reach serial output");
        $display("- Each bit position stores data for exactly one clock cycle");
        
        $display("\n=== Test Complete ===");
        $display("Examine VCD file to see detailed timing behavior");
        $finish;
    end
    
    // Monitor for educational purposes
    always @(posedge clk) begin
        if (reset_n && shift_enable) begin
            // Show internal register state
            $display("  Internal: Correct[7:0]=%b, Incorrect[7:0]=%b", 
                     SHIFT_REG_INSTANCE.shift_reg_correct, 
                     SHIFT_REG_INSTANCE.shift_reg_incorrect);
        end
    end

endmodule