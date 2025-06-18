// instantiation_examples.sv
module instantiation_examples;

    // Common testbench signals
    logic clk;
    logic reset_n;
    
    // Signals for register instances
    logic enable_1, enable_2, enable_3, enable_4;
    logic load_1, load_2, load_3, load_4;
    logic clear_1, clear_2, clear_3, clear_4;
    logic [7:0] data_in_1, data_in_2, data_in_3, data_in_4;
    logic [7:0] load_data_1, load_data_2, load_data_3, load_data_4;
    logic [7:0] data_out_1, data_out_2, data_out_3, data_out_4;
    logic valid_1, valid_2, valid_3, valid_4;
    logic changed_1, changed_2, changed_3, changed_4;
    
    // Signals for 16-bit register
    logic [15:0] data_in_16, load_data_16, data_out_16;
    logic enable_16, load_16, clear_16, valid_16, changed_16;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz clock
    end
    
    //========================================================================
    // EXAMPLE 1: Named Port Connections (RECOMMENDED)
    //========================================================================
    data_register #(
        .WIDTH(8),
        .RESET_VALUE(8'hAA),
        .SYNC_RESET(1'b0),
        .REGISTER_NAME("REG1_NAMED")
    ) reg1_named_inst (
        // Clock and reset
        .clk(clk),
        .reset_n(reset_n),
        
        // Control signals
        .enable(enable_1),
        .load(load_1),
        .clear(clear_1),
        
        // Data signals
        .data_in(data_in_1),
        .load_data(load_data_1),
        .data_out(data_out_1),
        
        // Status signals
        .valid(valid_1),
        .changed(changed_1)
    );
    
    //========================================================================
    // EXAMPLE 2: Named Port Connections with Different Parameters
    //========================================================================
    data_register #(
        .WIDTH(8),
        .RESET_VALUE(8'h55),
        .SYNC_RESET(1'b1),           // Synchronous reset
        .REGISTER_NAME("REG2_SYNC")
    ) reg2_sync_inst (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable_2),
        .load(load_2),
        .clear(clear_2),
        .data_in(data_in_2),
        .load_data(load_data_2),
        .data_out(data_out_2),
        .valid(valid_2),
        .changed(changed_2)
    );
    
    //========================================================================
    // EXAMPLE 3: Named Port Connections with Parameter Override
    //========================================================================
    data_register #(
        .WIDTH(16),                  // 16-bit register
        .RESET_VALUE(16'hDEAD),
        .SYNC_RESET(1'b0),
        .REGISTER_NAME("REG3_16BIT")
    ) reg3_16bit_inst (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable_16),
        .load(load_16),
        .clear(clear_16),
        .data_in(data_in_16),
        .load_data(load_data_16),
        .data_out(data_out_16),
        .valid(valid_16),
        .changed(changed_16)
    );
    
    //========================================================================
    // EXAMPLE 4: Positional Port Connections (NOT RECOMMENDED)
    // Order must match exactly with module port declaration
    //========================================================================
    data_register #(8, 8'h00, 1'b0, "REG4_POSITIONAL") reg4_positional_inst (
        clk,            // clk
        reset_n,        // reset_n
        enable_3,       // enable
        load_3,         // load
        clear_3,        // clear
        data_in_3,      // data_in
        load_data_3,    // load_data
        data_out_3,     // data_out
        valid_3,        // valid
        changed_3       // changed
    );
    
    //========================================================================
    // EXAMPLE 5: Mixed Named and Positional (NOT RECOMMENDED)
    // This shows what NOT to do - mixing styles is confusing
    //========================================================================
    /* 
    // This would be bad practice - don't mix styles:
    data_register #(.WIDTH(8)) reg_mixed_inst (
        clk, reset_n,           // Positional
        .enable(enable_4),      // Named
        load_4, clear_4,        // Positional again
        .data_in(data_in_4),    // Named again
        // ... this is confusing and error-prone
    );
    */
    
    //========================================================================
    // EXAMPLE 6: Default Parameters with Named Connections
    //========================================================================
    data_register reg5_default_inst (  // Using all default parameters
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable_4),
        .load(load_4),
        .clear(clear_4),
        .data_in(data_in_4),
        .load_data(load_data_4),
        .data_out(data_out_4),
        .valid(valid_4),
        .changed(changed_4)
    );
    
    //========================================================================
    // Test Stimulus
    //========================================================================
    initial begin
        // Initialize VCD dump
        $dumpfile("instantiation_examples.vcd");
        $dumpvars(0, instantiation_examples);
        
        $display("=== Module Instantiation Examples Started ===");
        $display("Demonstrating Named vs Positional Port Connections");
        $display();
        
        // Initialize all signals
        reset_n = 0;
        {enable_1, enable_2, enable_16, enable_3, enable_4} = 5'b00000;
        {load_1, load_2, load_16, load_3, load_4} = 5'b00000;
        {clear_1, clear_2, clear_16, clear_3, clear_4} = 5'b00000;
        data_in_1 = 8'h10;
        data_in_2 = 8'h20;
        data_in_3 = 8'h30;
        data_in_4 = 8'h40;
        data_in_16 = 16'hBEEF;
        load_data_1 = 8'hF1;
        load_data_2 = 8'hF2;
        load_data_3 = 8'hF3;
        load_data_4 = 8'hF4;
        load_data_16 = 16'hCAFE;
        
        // Release reset
        #20 reset_n = 1;
        $display("Reset released - checking initial values:");
        #10;
        $display("REG1 (named, async): data_out=%02h, valid=%b", data_out_1, valid_1);
        $display("REG2 (named, sync):  data_out=%02h, valid=%b", data_out_2, valid_2);
        $display("REG3 (16-bit):       data_out=%04h, valid=%b", data_out_16, valid_16);
        $display("REG4 (positional):   data_out=%02h, valid=%b", data_out_3, valid_3);
        $display("REG5 (default):      data_out=%02h, valid=%b", data_out_4, valid_4);
        $display();
        
        // Test normal write operations
        $display("Testing normal write operations:");
        enable_1 = 1; enable_2 = 1; enable_16 = 1; enable_3 = 1; enable_4 = 1;
        #10;
        $display("After enable - all registers should have new data:");
        $display("REG1: %02h, REG2: %02h, REG3: %04h, REG4: %02h, REG5: %02h", 
                data_out_1, data_out_2, data_out_16, data_out_3, data_out_4);
        
        // Test load operations (higher priority)
        $display();
        $display("Testing load operations (higher priority than enable):");
        load_1 = 1; load_2 = 1; load_16 = 1; load_3 = 1; load_4 = 1;
        #10;
        $display("After load - registers should have load_data values:");
        $display("REG1: %02h, REG2: %02h, REG3: %04h, REG4: %02h, REG5: %02h", 
                data_out_1, data_out_2, data_out_16, data_out_3, data_out_4);
        
        load_1 = 0; load_2 = 0; load_16 = 0; load_3 = 0; load_4 = 0;
        
        // Test clear operations
        $display();
        $display("Testing clear operations:");
        clear_1 = 1; clear_2 = 1; clear_16 = 1; clear_3 = 1; clear_4 = 1;
        #10;
        $display("After clear - all registers should be zero:");
        $display("REG1: %02h, REG2: %02h, REG3: %04h, REG4: %02h, REG5: %02h", 
                data_out_1, data_out_2, data_out_16, data_out_3, data_out_4);
        
        clear_1 = 0; clear_2 = 0; clear_16 = 0; clear_3 = 0; clear_4 = 0;
        enable_1 = 0; enable_2 = 0; enable_16 = 0; enable_3 = 0; enable_4 = 0;
        
        #50;
        $display();
        $display("=== Instantiation Examples Summary ===");
        $display("1. Named connections (RECOMMENDED):");
        $display("   - Clear and readable");
        $display("   - Order independent");
        $display("   - Less error-prone");
        $display("   - Easy to maintain");
        $display();
        $display("2. Positional connections (NOT RECOMMENDED):");
        $display("   - Order dependent");
        $display("   - Error-prone");
        $display("   - Hard to maintain");
        $display("   - Only use for very simple modules");
        $display();
        $display("3. Parameter override examples shown:");
        $display("   - Different widths");
        $display("   - Different reset types");
        $display("   - Different reset values");
        $display("   - Using default parameters");
        $display();
        
        $finish;
    end

endmodule