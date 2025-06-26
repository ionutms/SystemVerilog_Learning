// parameterized_delay_line_testbench.sv
module delay_line_testbench;

    // Testbench parameters
    parameter TEST_DATA_WIDTH = 8;
    parameter TEST_DELAY_STAGES = 4;
    parameter CLOCK_PERIOD = 10;
    
    // Testbench signals
    logic                         clock_signal;
    logic                         reset_signal;
    logic [TEST_DATA_WIDTH-1:0]   test_data_input;
    logic [TEST_DATA_WIDTH-1:0]   delayed_test_output;
    
    // Instantiate the configurable delay line
    configurable_delay_line #(
        .DELAY_STAGES(TEST_DELAY_STAGES),
        .DATA_WIDTH(TEST_DATA_WIDTH)
    ) delay_line_under_test (
        .clock_signal(clock_signal),
        .reset_signal(reset_signal),
        .data_input(test_data_input),
        .delayed_data_output(delayed_test_output)
    );
    
    // Clock generation
    initial begin
        clock_signal = 0;
        forever #(CLOCK_PERIOD/2) clock_signal = ~clock_signal;
    end
    
    // Test stimulus
    initial begin
        // Setup VCD dumping
        $dumpfile("delay_line_testbench.vcd");
        $dumpvars(0, delay_line_testbench);
        
        $display("Starting Parameterized Delay Line Test");
        $display("=====================================");
        
        // Initialize signals
        reset_signal = 1;
        test_data_input = 8'h00;
        
        // Wait for a few clock cycles
        repeat(2) @(posedge clock_signal);
        
        // Release reset
        reset_signal = 0;
        $display("Reset released at time %0t", $time);
        
        // Send test patterns through the delay line
        for (int test_pattern = 1; test_pattern <= 8; test_pattern++) begin
            @(posedge clock_signal);
            test_data_input = TEST_DATA_WIDTH'(test_pattern * 16 + test_pattern); // Create distinctive patterns
            $display("Time %0t: Input = 8'h%02h, Output = 8'h%02h", 
                    $time, test_data_input, delayed_test_output);
        end
        
        // Continue for a few more cycles to see the delayed outputs
        test_data_input = 8'h00;
        repeat(6) begin
            @(posedge clock_signal);
            $display("Time %0t: Input = 8'h%02h, Output = 8'h%02h", 
                    $time, test_data_input, delayed_test_output);
        end
        
        $display();
        $display("Test completed - Check VCD file for waveforms");
        $display("Expected behavior: Output should be delayed by %0d clock cycles", TEST_DELAY_STAGES);
        
        $finish;
    end
    
    // Monitor for significant changes
    initial begin
        @(negedge reset_signal);
        $display();
        $display("Monitoring delay line behavior:");
        $display("Input -> Output (with %0d cycle delay)", TEST_DELAY_STAGES);
        $display("--------------------------------");
    end

endmodule