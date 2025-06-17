// counter_4bit_testbench.sv
module counter_4bit_testbench;
    logic clk, rst_n, enable;
    logic [3:0] count;
    integer test_cycles;
    
    // Instantiate the 4-bit counter design under test
    counter_4bit dut_counter (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .count(count)
    );
    
    // Clock generation - 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Main test sequence
    initial begin
        // Setup waveform dumping
        $dumpfile("counter_4bit_testbench.vcd");
        $dumpvars(0, counter_4bit_testbench);
        
        // Initialize test signals
        rst_n = 0;
        enable = 0;
        test_cycles = 0;
        
        $display("=== 4-bit Counter Testbench Started ===");
        $display("Time: %0t", $time);
        $display();
        
        // Apply reset for 10ns
        #10 rst_n = 1;
        $display("Reset deasserted at time %0t", $time);
        
        // Enable counting after reset
        #10 enable = 1;
        $display("Counter enabled at time %0t", $time);
        $display();
        
        // Run test for 20 clock cycles
        while (test_cycles < 20) begin
            @(posedge clk);
            $display("Cycle %2d: count = %2d (0x%h) at time %0t", 
                     test_cycles, count, count, $time);
            test_cycles++;
            
            // Test disable functionality at cycle 10
            if (test_cycles == 10) begin
                enable = 0;
                $display(">>> Counter disabled at cycle %0d <<<", test_cycles);
            end
            
            // Re-enable at cycle 15
            if (test_cycles == 15) begin
                enable = 1;
                $display(">>> Counter re-enabled at cycle %0d <<<", test_cycles);
            end
        end
        
        $display();
        $display("=== Testbench Completed Successfully ===");
        $display("Final count value: %0d", count);
        $display("Total simulation time: %0t", $time);
        $finish;
    end
    
    // Overflow detection monitor
    always @(posedge clk) begin
        if (rst_n && enable && count == 4'b1111) begin
            $display("*** OVERFLOW WARNING: Counter reached maximum value (15) ***");
        end
    end
    
    // Value change monitor for debugging
    always @(count) begin
        if (rst_n) begin
            $display("Count changed to: %0d", count);
        end
    end

endmodule