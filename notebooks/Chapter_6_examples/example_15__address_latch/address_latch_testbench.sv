// address_latch_testbench.sv
module address_latch_testbench;

    // Clock and reset
    logic clk;
    logic rst_n;
    
    // Input signals
    logic [15:0] addr_in;
    logic        addr_valid;
    logic        mem_cycle_start;
    logic        mem_cycle_end;
    
    // Output signals
    logic [15:0] addr_out;
    logic        addr_latched;
    
    // Instantiate the address latch
    address_latch ADDRESS_LATCH_INST (
        .clk(clk),
        .rst_n(rst_n),
        .addr_in(addr_in),
        .addr_valid(addr_valid),
        .mem_cycle_start(mem_cycle_start),
        .mem_cycle_end(mem_cycle_end),
        .addr_out(addr_out),
        .addr_latched(addr_latched)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end
    
    // Test sequence
    initial begin
        // Initialize signals
        rst_n = 0;
        addr_in = 16'h0000;
        addr_valid = 0;
        mem_cycle_start = 0;
        mem_cycle_end = 0;
        
        // Dump waves
        $dumpfile("address_latch_testbench.vcd");
        $dumpvars(0, address_latch_testbench);
        
        $display();
        $display("=== Address Latch Test ===");
        $display();
        
        // Release reset
        #20 rst_n = 1;
        #10;
        
        // Test 1: Basic transparent operation
        $display("Test 1: Transparent latch operation");
        addr_in = 16'hA000;
        addr_valid = 1;
        #10;
        $display("Input: 0x%04h, Output: 0x%04h, Latched: %b", addr_in, addr_out, addr_latched);
        
        // Change address while transparent
        addr_in = 16'hB000;
        #10;
        $display("Input: 0x%04h, Output: 0x%04h, Latched: %b", addr_in, addr_out, addr_latched);
        #10;
        
        // Test 2: Start memory cycle (latch should hold address)
        $display("Test 2: Memory cycle - address should be latched");
        mem_cycle_start = 1;
        #10;
        mem_cycle_start = 0;
        $display("Memory cycle started - Input: 0x%04h, Output: 0x%04h, Latched: %b", 
                 addr_in, addr_out, addr_latched);
        
        // Try changing input address during memory cycle
        addr_in = 16'hC000;
        #10;
        $display("Changed input during cycle - Input: 0x%04h, Output: 0x%04h, Latched: %b", 
                 addr_in, addr_out, addr_latched);
        
        addr_in = 16'hD000;
        #10;
        $display("Changed input again - Input: 0x%04h, Output: 0x%04h, Latched: %b", 
                 addr_in, addr_out, addr_latched);
        
        // End memory cycle
        mem_cycle_end = 1;
        #10;
        mem_cycle_end = 0;
        $display("Memory cycle ended - Input: 0x%04h, Output: 0x%04h, Latched: %b", 
                 addr_in, addr_out, addr_latched);
        #10;
        
        // Test 3: Address invalid during transparent mode
        $display("Test 3: Address invalid - latch should not change");
        addr_valid = 0;
        addr_in = 16'hE000;
        #10;
        $display("Address invalid - Input: 0x%04h, Output: 0x%04h, Latched: %b", 
                 addr_in, addr_out, addr_latched);
        
        // Make address valid again
        addr_valid = 1;
        #10;
        $display("Address valid again - Input: 0x%04h, Output: 0x%04h, Latched: %b", 
                 addr_in, addr_out, addr_latched);
        #10;
        
        // Test 4: Multiple memory cycles
        $display("Test 4: Multiple memory access cycles");
        for (int i = 0; i < 3; i++) begin
            // Set new address
            addr_in = 16'h1000 + 16'(i * 16'h100);
            #10;
            $display("Cycle %0d: Set address 0x%04h", i+1, addr_in);
            
            // Start memory cycle
            mem_cycle_start = 1;
            #10;
            mem_cycle_start = 0;
            $display("  Memory cycle started - Output: 0x%04h, Latched: %b", addr_out, addr_latched);
            
            // Simulate memory access time
            #30;
            
            // End memory cycle
            mem_cycle_end = 1;
            #10;
            mem_cycle_end = 0;
            $display("  Memory cycle ended - Output: 0x%04h, Latched: %b", addr_out, addr_latched);
            #10;
        end
        
        // Test 5: Address changes during non-valid periods
        $display("Test 5: Address changes when addr_valid is low");
        addr_valid = 0;
        for (int i = 0; i < 3; i++) begin
            addr_in = 16'hF000 + 16'(i * 16'h10);
            #10;
            $display("Invalid addr change %0d: Input: 0x%04h, Output: 0x%04h", 
                     i+1, addr_in, addr_out);
        end
        
        // Make valid and check final value
        addr_valid = 1;
        #10;
        $display("Made valid: Input: 0x%04h, Output: 0x%04h", addr_in, addr_out);
        
        $display();
        $display("=== All tests completed ===");
        $display();
        
        #50 $finish;
    end
    
    // Monitor for debugging
    always @(addr_out) begin
        if ($time > 0) begin
            $display("Time %0t: Address output changed to 0x%04h", $time, addr_out);
        end
    end

endmodule