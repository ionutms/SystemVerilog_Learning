// port_direction_testbench.sv
module port_direction_testbench;

    // Testbench signals for different port types
    logic       tb_clk;
    logic       tb_reset_n;
    logic [3:0] tb_data_in;        // INPUT port connection
    logic [3:0] tb_data_out;       // OUTPUT port connection
    logic       tb_valid_out;      // OUTPUT port connection
    wire  [7:0] tb_bus_data;       // INOUT port connection (wire)
    logic [1:0] tb_ref_counter;    // REF port connection
    
    // Additional signals for testing inout port
    logic       tb_bus_drive;
    logic [7:0] tb_bus_value;

    // Clock generation
    initial begin
        tb_clk = 0;
        forever #5 tb_clk = ~tb_clk; // 10ns period clock
    end

    // =============================================================
    // MODULE INSTANTIATION - Demonstrating all port types
    // =============================================================
    port_direction DUT (
        // INPUT ports - we drive these from testbench
        .clk(tb_clk),
        .reset_n(tb_reset_n),
        .data_in(tb_data_in),
        
        // OUTPUT ports - module drives these to testbench
        .data_out(tb_data_out),
        .valid_out(tb_valid_out),
        
        // INOUT port - bidirectional connection
        .bus_data(tb_bus_data),
        
        // REF port - direct reference to testbench variable
        .ref_counter(tb_ref_counter)
    );

    // Bidirectional bus driver for testing
    assign tb_bus_data = tb_bus_drive ? tb_bus_value : 8'hZZ;

    // Test stimulus
    initial begin
        // Dump waves
        $dumpfile("port_direction_testbench.vcd");
        $dumpvars(0, port_direction_testbench);

        $display("=== Port Direction Demo Testbench Started ===");
        $display();

        // Initialize signals
        tb_reset_n = 0;
        tb_data_in = 4'h0;
        tb_ref_counter = 2'b00;
        tb_bus_drive = 0;
        tb_bus_value = 8'h00;

        // Reset sequence
        $display("Time %0t: Applying reset", $time);
        #20;
        tb_reset_n = 1;
        $display("Time %0t: Releasing reset", $time);
        #10;

        // Test 1: INPUT and OUTPUT ports
        $display("--- Testing INPUT and OUTPUT ports ---");
        tb_data_in = 4'h3;
        #20;
        $display("Time %0t: INPUT data_in = %d, OUTPUT data_out = %d, valid = %b", 
                 $time, tb_data_in, tb_data_out, tb_valid_out);
        $display("  -> Module doubles input: %d * 2 = %d", 
                 tb_data_in, tb_data_out);
        
        // Test 2: REF port modification
        $display("--- Testing REF port ---");
        $display("Time %0t: REF counter before = %d", $time, tb_ref_counter);
        tb_data_in = 4'h5;
        #20;
        $display("Time %0t: REF counter after = %d", $time, tb_ref_counter);
        $display("  -> Module modified ref_counter directly!");

        // Test 3: INOUT port - Module driving bus
        $display("--- Testing INOUT port - Module driving ---");
        tb_data_in = 4'h7;  // LSB = 1, so module will drive bus
        #20;
        $display("Time %0t: Module driving bus_data = 0x%02h", 
                 $time, tb_bus_data);
        $display("  -> Module drives bus when data_in[0] = 1");

        // Test 4: INOUT port - Testbench driving bus
        $display("--- Testing INOUT port - Testbench driving ---");
        tb_data_in = 4'h6;  // LSB = 0, so module tri-states bus
        tb_bus_drive = 1;
        tb_bus_value = 8'hFF;
        #20;
        $display("Time %0t: Testbench driving bus_data = 0x%02h", 
                 $time, tb_bus_data);
        $display("  -> Testbench drives bus when module tri-states");

        // Test 5: Show final state
        tb_bus_drive = 0;
        tb_data_in = 4'h0;
        #20;
        $display();
        $display("=== Final Results ===");
        $display("INPUT ports: Driven by testbench to module");
        $display("OUTPUT ports: Driven by module to testbench");
        $display("INOUT ports: Bidirectional, either side can drive");
        $display("REF ports: Direct reference, module can modify testbench vars");
        $display("Final ref_counter value: %d", tb_ref_counter);
        $display();

        #10;
        $finish;
    end

endmodule