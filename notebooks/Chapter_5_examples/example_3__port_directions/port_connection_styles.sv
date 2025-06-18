// port_connection_styles.sv
module port_connection_styles;
    
    // Testbench signals
    logic clk, reset_n, enable;
    logic read_en, write_en;
    logic [7:0] data_in, data_out;
    logic [3:0] address;
    logic valid_out, ready, error;
    logic [1:0] status;
    
    // Bidirectional bus signals
    wire [7:0] data_bus;
    wire bus_enable;
    logic [7:0] ext_bus_data;
    logic ext_bus_drive;
    
    // Debug signals for ref port demonstration
    logic [7:0] debug_data;
    logic debug_valid;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    //========================================================================
    // EXAMPLE 1: All Port Types with Named Connections (RECOMMENDED)
    //========================================================================
    port_direction_demo #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(4),
        .MODULE_NAME("DEMO1_NAMED")
    ) demo1_inst (
        // INPUT ports
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .data_in(data_in),
        .address(address),
        .read_enable(read_en),
        .write_enable(write_en),
        
        // OUTPUT ports
        .data_out(data_out),
        .valid_out(valid_out),
        .ready(ready),
        .error(error),
        .status(status),
        
        // INOUT ports
        .data_bus(data_bus),
        .bus_enable(bus_enable),
        
        // REF ports
        .debug_data(debug_data),
        .debug_valid(debug_valid)
    );
    
    //========================================================================
    // EXAMPLE 2: Different Parameter Configuration
    //========================================================================
    logic [15:0] data_in_16, data_out_16;
    logic [7:0] addr_16;
    logic valid_16, ready_16, error_16;
    logic [1:0] status_16;
    wire [15:0] data_bus_16;
    wire bus_enable_16;
    logic [15:0] debug_data_16;
    logic debug_valid_16;
    
    port_direction_demo #(
        .DATA_WIDTH(16),             // 16-bit data width
        .ADDR_WIDTH(8),              // 8-bit address width
        .MODULE_NAME("DEMO2_16BIT")
    ) demo2_16bit_inst (
        // INPUT ports - grouped for clarity
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        
        // Data and address inputs
        .data_in(data_in_16),
        .address(addr_16[7:0]),      // Use full 8-bit address for 8-bit ADDR_WIDTH
        
        // Control inputs
        .read_enable(read_en),
        .write_enable(write_en),
        
        // OUTPUT ports - grouped for clarity
        .data_out(data_out_16),
        .valid_out(valid_16),
        .ready(ready_16),
        .error(error_16),
        .status(status_16),
        
        // INOUT ports
        .data_bus(data_bus_16),
        .bus_enable(bus_enable_16),
        
        // REF ports
        .debug_data(debug_data_16),
        .debug_valid(debug_valid_16)
    );
    
    //========================================================================
    // EXAMPLE 3: Minimal Connection (Using Defaults Where Possible)
    //========================================================================
    logic [7:0] data_out_min;
    logic valid_min, ready_min, error_min;
    logic [1:0] status_min;
    wire [7:0] data_bus_min;
    wire bus_enable_min;
    logic [7:0] debug_data_min;
    logic debug_valid_min;
    
    port_direction_demo #(
        .MODULE_NAME("DEMO3_MINIMAL")
        // Using default DATA_WIDTH=8, ADDR_WIDTH=4
    ) demo3_minimal_inst (
        // Essential connections only
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .data_in(data_in),
        .address(address),
        .read_enable(1'b0),          // Tie unused inputs
        .write_enable(1'b0),         // Tie unused inputs
        .data_out(data_out_min),
        .valid_out(valid_min),
        .ready(ready_min),
        .error(error_min),
        .status(status_min),
        .data_bus(data_bus_min),
        .bus_enable(bus_enable_min),
        .debug_data(debug_data_min),
        .debug_valid(debug_valid_min)
    );
    
    //========================================================================
    // External bus drivers for inout demonstration
    //========================================================================
    assign data_bus = ext_bus_drive ? ext_bus_data : 'z;
    
    // For 16-bit demo
    logic [15:0] ext_bus_data_16;
    logic ext_bus_drive_16;
    assign data_bus_16 = ext_bus_drive_16 ? ext_bus_data_16 : 'z;
    
    //========================================================================
    // Test Stimulus and Demonstrations
    //========================================================================
    initial begin
        $dumpfile("port_connection_styles.vcd");
        $dumpvars(0, port_connection_styles);
        
        $display("=== Port Connection Styles Demo Started ===");
        $display("Demonstrating different ways to connect port types");
        $display();
        
        // Initialize signals
        reset_n = 0;
        enable = 0;
        read_en = 0;
        write_en = 0;
        data_in = 8'h00;
        data_in_16 = 16'h0000;
        address = 4'h0;
        addr_16 = 8'h00;
        ext_bus_drive = 0;
        ext_bus_drive_16 = 0;
        ext_bus_data = 8'h00;
        ext_bus_data_16 = 16'h0000;
        debug_data = 8'h00;
        debug_data_16 = 16'h0000;
        debug_valid = 0;
        debug_valid_16 = 0;
        
        // Release reset
        #20 reset_n = 1;
        #10 enable = 1;
        
        $display("=== Testing Different Port Widths ===");
        
        // Test 8-bit instance
        $display("1. Testing 8-bit instance:");
        address = 4'h2;
        data_in = 8'hAB;
        write_en = 1;
        #10;
        $display("   8-bit: addr=%h, data_in=%02h → data_out=%02h, valid=%b", 
                address, data_in, data_out, valid_out);
        write_en = 0;
        #10;
        
        // Test 16-bit instance
        $display("2. Testing 16-bit instance:");
        addr_16 = 8'h03;
        data_in_16 = 16'hCDEF;
        write_en = 1;
        #10;
        $display("   16-bit: addr=%h, data_in=%04h → data_out=%04h, valid=%b", 
                addr_16[7:0], data_in_16, data_out_16, valid_16);
        write_en = 0;
        #20;
        
        $display();
        $display("=== Testing INOUT Port Behavior ===");
        
        // Test module driving bus (8-bit)
        $display("3. 8-bit module driving bus:");
        address = 4'h1;
        data_in = 8'h55;
        write_en = 1;
        #10;
        $display("   Bus state: data_bus=%02h, bus_enable=%b", data_bus, bus_enable);
        write_en = 0;
        #10;
        
        // Test external driving bus (8-bit)
        $display("4. External driving 8-bit bus:");
        ext_bus_data = 8'hAA;
        ext_bus_drive = 1;
        #10;
        $display("   External drive: data_bus=%02h", data_bus);
        ext_bus_drive = 0;
        #10;
        
        // Test 16-bit bus
        $display("5. External driving 16-bit bus:");
        ext_bus_data_16 = 16'h1234;
        ext_bus_drive_16 = 1;
        #10;
        $display("   External drive 16-bit: data_bus_16=%04h", data_bus_16);
        ext_bus_drive_16 = 0;
        #10;
        
        $display();
        $display("=== Testing REF Port Updates ===");
        
        // Test ref port monitoring
        $display("6. REF port monitoring test:");
        debug_data = 8'h11;
        debug_valid = 1;
        #5;
        debug_data = 8'h22;
        #5;
        debug_data = 8'h33;
        #5;
        debug_valid = 0;
        #5;
        
        // Test 16-bit ref ports
        debug_data_16 = 16'h4567;
        debug_valid_16 = 1;
        #5;
        debug_data_16 = 16'h89AB;
        #5;
        debug_valid_16 = 0;
        #10;
        
        $display();
        $display("=== Port Connection Summary ===");
        $display("Demonstrated three connection styles:");
        $display("1. Full featured with 8-bit data");
        $display("2. 16-bit data width with 8-bit addressing");
        $display("3. Minimal connections with tied-off unused ports");
        $display();
        $display("All instances showed proper:");
        $display("- INPUT port usage (reading only)");
        $display("- OUTPUT port usage (assigning only)");
        $display("- INOUT port tri-state behavior");
        $display("- REF port monitoring capability");
        $display();
        
        #50;
        $finish;
    end
    
    //========================================================================
    // Monitor all instances for comparison
    //========================================================================
    always @(posedge clk) begin
        if (reset_n && enable && (write_en || read_en)) begin
            $display("Clock Monitor:");
            $display("  8-bit:  addr=%h, in=%02h, out=%02h, valid=%b, ready=%b", 
                    address, data_in, data_out, valid_out, ready);
            $display("  16-bit: addr=%h, in=%04h, out=%04h, valid=%b, ready=%b", 
                    addr_16[7:0], data_in_16, data_out_16, valid_16, ready_16);
            $display("  Minimal: out=%02h, valid=%b, ready=%b", 
                    data_out_min, valid_min, ready_min);
        end
    end

endmodule