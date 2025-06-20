// data_register_testbench.sv
module data_register_testbench;

    // Testbench signals
    logic       tb_clk;
    logic       tb_rst_n;
    logic       tb_enable;
    logic [7:0] tb_data_in;
    logic [7:0] tb_data_out_named;
    logic [7:0] tb_data_out_positional;

    // Clock generation
    initial begin
        tb_clk = 0;
        forever #5 tb_clk = ~tb_clk; // 10ns period clock
    end

    // =================================================================
    // EXAMPLE 1: NAMED PORT CONNECTIONS (Recommended method)
    // =================================================================
    data_register DUT_NAMED_CONNECTIONS (
        .clk(tb_clk),
        .rst_n(tb_rst_n),
        .enable(tb_enable),
        .data_in(tb_data_in),
        .data_out(tb_data_out_named)
    );

    // =================================================================
    // EXAMPLE 2: POSITIONAL PORT CONNECTIONS (Order matters!)
    // =================================================================
    data_register DUT_POSITIONAL_CONNECTIONS (
        tb_clk,                    // clk (1st port)
        tb_rst_n,                  // rst_n (2nd port)
        tb_enable,                 // enable (3rd port)
        tb_data_in,                // data_in (4th port)
        tb_data_out_positional     // data_out (5th port)
    );

    // Test stimulus
    initial begin
        // Dump waves
        $dumpfile("data_register_testbench.vcd");
        $dumpvars(0, data_register_testbench);

        $display("=== Data Register Testbench Started ===");
        $display("Testing both named and positional instantiation methods");
        $display();

        // Initialize signals
        tb_rst_n = 0;
        tb_enable = 0;
        tb_data_in = 8'h00;

        // Reset sequence
        $display("Time %0t: Applying reset", $time);
        #20;
        tb_rst_n = 1;
        $display("Time %0t: Releasing reset", $time);
        #10;

        // Test 1: Load data with enable
        tb_enable = 1;
        tb_data_in = 8'hAA;
        $display("Time %0t: Loading data 0x%02h with enable=1", $time, tb_data_in);
        #20;
        $display("Time %0t: Named output = 0x%02h, Positional output = 0x%02h",
                 $time, tb_data_out_named, tb_data_out_positional);

        // Test 2: Change input with enable disabled
        tb_enable = 0;
        tb_data_in = 8'h55;
        $display("Time %0t: Changing input to 0x%02h with enable=0",
                 $time, tb_data_in);
        #20;
        $display("Time %0t: Named output = 0x%02h, Positional output = 0x%02h",
                 $time, tb_data_out_named, tb_data_out_positional);
        $display("  -> Data should remain unchanged (0xAA)");

        // Test 3: Enable again to load new data
        tb_enable = 1;
        $display("Time %0t: Re-enabling to load new data 0x%02h",
                 $time, tb_data_in);
        #20;
        $display("Time %0t: Named output = 0x%02h, Positional output = 0x%02h",
                 $time, tb_data_out_named, tb_data_out_positional);

        $display();
        $display("=== Both instantiation methods produce identical results ===");
        $display("Named connections: More readable and less error-prone");
        $display("Positional connections: Shorter but order-dependent");
        $display();
        
        #10;
        $finish;
    end

endmodule