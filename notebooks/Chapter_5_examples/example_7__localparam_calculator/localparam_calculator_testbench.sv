// localparam_calculator_testbench.sv
module localparam_calculator_testbench;

    // Clock and control
    logic clk;
    logic reset_n;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz
    end
    
    // === FIXED-POINT MULTIPLIER TEST ===
    
    // Multiplier signals
    logic [15:0] mult_a, mult_b, mult_result;
    logic mult_start, mult_valid;
    
    // Test different clock frequencies to see pipeline changes
    fixed_point_mult #(
        .DATA_WIDTH(16),
        .FRAC_BITS(8),
        .CLK_FREQ_MHZ(50.0)  // Low freq = 1 pipeline stage
    ) mult_slow (
        .clk(clk),
        .reset_n(reset_n),
        .a(mult_a),
        .b(mult_b),
        .start(mult_start),
        .result(mult_result),
        .valid(mult_valid)
    );
    
    logic [15:0] mult_result_fast;
    logic mult_valid_fast;
    
    fixed_point_mult #(
        .DATA_WIDTH(16),
        .FRAC_BITS(8),
        .CLK_FREQ_MHZ(150.0)  // Medium freq = 2 pipeline stages
    ) mult_fast (
        .clk(clk),
        .reset_n(reset_n),
        .a(mult_a),
        .b(mult_b),
        .start(mult_start),
        .result(mult_result_fast),
        .valid(mult_valid_fast)
    );
    
    // === FIFO TEST ===
    
    // FIFO signals  
    logic fifo_push, fifo_pop;
    logic [7:0] fifo_data_in, fifo_data_out;
    logic fifo_full, fifo_empty, fifo_almost_full, fifo_almost_empty;
    
    // Test FIFO with different depths
    param_fifo #(
        .DATA_WIDTH(8),
        .MIN_DEPTH(10)  // Will become 16 (next power of 2)
    ) test_fifo (
        .clk(clk),
        .reset_n(reset_n),
        .push(fifo_push),
        .pop(fifo_pop),
        .data_in(fifo_data_in),
        .data_out(fifo_data_out),
        .full(fifo_full),
        .empty(fifo_empty),
        .almost_full(fifo_almost_full),
        .almost_empty(fifo_almost_empty)
    );
    
    // Test sequence
    initial begin
        $dumpfile("localparam_calculator_testbench.vcd");
        $dumpvars(0, localparam_calculator_testbench);
        
        $display("\n=== Localparam Calculator Testbench ===");
        $display("Demonstrating localparam for derived values\n");
        
        // Initialize
        reset_n = 0;
        mult_start = 0;
        mult_a = 0;
        mult_b = 0;
        fifo_push = 0;
        fifo_pop = 0;
        fifo_data_in = 0;
        
        #30;
        reset_n = 1;
        #20;
        
        // Test fixed-point multiplication
        $display("--- Fixed-Point Multiplier Test ---");
        $display("Testing 16-bit fixed point with 8 fractional bits");
        $display("Format: IIIIIIII.FFFFFFFF (8.8 fixed point)");
        
        // Test: 3.5 * 2.25 = 7.875
        mult_a = 16'h0380; // 3.5 in 8.8 format (3*256 + 0.5*256 = 896)
        mult_b = 16'h0240; // 2.25 in 8.8 format (2*256 + 0.25*256 = 576)
        mult_start = 1;
        
        $display("Test 1: 3.5 * 2.25 = 7.875");
        $display("  a = 0x%04h (%.3f)", mult_a, real'(mult_a)/256.0);
        $display("  b = 0x%04h (%.3f)", mult_b, real'(mult_b)/256.0);
        
        @(posedge clk);
        mult_start = 0;
        
        // Wait for results (different pipeline depths)
        repeat(5) @(posedge clk); // Wait a few cycles instead of wait()
        $display("  Slow multiplier result = 0x%04h (%.3f) valid=%b", 
                mult_result, real'(mult_result)/256.0, mult_valid);
        $display("  Fast multiplier result = 0x%04h (%.3f) valid=%b", 
                mult_result_fast, real'(mult_result_fast)/256.0, mult_valid_fast);
        
        #10;
        
        // Test FIFO
        $display("\n--- FIFO Test ---");
        $display("Testing FIFO with derived depth parameters");
        
        // Fill FIFO (test only 8 entries to speed up)
        $display("Filling FIFO...");
        for (int i = 0; i < 8; i++) begin
            @(posedge clk);
            if (!fifo_full) begin
                fifo_push = 1;
                fifo_data_in = 8'(i + 10);
                $display("  Push: %2d, Status: Full=%b, AF=%b, AE=%b, Empty=%b", 
                        fifo_data_in, fifo_full, fifo_almost_full, 
                        fifo_almost_empty, fifo_empty);
            end else begin
                fifo_push = 0;
                $display("  FIFO Full!");
                break;
            end
        end
        
        fifo_push = 0;
        #10;
        
        // Empty FIFO (test only what we put in)
        $display("\nEmptying FIFO...");
        for (int i = 0; i < 8; i++) begin
            @(posedge clk);
            if (!fifo_empty) begin
                fifo_pop = 1;
                #1; // Small delay for output
                $display("  Pop: %2d, Status: Full=%b, AF=%b, AE=%b, Empty=%b", 
                        fifo_data_out, fifo_full, fifo_almost_full, 
                        fifo_almost_empty, fifo_empty);
            end else begin
                fifo_pop = 0;
                $display("  FIFO Empty!");
                break;
            end
        end
        
        fifo_pop = 0;
        
        $display("\n--- Summary ---");
        $display("This example demonstrated localparam usage for:");
        $display("1. Mathematical derivations (bit widths, ranges, scaling)");
        $display("2. Timing-based calculations (pipeline stages, timeouts)");
        $display("3. Power-of-2 sizing (FIFO depth, address width)");
        $display("4. Threshold calculations (FIFO almost full/empty)");
        
        $display("\nKey localparam benefits:");
        $display("- Values computed at compile time");
        $display("- Cannot be overridden (unlike parameter)");
        $display("- Self-documenting derived relationships");
        $display("- Type-safe calculations");
        
        $display("\n=== Testbench Complete ===");
        $finish;
    end

endmodule