// simple_counter_testbench.sv
module simple_counter_testbench;

    // Testbench parameters
    localparam int CLK_PERIOD = 10; // 100MHz clock
    localparam int TEST_WIDTH = 4;   // 4-bit counter for easy testing
    localparam int TEST_MAX = 12;    // Max count less than 2^4-1 for testing
    
    // Testbench signals
    logic                    clk;
    logic                    reset_n;
    logic                    enable;
    logic                    load;
    logic [TEST_WIDTH-1:0]   load_value;
    logic                    count_up;
    logic [TEST_WIDTH-1:0]   count;
    logic                    overflow;
    logic                    underflow;
    logic                    max_reached;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // DUT instantiation with custom parameters
    simple_counter #(
        .WIDTH(TEST_WIDTH),
        .MAX_COUNT(TEST_MAX),
        .WRAP_AROUND(1'b1),
        .RESET_VALUE(0)
    ) dut (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .load(load),
        .load_value(load_value),
        .count_up(count_up),
        .count(count),
        .overflow(overflow),
        .underflow(underflow),
        .max_reached(max_reached)
    );
    
    // Second instance with different parameters for comparison
    logic [7:0] count2;
    logic overflow2, underflow2, max_reached2;
    
    simple_counter #(
        .WIDTH(8),
        .MAX_COUNT(255),
        .WRAP_AROUND(1'b0),     // No wrap-around (saturation mode)
        .RESET_VALUE(128)       // Different reset value
    ) dut2 (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .load(1'b0),            // Disable load for this instance
        .load_value(8'h00),
        .count_up(count_up),
        .count(count2),
        .overflow(overflow2),
        .underflow(underflow2),
        .max_reached(max_reached2)
    );
    
    // Test stimulus
    initial begin
        // Initialize VCD dump
        $dumpfile("simple_counter_testbench.vcd");
        $dumpvars(0, simple_counter_testbench);
        
        $display("=== Simple Counter Testbench Started ===");
        $display();
        
        // Initialize signals
        reset_n = 0;
        enable = 0;
        load = 0;
        load_value = 0;
        count_up = 1;
        
        // Reset phase
        $display("Phase 1: Reset Test");
        #(CLK_PERIOD * 2);
        reset_n = 1;
        #(CLK_PERIOD);
        $display("After reset - DUT1 count: %0d, DUT2 count: %0d", count, count2);
        $display();
        
        // Test counting up
        $display("Phase 2: Count Up Test");
        enable = 1;
        count_up = 1;
        
        repeat (TEST_MAX + 3) begin
            #(CLK_PERIOD);
            $display("Count up - DUT1: %0d (overflow=%b, max_reached=%b), DUT2: %0d (overflow=%b)", 
                    count, overflow, max_reached, count2, overflow2);
        end
        $display();
        
        // Test counting down
        $display("Phase 3: Count Down Test");
        count_up = 0;
        
        repeat (TEST_MAX + 3) begin
            #(CLK_PERIOD);
            $display("Count down - DUT1: %0d (underflow=%b), DUT2: %0d (underflow=%b)", 
                    count, underflow, count2, underflow2);
        end
        $display();
        
        // Test load operation
        $display("Phase 4: Load Operation Test");
        count_up = 1;
        load_value = TEST_WIDTH'(TEST_MAX / 2);  // Explicit width casting
        load = 1;
        #(CLK_PERIOD);
        $display("After load %0d - DUT1 count: %0d", load_value, count);
        load = 0;
        #(CLK_PERIOD);
        $display("After load release - DUT1 count: %0d", count);
        $display();
        
        // Test enable control
        $display("Phase 5: Enable Control Test");
        enable = 0;
        repeat (3) begin
            #(CLK_PERIOD);
            $display("Enable=0 - DUT1 count: %0d (should not change)", count);
        end
        
        enable = 1;
        repeat (3) begin
            #(CLK_PERIOD);
            $display("Enable=1 - DUT1 count: %0d (should increment)", count);
        end
        $display();
        
        // Test different parameter behavior
        $display("Phase 6: Parameter Comparison");
        $display("DUT1 (4-bit, wrap-around): count=%0d, max_count=%0d", count, TEST_MAX);
        $display("DUT2 (8-bit, saturation): count=%0d, max_count=255", count2);
        $display();
        
        // Final phase - reset test
        $display("Phase 7: Final Reset Test");
        reset_n = 0;
        #(CLK_PERIOD);
        reset_n = 1;
        #(CLK_PERIOD);
        $display("After final reset - DUT1: %0d, DUT2: %0d", count, count2);
        $display();
        
        $display("=== Simple Counter Testbench Completed ===");
        $display("Total simulation time: %0t", $time);
        $finish;
    end
    
    // Monitor for detecting important events
    always @(posedge clk) begin
        if (reset_n) begin
            if (overflow)
                $display("*** OVERFLOW detected at time %0t, count=%0d ***", $time, count);
            if (underflow)
                $display("*** UNDERFLOW detected at time %0t, count=%0d ***", $time, count);
            if (max_reached && enable)
                $display("*** MAX_REACHED at time %0t, count=%0d ***", $time, count);
        end
    end

endmodule