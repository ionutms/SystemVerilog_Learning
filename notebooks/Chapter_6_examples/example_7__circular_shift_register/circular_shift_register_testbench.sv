// circular_shift_register_testbench.sv
// Simple testbench for circular shift register

module shift_register_testbench;

    // Test signals
    logic clk = 0;
    logic reset;
    logic load;
    logic [3:0] data;
    logic [3:0] q;

    // Clock generation - 10ns period
    always #5 clk = ~clk;

    // Instantiate the circular shift register
    circular_shift_register DUT (
        .clk(clk),
        .reset(reset),
        .load(load),
        .data(data),
        .q(q)
    );

    initial begin
        // Setup waveform dumping
        $dumpfile("shift_register_testbench.vcd");
        $dumpvars(0, shift_register_testbench);
        
        $display("=== Circular Shift Register Test ===");
        $display("Demonstrating 4-bit circular shift with feedback");
        $display();
        
        // Initialize signals
        reset = 1;
        load = 0;
        data = 4'b0000;
        
        // Wait a few clocks then release reset
        repeat(2) @(posedge clk);
        reset = 0;
        $display("Reset released");
        
        // Test 1: Load pattern 1001 and watch it shift
        $display("\nTest 1: Loading pattern 1001");
        @(posedge clk);
        load = 1;
        data = 4'b1001;
        @(posedge clk);
        load = 0;
        $display("Loaded: %b", q);
        
        // Watch it shift for 8 clock cycles (should return to original after 4)
        $display("\nShifting pattern (should repeat every 4 clocks):");
        for (int i = 0; i < 8; i++) begin
            @(posedge clk);
            $display("Clock %0d: %b", i+1, q);
        end
        
        // Test 2: Load different pattern 0110
        $display("\nTest 2: Loading pattern 0110");
        @(posedge clk);
        load = 1;
        data = 4'b0110;
        @(posedge clk);
        load = 0;
        $display("Loaded: %b", q);
        
        // Watch this pattern shift
        $display("\nShifting new pattern:");
        for (int i = 0; i < 6; i++) begin
            @(posedge clk);
            $display("Clock %0d: %b", i+1, q);
        end
        
        // Test 3: Single bit pattern to clearly show circular nature
        $display("\nTest 3: Single bit pattern 0001 (clearly shows circulation)");
        @(posedge clk);
        load = 1;
        data = 4'b0001;
        @(posedge clk);
        load = 0;
        $display("Loaded: %b", q);
        
        $display("\nWatching single bit circulate:");
        for (int i = 0; i < 8; i++) begin
            @(posedge clk);
            $display("Clock %0d: %b <- Bit position: %0d", i+1, q, 
                    (q == 4'b0010) ? 1 : 
                    (q == 4'b0100) ? 2 : 
                    (q == 4'b1000) ? 3 : 
                    (q == 4'b0001) ? 0 : -1);
        end
        
        $display("\n=== Test Complete ===");
        $display("Notice how the patterns repeat every 4 clock cycles");
        $display("This demonstrates the circular feedback from MSB to LSB");
        
        $finish;
    end

    // Monitor changes
    always @(q) begin
        if (!reset) begin
            $display("  Register changed to: %b (decimal: %0d)", q, q);
        end
    end

endmodule