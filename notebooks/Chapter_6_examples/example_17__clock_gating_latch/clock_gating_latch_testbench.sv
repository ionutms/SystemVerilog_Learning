// clock_gating_latch_testbench.sv
module clock_gating_testbench;

    // Testbench signals
    logic clk;
    logic enable;
    logic test_mode;
    logic gated_clk;
    
    // Instantiate the clock gating latch
    clock_gating_latch CLOCK_GATE_INSTANCE (
        .clk(clk),
        .enable(enable),
        .test_mode(test_mode),
        .gated_clk(gated_clk)
    );
    
    // Clock generation - 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test sequence
    initial begin
        // Dump waves for analysis
        $dumpfile("clock_gating_testbench.vcd");
        $dumpvars(0, clock_gating_testbench);
        
        // Initialize signals
        enable = 0;
        test_mode = 0;
        
        $display("\n=== Clock Gating Latch Test ===");
        
        // Test 1: Clock gating disabled (enable = 0)
        $display("\nTest 1: Clock gating - enable = 0");
        #20;
        $display("Time %0t: clk=%b, enable=%b, gated_clk=%b", $time, clk, enable, gated_clk);
        
        // Test 2: Enable clock gating (enable = 1)
        $display("\nTest 2: Clock gating - enable = 1");
        @(negedge clk);  // Change enable during clock low (safe)
        enable = 1;
        #30;
        $display("Time %0t: clk=%b, enable=%b, gated_clk=%b", $time, clk, enable, gated_clk);
        
        // Test 3: Disable clock gating again
        $display("\nTest 3: Clock gating - enable = 0 again");
        @(negedge clk);  // Change enable during clock low (safe)
        enable = 0;
        #20;
        $display("Time %0t: clk=%b, enable=%b, gated_clk=%b", $time, clk, enable, gated_clk);
        
        // Test 4: Test mode bypass
        $display("\nTest 4: Test mode bypass - test_mode = 1");
        @(negedge clk);
        test_mode = 1;
        #20;
        $display("Time %0t: clk=%b, enable=%b, test_mode=%b, gated_clk=%b", 
                 $time, clk, enable, test_mode, gated_clk);
        
        // Test 5: Demonstrate DANGEROUS behavior - changing enable during clock high
        $display("\nTest 5: enable during clock HIGH period");
        @(negedge clk);
        test_mode = 0;
        enable = 1;
        #7;  // Wait until middle of clock high period
        if (clk) begin
            $display("WARNING: Changing enable during clock HIGH - can cause glitches!");
            enable = 0;  // This is dangerous and can cause glitches
            #1;
            $display("Time %0t: clk=%b, enable=%b, gated_clk=%b (POTENTIAL GLITCH)", 
                     $time, clk, enable, gated_clk);
        end
        
        #30;
        
        $display("\n=== Test Complete ===");
        $display("Check VCD file for detailed timing analysis");
        $display("Notice how gated_clk follows the enable signal properly");
        $display("when enable changes during clock LOW period (safe)");
        $finish;
    end
    
    // Monitor for educational purposes
    always @(posedge gated_clk) begin
        $display("Time %0t: Gated clock rising edge detected", $time);
    end

endmodule