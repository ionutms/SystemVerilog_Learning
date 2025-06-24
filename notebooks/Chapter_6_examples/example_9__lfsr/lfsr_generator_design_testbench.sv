// lfsr_generator_design_testbench.sv
module lfsr_generator_testbench;
    
    // Testbench signals
    logic clock;
    logic reset_n;
    logic enable;
    logic [3:0] lfsr_output;
    logic random_bit;
    
    // Variables for sequence tracking
    logic [3:0] sequence_history [0:15];
    integer cycle_count;
    
    // Instantiate the LFSR generator design
    lfsr_4bit_generator LFSR_GENERATOR_INSTANCE (
        .clock(clock),
        .reset_n(reset_n),
        .enable(enable),
        .lfsr_output(lfsr_output),
        .random_bit(random_bit)
    );
    
    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end
    
    // Test sequence
    initial begin
        // Setup waveform dumping
        $dumpfile("lfsr_generator_testbench.vcd");
        $dumpvars(0, lfsr_generator_testbench);
        
        // Display header
        $display();
        $display("=== 4-Bit LFSR Pseudo-Random Generator Test ===");
        $display("Polynomial: x^4 + x^3 + 1 (taps at positions 4,3)");
        $display();
        $display("Cycle | LFSR State | Random Bit | Feedback");
        $display("------|------------|------------|----------");
        
        // Initialize signals and counters
        reset_n = 0;
        enable = 0;
        cycle_count = 0;
        
        // Apply reset
        #10;
        reset_n = 1;
        
        // Enable the LFSR and observe the pseudo-random sequence
        #5;
        enable = 1;
        
        // Run through complete sequence (2^4 - 1 = 15 states for 4-bit LFSR)
        repeat(16) begin
            #10;
            sequence_history[cycle_count] = lfsr_output;
            $display("  %2d  |    %b    |     %b      |    %b", 
                     cycle_count, lfsr_output, random_bit, 
                     lfsr_output[3] ^ lfsr_output[2]);
            cycle_count++;
        end
        
        // Check if sequence repeats (should return to initial state)
        $display();
        if (lfsr_output == 4'b0001) begin
            $display("✓ LFSR sequence completed full cycle (returned to initial state)");
        end else begin
            $display("✗ LFSR did not complete full cycle");
        end
        
        // Test disable functionality
        $display();
        $display("Testing disable...");
        enable = 0;
        #20;
        $display("LFSR disabled - State frozen at: %b", lfsr_output);
        
        // Re-enable
        enable = 1;
        #20;
        $display("LFSR re-enabled - Continuing from: %b", lfsr_output);
        
        // Test reset during operation
        $display();
        $display("Testing reset during operation...");
        #10;
        reset_n = 0;
        #10;
        reset_n = 1;
        $display("After reset - LFSR state: %b", lfsr_output);
        
        // Show a few more random bits
        $display();
        $display("Generating random bit stream:");
        $write("Random bits: ");
        repeat(8) begin
            #10;
            $write("%b ", random_bit);
        end
        $display();
        
        $display();
        $display("=== LFSR Test Complete ===");
        $display("Maximum sequence length for 4-bit LFSR: %d states", 2**4 - 1);
        $display();
        
        #20;
        $finish;
    end

endmodule