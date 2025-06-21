// configurable_memory_testbench.sv
module configurable_memory_testbench;

    // Testbench signals
    logic clk;
    logic reset_n;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period = 100MHz
    end
    
    // === Instance 1: Small 8-bit memory ===
    logic small_we;
    logic [3:0] small_addr;
    bit [7:0] small_wdata, small_rdata;
    
    configurable_memory #(
        .MEMORY_DEPTH(16),
        .DATA_TYPE(bit [7:0]),
        .MEMORY_NAME("SMALL_8BIT_MEM"),
        .ACCESS_DELAY_NS(1.0)
    ) small_memory (
        .clk(clk),
        .reset_n(reset_n),
        .write_enable(small_we),
        .address(small_addr),
        .write_data(small_wdata),
        .read_data(small_rdata)
    );
    
    // === Instance 2: Large 16-bit memory ===
    logic large_we;
    logic [9:0] large_addr;
    bit [15:0] large_wdata, large_rdata;
    
    configurable_memory #(
        .MEMORY_DEPTH(1024),
        .DATA_TYPE(bit [15:0]),
        .MEMORY_NAME("LARGE_16BIT_MEM"),
        .ACCESS_DELAY_NS(3.5)
    ) large_memory (
        .clk(clk),
        .reset_n(reset_n),
        .write_enable(large_we),
        .address(large_addr),
        .write_data(large_wdata),
        .read_data(large_rdata)
    );
    
    // === Instance 3: Custom 32-bit memory ===
    logic custom_we;
    logic [7:0] custom_addr;
    bit [31:0] custom_wdata, custom_rdata;
    
    configurable_memory #(
        .MEMORY_DEPTH(256),
        .DATA_TYPE(bit [31:0]),
        .MEMORY_NAME("CUSTOM_32BIT_CACHE"),
        .ACCESS_DELAY_NS(0.8)
    ) custom_memory (
        .clk(clk),
        .reset_n(reset_n),
        .write_enable(custom_we),
        .address(custom_addr),
        .write_data(custom_wdata),
        .read_data(custom_rdata)
    );

    initial begin
        // Dump waves
        $dumpfile("configurable_memory_testbench.vcd");
        $dumpvars(0, configurable_memory_testbench);
        
        $display("\n=== Starting Configurable Memory Test ===");
        
        // Initialize ALL signals
        reset_n = 0;
        small_we = 0; large_we = 0; custom_we = 0;
        small_addr = 0; small_wdata = 0;
        large_addr = 0; large_wdata = 0;
        custom_addr = 0; custom_wdata = 0;
        
        // Reset sequence
        #20 reset_n = 1;
        #10;
        
        // Test small memory - Write and Read Back
        $display("\n--- Testing Small 8-bit Memory ---");
        small_we = 1;
        small_addr = 4'h5;
        small_wdata = 8'hAB;
        #10;
        
        small_we = 0;
        #10;
        $display("Small Memory Read: Addr=0x%h, Data=0x%h", 
                 small_addr, small_rdata);
        
        // Write multiple locations
        small_we = 1;
        small_addr = 4'h2; small_wdata = 8'h11; #10;
        small_addr = 4'h7; small_wdata = 8'h22; #10;
        small_addr = 4'hF; small_wdata = 8'hFF; #10;
        
        // Read back all locations
        small_we = 0;
        small_addr = 4'h2; #10;
        $display("Small Memory Read: Addr=0x%h, Data=0x%h", 
                 small_addr, small_rdata);
        small_addr = 4'h5; #10;
        $display("Small Memory Read: Addr=0x%h, Data=0x%h", 
                 small_addr, small_rdata);
        small_addr = 4'h7; #10;
        $display("Small Memory Read: Addr=0x%h, Data=0x%h", 
                 small_addr, small_rdata);
        small_addr = 4'hF; #10;
        $display("Small Memory Read: Addr=0x%h, Data=0x%h", 
                 small_addr, small_rdata);
        
        // Test large memory - Write and Read Back
        $display("\n--- Testing Large 16-bit Memory ---");
        large_we = 1;
        large_addr = 10'h123;
        large_wdata = 16'hDEAD;
        #10;
        
        large_we = 0;
        #10;
        $display("Large Memory Read: Addr=0x%h, Data=0x%h", 
                 large_addr, large_rdata);
        
        // Write pattern to multiple locations
        large_we = 1;
        large_addr = 10'h000; large_wdata = 16'h1234; #10;
        large_addr = 10'h100; large_wdata = 16'h5678; #10;
        large_addr = 10'h200; large_wdata = 16'h9ABC; #10;
        large_addr = 10'h3FF; large_wdata = 16'hBEEF; #10;
        
        // Read back pattern
        large_we = 0;
        large_addr = 10'h000; #10;
        $display("Large Memory Read: Addr=0x%h, Data=0x%h", 
                 large_addr, large_rdata);
        large_addr = 10'h100; #10;
        $display("Large Memory Read: Addr=0x%h, Data=0x%h", 
                 large_addr, large_rdata);
        large_addr = 10'h123; #10;
        $display("Large Memory Read: Addr=0x%h, Data=0x%h", 
                 large_addr, large_rdata);
        large_addr = 10'h200; #10;
        $display("Large Memory Read: Addr=0x%h, Data=0x%h", 
                 large_addr, large_rdata);
        large_addr = 10'h3FF; #10;
        $display("Large Memory Read: Addr=0x%h, Data=0x%h", 
                 large_addr, large_rdata);
        
        // Test custom memory - Write and Read Back
        $display("\n--- Testing Custom 32-bit Memory ---");
        custom_we = 1;
        custom_addr = 8'h42;
        custom_wdata = 32'hCAFEBABE;
        #10;
        
        custom_we = 0;
        #10;
        $display("Custom Memory Read: Addr=0x%h, Data=0x%h", 
                 custom_addr, custom_rdata);
        
        // Write test pattern
        custom_we = 1;
        custom_addr = 8'h00; custom_wdata = 32'h12345678; #10;
        custom_addr = 8'h10; custom_wdata = 32'h87654321; #10;
        custom_addr = 8'h80; custom_wdata = 32'hA5A5A5A5; #10;
        custom_addr = 8'hFF; custom_wdata = 32'h5A5A5A5A; #10;
        
        // Read back test pattern
        custom_we = 0;
        custom_addr = 8'h00; #10;
        $display("Custom Memory Read: Addr=0x%h, Data=0x%h", 
                 custom_addr, custom_rdata);
        custom_addr = 8'h10; #10;
        $display("Custom Memory Read: Addr=0x%h, Data=0x%h", 
                 custom_addr, custom_rdata);
        custom_addr = 8'h42; #10;
        $display("Custom Memory Read: Addr=0x%h, Data=0x%h", 
                 custom_addr, custom_rdata);
        custom_addr = 8'h80; #10;
        $display("Custom Memory Read: Addr=0x%h, Data=0x%h", 
                 custom_addr, custom_rdata);
        custom_addr = 8'hFF; #10;
        $display("Custom Memory Read: Addr=0x%h, Data=0x%h", 
                 custom_addr, custom_rdata);
        
        // Memory integrity test - verify data persistence
        $display("\n--- Memory Integrity Test ---");
        custom_addr = 8'h42; #10;
        if (custom_rdata == 32'hCAFEBABE)
            $display("Memory integrity PASSED - Original data preserved");
        else
            $display("Memory integrity FAILED - Expected 0xCAFEBABE, " +
                    "got 0x%h", custom_rdata);
        
        // Cross-memory integrity test
        $display("\n--- Cross-Memory Integrity Test ---");
        small_addr = 4'h5; #10;
        if (small_rdata == 8'hAB)
            $display("Small memory integrity PASSED");
        else
            $display("Small memory integrity FAILED - Expected 0xAB, " +
                    "got 0x%h", small_rdata);
            
        large_addr = 10'h123; #10;
        if (large_rdata == 16'hDEAD)
            $display("Large memory integrity PASSED");
        else
            $display("Large memory integrity FAILED - Expected 0xDEAD, " +
                    "got 0x%h", large_rdata);
        
        // Test parameter effects and memory utilization
        $display("\n--- Parameter Summary & Memory Utilization ---");
        $display("Small Memory: %0d x %0d bits (Total: %0d bits)", 
                 16, 8, 16*8);
        $display("Large Memory: %0d x %0d bits (Total: %0d bits)", 
                 1024, 16, 1024*16);
        $display("Custom Memory: %0d x %0d bits (Total: %0d bits)", 
                 256, 32, 256*32);
        
        // Test write/read performance with different delays
        $display("\n--- Access Delay Comparison ---");
        $display("Small Memory Delay: 1.0 ns");
        $display("Large Memory Delay: 3.5 ns"); 
        $display("Custom Memory Delay: 0.8 ns");
        
        #50;
        $display();
        $display("=== Configurable Memory Test Complete ===");
        $display();
        $finish;
    end

endmodule