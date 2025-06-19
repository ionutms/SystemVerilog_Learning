// array_port_module_testbench.sv - Fixed testbench with proper array syntax
module array_port_module_testbench;

    // Testbench parameters
    localparam int CLK_PERIOD = 10;
    localparam int TB_DATA_WIDTH = 8;
    localparam int TB_NUM_CHANNELS = 4;
    
    // Testbench signals - using arrays to match DUT
    logic                               clk;
    logic                               reset_n;
    logic                               enable;
    
    // Array signals
    logic [TB_DATA_WIDTH-1:0]          data_in [TB_NUM_CHANNELS];
    logic                               valid_in [TB_NUM_CHANNELS];
    logic [TB_DATA_WIDTH-1:0]          data_out [TB_NUM_CHANNELS];
    logic                               valid_out [TB_NUM_CHANNELS];
    logic [7:0]                        channel_count [TB_NUM_CHANNELS];
    logic [TB_DATA_WIDTH-1:0]          channel_max [TB_NUM_CHANNELS];
    logic [TB_DATA_WIDTH-1:0]          channel_min [TB_NUM_CHANNELS];
    
    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // DUT instantiation
    array_port_module #(
        .DATA_WIDTH(TB_DATA_WIDTH),
        .NUM_CHANNELS(TB_NUM_CHANNELS)
    ) dut (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .data_in(data_in),
        .valid_in(valid_in),
        .data_out(data_out),
        .valid_out(valid_out),
        .channel_count(channel_count),
        .channel_max(channel_max),
        .channel_min(channel_min)
    );
    
    // Task to send data to a specific channel
    task automatic send_data(input int channel, input logic [TB_DATA_WIDTH-1:0] data, input logic valid);
        if (channel < TB_NUM_CHANNELS) begin
            data_in[channel] = data;
            valid_in[channel] = valid;
        end
    endtask
    
    // Task to display all channel status
    task automatic display_status();
        $display("\n=== Channel Status at time %0t ===", $time);
        for (int i = 0; i < TB_NUM_CHANNELS; i++) begin
            $display("Channel %0d: out=%3d, valid=%b, count=%3d, max=%3d, min=%3d",
                    i, data_out[i], valid_out[i], channel_count[i], 
                    channel_max[i], channel_min[i]);
        end
        $display("====================================\n");
    endtask
    
    // Test stimulus
    initial begin
        // Initialize VCD dump
        $dumpfile("array_port_module_testbench.vcd");
        $dumpvars(0, array_port_module_testbench);
        
        $display("=== Simple Array Port Module Testbench Started ===");
        $display("Testing with %0d channels, %0d-bit data width", TB_NUM_CHANNELS, TB_DATA_WIDTH);
        
        // Initialize all signals
        reset_n = 0;
        enable = 0;
        
        // Initialize input arrays
        for (int i = 0; i < TB_NUM_CHANNELS; i++) begin
            data_in[i] = 0;
            valid_in[i] = 0;
        end
        
        // Reset sequence
        $display("\nPhase 1: Reset Test");
        #(CLK_PERIOD * 2);
        reset_n = 1;
        enable = 1;
        #(CLK_PERIOD);
        display_status();
        
        // Phase 2: Send data to all channels simultaneously
        $display("Phase 2: Send Data to All Channels");
        for (int cycle = 0; cycle < 5; cycle++) begin
            $display("Cycle %0d:", cycle);
            for (int ch = 0; ch < TB_NUM_CHANNELS; ch++) begin
                send_data(ch, 8'(cycle * 20 + ch * 5), 1'b1);
            end
            #(CLK_PERIOD);
            display_status();
        end
        
        // Phase 3: Send data to specific channels only
        $display("Phase 3: Selective Channel Operation");
        
        // Clear all valid signals first
        for (int i = 0; i < TB_NUM_CHANNELS; i++) begin
            valid_in[i] = 0;
        end
        #(CLK_PERIOD);
        
        // Send to channel 0 and 2 only
        send_data(0, 8'd150, 1'b1);
        send_data(2, 8'd200, 1'b1);
        #(CLK_PERIOD);
        display_status();
        
        // Send to channel 1 and 3 only
        for (int i = 0; i < TB_NUM_CHANNELS; i++) begin
            valid_in[i] = 0;
        end
        send_data(1, 8'd75, 1'b1);
        send_data(3, 8'd250, 1'b1);
        #(CLK_PERIOD);
        display_status();
        
        // Phase 4: Test min/max tracking
        $display("Phase 4: Min/Max Value Tracking");
        
        // Use the pre-declared test_val variable
        for (int cycle = 0; cycle < 5; cycle++) begin
            case (cycle)
                0: test_val = 50;
                1: test_val = 200;
                2: test_val = 10;
                3: test_val = 240;
                4: test_val = 30;
                default: test_val = 0;
            endcase
            
            $display("Sending test value %0d to all channels", test_val);
            for (int ch = 0; ch < TB_NUM_CHANNELS; ch++) begin
                send_data(ch, test_val, 1'b1);
            end
            #(CLK_PERIOD);
            display_status();
        end
        
        // Phase 5: Test enable control
        $display("Phase 5: Enable Control Test");
        
        // Disable the module
        enable = 0;
        for (int ch = 0; ch < TB_NUM_CHANNELS; ch++) begin
            send_data(ch, 8'd100, 1'b1);
        end
        #(CLK_PERIOD * 2);
        $display("With enable=0 (should not process new data):");
        display_status();
        
        // Re-enable
        enable = 1;
        #(CLK_PERIOD);
        $display("With enable=1 (should process new data):");
        display_status();
        
        // Phase 6: Counter test
        $display("Phase 6: Counter Test - Send Multiple Values");
        for (int burst = 0; burst < 3; burst++) begin
            for (int ch = 0; ch < TB_NUM_CHANNELS; ch++) begin
                send_data(ch, 8'(burst * 50 + ch * 10), 1'b1);
            end
            #(CLK_PERIOD);
        end
        display_status();
        
        // Phase 7: Final test with mixed valid signals
        $display("Phase 7: Mixed Valid Signals Test");
        for (int cycle = 0; cycle < 4; cycle++) begin
            for (int ch = 0; ch < TB_NUM_CHANNELS; ch++) begin
                // Alternate valid signals in a pattern - fixed width truncation
                logic valid = ((cycle + ch) % 2) == 1;
                send_data(ch, 8'(cycle * 30 + ch), valid);
            end
            #(CLK_PERIOD);
            if (cycle % 2 == 1) display_status();
        end
        
        // Final status
        $display("Final Status:");
        // Clear all inputs
        for (int i = 0; i < TB_NUM_CHANNELS; i++) begin
            valid_in[i] = 0;
        end
        #(CLK_PERIOD);
        display_status();
        
        $display("=== Array Port Module Testbench Completed ===");
        $display("Total simulation time: %0t", $time);
        $finish;
    end
    
    // Monitor for interesting events
    always @(posedge clk) begin
        if (reset_n && enable) begin
            // Count how many channels are active
            int active_count = 0;
            for (int i = 0; i < TB_NUM_CHANNELS; i++) begin
                if (valid_in[i]) active_count++;
            end
            
            if (active_count == TB_NUM_CHANNELS) begin
                $display("*** ALL %0d CHANNELS ACTIVE at time %0t ***", TB_NUM_CHANNELS, $time);
            end
        end
    end
    
    // Example of array manipulation in testbench
    logic [TB_DATA_WIDTH-1:0] sum_outputs;
    logic [TB_DATA_WIDTH-1:0] max_output;
    int valid_output_count;
    
    // Test value variable for Phase 4
    logic [TB_DATA_WIDTH-1:0] test_val;
    
    // Calculate statistics from output arrays
    always_comb begin
        sum_outputs = '0;
        max_output = '0;
        valid_output_count = 0;
        
        for (int i = 0; i < TB_NUM_CHANNELS; i++) begin
            if (valid_out[i]) begin
                sum_outputs += data_out[i];
                valid_output_count++;
                if (data_out[i] > max_output) begin
                    max_output = data_out[i];
                end
            end
        end
    end

endmodule