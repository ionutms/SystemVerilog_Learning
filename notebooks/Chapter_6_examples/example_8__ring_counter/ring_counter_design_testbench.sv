// ring_counter_design_testbench.sv
module ring_counter_testbench;
    
    // Testbench signals
    logic clock;
    logic reset_n;
    logic enable;
    logic [3:0] ring_output;
    
    // Instantiate the ring counter design
    ring_counter_4bit RING_COUNTER_INSTANCE (
        .clock(clock),
        .reset_n(reset_n),
        .enable(enable),
        .ring_output(ring_output)
    );
    
    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end
    
    // Test sequence
    initial begin
        // Setup waveform dumping
        $dumpfile("ring_counter_testbench.vcd");
        $dumpvars(0, ring_counter_testbench);
        
        // Display header
        $display();
        $display("=== 4-Bit Ring Counter Test ===");
        $display("Time | Reset | Enable | Output");
        $display("---------------------------------");
        
        // Initialize signals
        reset_n = 0;
        enable = 0;
        
        // Apply reset
        #10;
        reset_n = 1;
        $display(" %3t |   %b   |    %b   | %b", $time, reset_n, enable, ring_output);
        
        // Enable the ring counter and observe the circular shift
        #5;
        enable = 1;
        
        // Run for several clock cycles to see the ring pattern
        repeat(12) begin
            #10;
            $display(" %3t |   %b   |    %b   | %b", $time, reset_n, enable, ring_output);
        end
        
        // Test disable functionality
        $display();
        $display("Testing disable...");
        enable = 0;
        #20;
        $display(" %3t |   %b   |    %b   | %b (disabled)", $time, reset_n, enable, ring_output);
        
        // Re-enable
        enable = 1;
        #20;
        $display(" %3t |   %b   |    %b   | %b (re-enabled)", $time, reset_n, enable, ring_output);
        
        // Test reset during operation
        $display();
        $display("Testing reset during operation...");
        #10;
        reset_n = 0;
        #10;
        reset_n = 1;
        $display(" %3t |   %b   |    %b   | %b (after reset)", $time, reset_n, enable, ring_output);
        
        $display();
        $display("=== Ring Counter Test Complete ===");
        $display();
        
        #20;
        $finish;
    end

endmodule