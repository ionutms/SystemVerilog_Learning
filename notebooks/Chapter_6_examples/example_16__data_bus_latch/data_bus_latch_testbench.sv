// data_bus_latch_testbench.sv
module data_bus_latch_testbench;

    // Clock and reset
    logic clk;
    logic rst_n;
    
    // Control signals
    logic latch_enable;
    logic cpu_to_bus_dir;
    logic bus_output_enable;
    
    // Data buses
    wire [7:0] cpu_data;
    wire [7:0] ext_bus_data;
    
    // Status signals
    logic latch_active;
    logic bus_isolated;
    
    // Test drivers
    logic [7:0] cpu_data_driver;
    logic [7:0] ext_bus_data_driver;
    logic       cpu_drive_enable;
    logic       ext_bus_drive_enable;
    
    // Drive the bidirectional buses
    assign cpu_data = cpu_drive_enable ? cpu_data_driver : 8'bz;
    assign ext_bus_data = ext_bus_drive_enable ? ext_bus_data_driver : 8'bz;
    
    // Instantiate the data bus latch
    data_bus_latch DATA_BUS_LATCH_INST (
        .clk(clk),
        .rst_n(rst_n),
        .latch_enable(latch_enable),
        .cpu_to_bus_dir(cpu_to_bus_dir),
        .bus_output_enable(bus_output_enable),
        .cpu_data(cpu_data),
        .ext_bus_data(ext_bus_data),
        .latch_active(latch_active),
        .bus_isolated(bus_isolated)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end
    
    // Helper task to display bus states
    task display_bus_state(string test_name);
        $display("%s - CPU: 0x%02h, ExtBus: 0x%02h, LatchActive: %b, Isolated: %b", 
                 test_name, cpu_data, ext_bus_data, latch_active, bus_isolated);
    endtask
    
    // Test sequence
    initial begin
        // Initialize signals
        rst_n = 0;
        latch_enable = 0;
        cpu_to_bus_dir = 0;
        bus_output_enable = 0;
        cpu_data_driver = 8'h00;
        ext_bus_data_driver = 8'h00;
        cpu_drive_enable = 0;
        ext_bus_drive_enable = 0;
        
        // Dump waves
        $dumpfile("data_bus_latch_testbench.vcd");
        $dumpvars(0, data_bus_latch_testbench);
        
        $display();
        $display("=== Data Bus Latch Test ===");
        $display();
        
        // Release reset
        #20 rst_n = 1;
        #10;
        
        // Test 1: CPU to Bus transfer
        $display("Test 1: CPU to Bus data transfer");
        cpu_data_driver = 8'hAA;
        cpu_drive_enable = 1;
        cpu_to_bus_dir = 1;  // CPU->Bus direction
        #10;
        display_bus_state("  Initial state");
        
        // Enable latch (should latch CPU data)
        latch_enable = 1;
        #10;
        display_bus_state("  Latch enabled");
        
        // Change CPU data (should not affect latched value)
        cpu_data_driver = 8'hFF;
        #10;
        display_bus_state("  CPU data changed");
        
        // Enable bus output (should drive external bus)
        bus_output_enable = 1;
        #10;
        display_bus_state("  Bus output enabled");
        
        // Disable CPU driver to see latch driving bus
        cpu_drive_enable = 0;
        #10;
        display_bus_state("  CPU driver disabled");
        
        // Cleanup
        bus_output_enable = 0;
        latch_enable = 0;
        #20;
        
        // Test 2: Bus to CPU transfer
        $display("Test 2: Bus to CPU data transfer");
        ext_bus_data_driver = 8'h55;
        ext_bus_drive_enable = 1;
        cpu_to_bus_dir = 0;  // Bus->CPU direction
        #10;
        display_bus_state("  Initial state");
        
        // Enable latch (should latch bus data)
        latch_enable = 1;
        #10;
        display_bus_state("  Latch enabled");
        
        // Change bus data (should not affect latched value)
        ext_bus_data_driver = 8'h33;
        #10;
        display_bus_state("  Bus data changed");
        
        // Enable bus output (should drive CPU bus)
        bus_output_enable = 1;
        #10;
        display_bus_state("  Bus output enabled");
        
        // Disable external bus driver to see latch driving CPU
        ext_bus_drive_enable = 0;
        #10;
        display_bus_state("  Ext bus driver disabled");
        
        // Cleanup
        bus_output_enable = 0;
        latch_enable = 0;
        #20;
        
        // Test 3: Bus isolation
        $display("Test 3: Bus isolation test");
        cpu_data_driver = 8'hCC;
        ext_bus_data_driver = 8'h99;
        cpu_drive_enable = 1;
        ext_bus_drive_enable = 1;
        #10;
        display_bus_state("  Both buses driven");
        
        // Enable latch but keep output disabled (isolation)
        latch_enable = 1;
        cpu_to_bus_dir = 1;
        #10;
        display_bus_state("  Latch enabled, output disabled");
        
        // Disable external drivers
        cpu_drive_enable = 0;
        ext_bus_drive_enable = 0;
        #10;
        display_bus_state("  All drivers disabled (isolated)");
        
        // Enable output
        bus_output_enable = 1;
        #10;
        display_bus_state("  Output enabled");
        
        // Cleanup
        bus_output_enable = 0;
        latch_enable = 0;
        #20;
        
        // Test 4: Multiple transfers with different data
        $display("Test 4: Multiple transfers");
        for (int i = 0; i < 4; i++) begin
            logic [7:0] test_data = 8'h10 + 8'(i * 8'h11);
            
            $display("  Transfer %0d: Data 0x%02h", i+1, test_data);
            
            // Setup data
            if (i % 2 == 0) begin
                // CPU to Bus
                cpu_data_driver = test_data;
                cpu_drive_enable = 1;
                ext_bus_drive_enable = 0;
                cpu_to_bus_dir = 1;
            end else begin
                // Bus to CPU
                ext_bus_data_driver = test_data;
                ext_bus_drive_enable = 1;
                cpu_drive_enable = 0;
                cpu_to_bus_dir = 0;
            end
            
            #10;
            
            // Latch and transfer
            latch_enable = 1;
            #10;
            bus_output_enable = 1;
            #10;
            display_bus_state("    Transfer complete");
            
            // Cleanup
            bus_output_enable = 0;
            latch_enable = 0;
            cpu_drive_enable = 0;
            ext_bus_drive_enable = 0;
            #10;
        end
        
        // Test 5: Timing control demonstration
        $display("Test 5: Timing control demonstration");
        cpu_data_driver = 8'hDE;
        cpu_drive_enable = 1;
        cpu_to_bus_dir = 1;
        
        $display("  Phase 1: Setup data");
        #10;
        display_bus_state("    Data setup");
        
        $display("  Phase 2: Latch data");
        latch_enable = 1;
        #10;
        display_bus_state("    Data latched");
        
        $display("  Phase 3: Remove source data");
        cpu_drive_enable = 0;
        #10;
        display_bus_state("    Source removed");
        
        $display("  Phase 4: Drive output");
        bus_output_enable = 1;
        #10;
        display_bus_state("    Output driving");
        
        $display("  Phase 5: Complete transfer");
        bus_output_enable = 0;
        latch_enable = 0;
        #10;
        display_bus_state("    Transfer complete");
        
        $display();
        $display("=== All tests completed ===");
        $display();
        
        #50 $finish;
    end

endmodule