// configurable_memory_testbench.sv
module configurable_memory_testbench;

    // Testbench parameters
    localparam int CLK_PERIOD = 10;
    localparam int TEST_DATA_WIDTH = 16;
    localparam int TEST_ADDR_WIDTH = 4;  // Small memory for easy testing
    
    // Custom types for testing
    typedef logic [TEST_DATA_WIDTH-1:0] data_t;
    typedef logic [TEST_ADDR_WIDTH-1:0] addr_t;
    typedef logic [1:0] ctrl_t;
    
    // Testbench signals
    logic clk;
    logic reset_n;
    logic enable;
    logic write_enable;
    addr_t address;
    data_t write_data;
    ctrl_t byte_enables;
    data_t read_data;
    logic ready;
    logic error;
    logic [31:0] access_count;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // DUT 1: Basic memory with custom types
    configurable_memory #(
        // Type parameters
        .DATA_TYPE(data_t),
        .ADDR_TYPE(addr_t),
        .CTRL_TYPE(ctrl_t),
        // Value parameters
        .DATA_WIDTH(TEST_DATA_WIDTH),
        .ADDR_WIDTH(TEST_ADDR_WIDTH),
        .INIT_VALUE(32'hAAAA),  // Use 32-bit value to match parameter width
        .ACCESS_DELAY(2),
        .ENABLE_ECC(1'b1),
        .BYTE_ENABLE(1'b1),
        // String parameters
        .MEMORY_TYPE("BLOCK"),
        .INIT_FILE(""),
        .WRITE_MODE("READ_FIRST"),
        // Real parameters
        .SETUP_TIME(1.5),
        .HOLD_TIME(0.8),
        .ACCESS_TIME(3.2),
        .POWER_FACTOR(1.2)
    ) dut1 (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .write_enable(write_enable),
        .address(address),
        .write_data(write_data),
        .byte_enables(byte_enables),
        .read_data(read_data),
        .ready(ready),
        .error(error),
        .access_count(access_count)
    );
    
    // DUT 2: Different configuration for comparison
    logic [7:0] read_data2;
    logic ready2, error2;
    logic [31:0] access_count2;
    
    configurable_memory #(
        // Different type parameters
        .DATA_TYPE(logic [7:0]),
        .ADDR_TYPE(logic [3:0]),
        .CTRL_TYPE(logic),
        // Different value parameters
        .DATA_WIDTH(8),
        .ADDR_WIDTH(4),
        .INIT_VALUE(32'h55),  // Use 32-bit value to match parameter width
        .ACCESS_DELAY(1),
        .ENABLE_ECC(1'b0),
        .BYTE_ENABLE(1'b0),
        // Different string parameters
        .MEMORY_TYPE("DISTRIBUTED"),
        .INIT_FILE(""),
        .WRITE_MODE("WRITE_FIRST"),
        // Different real parameters
        .SETUP_TIME(2.0),
        .HOLD_TIME(1.2),
        .ACCESS_TIME(4.5),
        .POWER_FACTOR(0.8)
    ) dut2 (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .write_enable(write_enable),
        .address(address[3:0]),
        .write_data(write_data[7:0]),
        .byte_enables(1'b1),
        .read_data(read_data2),
        .ready(ready2),
        .error(error2),
        .access_count(access_count2)
    );
    
    // DUT 3: Ultra-fast memory with no delay
    logic [31:0] read_data3;
    logic ready3, error3;
    logic [31:0] access_count3;
    
    configurable_memory #(
        // Standard 32-bit types
        .DATA_TYPE(logic [31:0]),
        .ADDR_TYPE(logic [2:0]),
        .CTRL_TYPE(logic [3:0]),
        // Value parameters
        .DATA_WIDTH(32),
        .ADDR_WIDTH(3),
        .INIT_VALUE(32'h12345678),
        .ACCESS_DELAY(0),  // No delay
        .ENABLE_ECC(1'b0),
        .BYTE_ENABLE(1'b1),
        // String parameters
        .MEMORY_TYPE("ULTRA"),
        .INIT_FILE(""),
        .WRITE_MODE("NO_CHANGE"),
        // Real parameters
        .SETUP_TIME(0.5),
        .HOLD_TIME(0.3),
        .ACCESS_TIME(1.0),
        .POWER_FACTOR(2.0)
    ) dut3 (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .write_enable(write_enable),
        .address(address[2:0]),
        .write_data({write_data, write_data}), // Duplicate to make 32-bit
        .byte_enables(4'hF),
        .read_data(read_data3),
        .ready(ready3),
        .error(error3),
        .access_count(access_count3)
    );
    
    // Test stimulus
    initial begin
        // Initialize VCD dump
        $dumpfile("configurable_memory_testbench.vcd");
        $dumpvars(0, configurable_memory_testbench);
        
        $display("\n=== Configurable Memory Testbench Started ===");
        
        // Initialize signals
        reset_n = 0;
        enable = 0;
        write_enable = 0;
        address = '0;
        write_data = '0;
        byte_enables = '1;
        
        // Reset phase
        $display("\n--- Phase 1: Reset and Initialization ---");
        #(CLK_PERIOD * 3);
        reset_n = 1;
        #(CLK_PERIOD);
        
        $display("After reset:");
        $display("  DUT1 (16-bit): ready=%b, access_count=%0d", ready, access_count);
        $display("  DUT2 (8-bit):  ready=%b, access_count=%0d", ready2, access_count2);
        $display("  DUT3 (32-bit): ready=%b, access_count=%0d", ready3, access_count3);
        
        // Test initial read (should show initialization values)
        $display("\n--- Phase 2: Initial Read Test ---");
        enable = 1;
        address = 0;
        write_enable = 0;
        
        wait_for_ready();
        $display("Initial read from address 0:");
        $display("  DUT1: 0x%04h (expected: 0xAAAA)", read_data);
        $display("  DUT2: 0x%02h (expected: 0x55)", read_data2);
        $display("  DUT3: 0x%08h (expected: 0x12345678)", read_data3);
        
        // Test write operations
        $display("\n--- Phase 3: Write Operation Test ---");
        for (int i = 0; i < 4; i++) begin
            address = addr_t'(i);
            write_data = data_t'(32'hBEEF + i);  // Use 32-bit constant to avoid width expansion
            write_enable = 1;
            
            #(CLK_PERIOD);
            wait_for_ready();
            
            $display("Write to addr %0d, data=0x%04h:", i, write_data);
            $display("  DUT1: ready=%b, error=%b", ready, error);
            $display("  DUT2: ready=%b, error=%b", ready2, error2);
            $display("  DUT3: ready=%b, error=%b", ready3, error3);
        end
        
        // Test read-back
        $display("\n--- Phase 4: Read-Back Test ---");
        write_enable = 0;
        
        for (int i = 0; i < 4; i++) begin
            address = addr_t'(i);
            #(CLK_PERIOD);
            wait_for_ready();
            
            $display("Read from addr %0d:", i);
            $display("  DUT1: 0x%04h", read_data);
            $display("  DUT2: 0x%02h", read_data2);
            $display("  DUT3: 0x%08h", read_data3);
        end
        
        // Test different write modes by comparing DUT1 (READ_FIRST) vs DUT2 (WRITE_FIRST)
        $display("\n--- Phase 5: Write Mode Comparison ---");
        address = 0;
        write_data = 16'hDEAD;
        
        // Simultaneous write to both memories
        write_enable = 1;
        #(CLK_PERIOD);
        
        $display("Write mode test (writing 0xDEAD to address 0):");
        $display("  DUT1 (READ_FIRST): read_data=0x%04h", read_data);
        $display("  DUT2 (WRITE_FIRST): read_data=0x%02h", read_data2);
        
        wait_for_ready();
        
        // Test access delay differences
        $display("\n--- Phase 6: Access Delay Test ---");
        write_enable = 0;
        address = 1;
        
        $display("Testing access delays:");
        $display("  DUT1: %0d cycles delay", 2);
        $display("  DUT2: %0d cycles delay", 1);
        $display("  DUT3: %0d cycles delay", 0);
        
        #(CLK_PERIOD);
        
        // Monitor ready signals over time
        for (int cycle = 0; cycle < 5; cycle++) begin
            $display("Cycle %0d: DUT1_ready=%b, DUT2_ready=%b, DUT3_ready=%b", 
                    cycle, ready, ready2, ready3);
            #(CLK_PERIOD);
        end
        
        // Test error conditions
        $display("\n--- Phase 7: Error Condition Test ---");
        address = addr_t'('1); // Maximum address (should be valid)
        write_enable = 1;
        write_data = 16'hE440;
        #(CLK_PERIOD);
        wait_for_ready();
        
        $display("Write to max address (%0d):", address);
        $display("  DUT1: error=%b", error);
        $display("  DUT2: error=%b", error2);
        $display("  DUT3: error=%b", error3);
        
        // Test ECC (DUT1 has ECC enabled)
        $display("\n--- Phase 8: ECC Test ---");
        write_enable = 0;
        address = 0;
        #(CLK_PERIOD);
        wait_for_ready();
        
        $display("ECC test (DUT1 has ECC enabled):");
        $display("  DUT1: error=%b (may show ECC error)", error);
        $display("  DUT2: error=%b (no ECC)", error2);
        
        // Final statistics
        $display("\n--- Final Statistics ---");
        enable = 0;
        #(CLK_PERIOD * 2);
        
        $display("Total access counts:");
        $display("  DUT1: %0d accesses", access_count);
        $display("  DUT2: %0d accesses", access_count2);
        $display("  DUT3: %0d accesses", access_count3);
        
        $display("\n=== Configurable Memory Testbench Completed ===");
        $display("Total simulation time: %0t", $time);
        $finish;
    end
    
    // Helper task to wait for all memories to be ready
    task wait_for_ready();
        while (!ready || !ready2 || !ready3) begin
            #(CLK_PERIOD);
        end
    endtask
    
    // Monitor for important events
    always @(posedge clk) begin
        if (reset_n && enable) begin
            if (error)
                $display("*** DUT1 ERROR at time %0t, addr=%0d ***", $time, address);
            if (error2)
                $display("*** DUT2 ERROR at time %0t, addr=%0d ***", $time, address);
            if (error3)
                $display("*** DUT3 ERROR at time %0t, addr=%0d ***", $time, address);
        end
    end

endmodule