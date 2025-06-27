// reset_synchronizer_testbench.sv
module reset_sync_testbench;

    // Testbench signals
    logic system_clock;
    logic master_reset_n;
    logic clean_reset_n;
    
    // Instantiate the reset synchronizer
    reset_synchronizer RESET_SYNC_UNIT (
        .clock_domain(system_clock),
        .async_reset_in(master_reset_n),
        .sync_reset_out(clean_reset_n)
    );
    
    // Clock generation (100MHz - 10ns period)
    initial begin
        system_clock = 0;
        forever #5 system_clock = ~system_clock;
    end
    
    // Test sequence
    initial begin
        // Setup waveform dumping
        $dumpfile("reset_sync_testbench.vcd");
        $dumpvars(0, reset_sync_testbench);
        
        $display("\n=== Reset Synchronizer Test ===");
        
        // Start with reset asserted
        master_reset_n = 1'b0;
        $display("Time %0t: Asserting async reset", $time);
        
        // Hold reset for several clock cycles
        repeat(3) @(posedge system_clock);
        
        // Release reset and observe synchronization
        $display("Time %0t: Releasing async reset", $time);
        master_reset_n = 1'b1;
        
        // Wait and observe synchronized reset release
        repeat(5) @(posedge system_clock) begin
            $display("Time %0t: master_reset_n=%b, clean_reset_n=%b", 
                     $time, master_reset_n, clean_reset_n);
        end
        
        // Test another reset cycle
        $display("\nTime %0t: Second reset cycle", $time);
        master_reset_n = 1'b0;
        repeat(2) @(posedge system_clock);
        master_reset_n = 1'b1;
        
        repeat(4) @(posedge system_clock) begin
            $display("Time %0t: master_reset_n=%b, clean_reset_n=%b", 
                     $time, master_reset_n, clean_reset_n);
        end
        
        $display("\n=== Reset Synchronizer Test Complete ===");
        $finish;
    end

endmodule