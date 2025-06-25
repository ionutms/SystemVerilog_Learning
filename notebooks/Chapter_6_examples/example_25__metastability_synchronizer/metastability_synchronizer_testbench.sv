// metastability_synchronizer_testbench.sv
module metastability_synchronizer_testbench;
    
    // Testbench signals
    logic clk;
    logic reset_n;
    logic async_signal;
    logic sync_out_2stage, sync_out_3stage, sync_out_simple;
    
    // Clock generation (50MHz)
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;  // 20ns period
    end
    
    // Instantiate different synchronizer configurations
    metastability_synchronizer #(
        .SYNC_STAGES(2),
        .RESET_VALUE(1'b0)
    ) SYNC_2_STAGE (
        .clk(clk),
        .reset_n(reset_n),
        .async_in(async_signal),
        .sync_out(sync_out_2stage)
    );
    
    metastability_synchronizer #(
        .SYNC_STAGES(3),
        .RESET_VALUE(1'b0)
    ) SYNC_3_STAGE (
        .clk(clk),
        .reset_n(reset_n),
        .async_in(async_signal),
        .sync_out(sync_out_3stage)
    );
    
    simple_two_ff_synchronizer SIMPLE_SYNC (
        .clk(clk),
        .reset_n(reset_n),
        .async_in(async_signal),
        .sync_out(sync_out_simple)
    );
    
    // Test sequence
    initial begin
        // Dump waves
        $dumpfile("metastability_synchronizer_testbench.vcd");
        $dumpvars(0, metastability_synchronizer_testbench);
        
        $display("Starting Metastability Synchronizer Test");
        $display("Clock Period: 20ns (50MHz)");
        $display();
        
        // Initialize signals
        async_signal = 1'b0;
        reset_n = 1'b0;
        
        // Release reset
        #50;
        reset_n = 1'b1;
        $display("Reset released at time %0t ns", $time);
        $display();
        
        // Test Case 1: Async signal changes synchronized to clock
        $display("Test 1: Async signal synchronized to clock edge");
        @(posedge clk);
        async_signal = 1'b1;
        repeat (5) @(posedge clk);
        async_signal = 1'b0;
        repeat (5) @(posedge clk);
        
        // Test Case 2: Async signal changes at random times (metastability prone)
        $display("Test 2: Async signal at random times (potential metastability)");
        repeat (10) begin
            #($urandom_range(5, 35));  // Random delay between 5-35ns
            async_signal = ~async_signal;
        end
        
        // Test Case 3: Rapid async signal changes
        $display("Test 3: Rapid async signal toggles");
        repeat (20) begin
            #3 async_signal = ~async_signal;  // Toggle every 3ns
        end
        
        // Test Case 4: Async signal setup/hold violations
        $display("Test 4: Setup/hold time violations");
        repeat (8) begin
            @(posedge clk);
            #1 async_signal = ~async_signal;   // Change 1ns after clock edge
            #17 async_signal = ~async_signal;  // Change 2ns before next clock edge (18ns later)
        end
        
        // Wait for synchronizers to settle
        repeat (5) @(posedge clk);
        
        $display();
        $display("Synchronizer Latency Analysis:");
        $display("  2-stage: 2 clock cycles minimum latency");
        $display("  3-stage: 3 clock cycles minimum latency");
        $display("  Trade-off: More stages = higher MTBF but more latency");
        $display();
        
        $display("Metastability Synchronizer Test Complete!");
        $finish;
    end
    
    // Monitor synchronizer outputs
    always @(posedge clk) begin
        $display("Time: %0t | Async: %b | 2-stage: %b | 3-stage: %b | Simple: %b", 
                 $time, async_signal, sync_out_2stage, sync_out_3stage, sync_out_simple);
    end
    
    // Detect potential metastability (for educational purposes)
    logic potential_metastability;
    always_comb begin
        // This is a simplified detection - real metastability is much more complex
        potential_metastability = (async_signal !== sync_out_2stage) && 
                                 (sync_out_2stage !== sync_out_3stage);
    end
    
    // Report metastability detection
    always @(posedge clk) begin
        if (potential_metastability) begin
            $display("  --> Potential metastability detected at time %0t", $time);
        end
    end
    
    // Final statistics
    integer async_transitions = 0;
    integer sync_delays_2stage = 0;
    integer sync_delays_3stage = 0;
    
    always @(async_signal) async_transitions++;
    
    final begin
        $display();
        $display("Test Statistics:");
        $display("  Async signal transitions: %0d", async_transitions);
        $display("  Synchronizer protects against metastability by:");
        $display("    - Providing setup/hold time for async signals");
        $display("    - Reducing MTBF (Mean Time Between Failures)");
        $display("    - Trading latency for reliability");
    end

endmodule