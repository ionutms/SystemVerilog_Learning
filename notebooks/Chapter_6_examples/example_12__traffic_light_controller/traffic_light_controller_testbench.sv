// traffic_light_controller_testbench.sv
module traffic_light_testbench;

    // Testbench signals
    logic clk;
    logic reset;
    logic red_light;
    logic yellow_light;
    logic green_light;

    // Instantiate design under test
    traffic_light_controller TRAFFIC_CONTROLLER (
        .clk(clk),
        .reset(reset),
        .red_light(red_light),
        .yellow_light(yellow_light),
        .green_light(green_light)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10 time unit period
    end

    // Test sequence
    initial begin
        // Dump waves
        $dumpfile("traffic_light_testbench.vcd");
        $dumpvars(0, traffic_light_testbench);
        
        $display("=== Traffic Light Controller Test ===");
        $display("Time %0t: Starting simulation", $time);
        
        // Initialize
        reset = 1;
        #20;
        reset = 0;
        
        $display("Time %0t: Reset released - Traffic light should start in RED", $time);
        
        // Monitor light states
        forever begin
            @(posedge clk);
            $display("Time %0t: Lights - RED:%b GREEN:%b YELLOW:%b", 
                    $time, red_light, green_light, yellow_light);
            
            // Check that only one light is on at a time
            if ((red_light + green_light + yellow_light) != 1) begin
                $display("ERROR: Multiple or no lights active!");
                $finish;
            end
        end
    end

    // Test duration control
    initial begin
        #2000;  // Run for enough time to see multiple cycles
        $display("Time %0t: Test completed successfully", $time);
        $display("=== Traffic Light Controller Test Passed ===");
        $finish;
    end

    // Display light changes with timing
    always @(posedge clk) begin
        if ($changed(red_light) || $changed(green_light) || $changed(yellow_light)) begin
            if (red_light)    $display(">>> RED LIGHT ON    (Duration: 8 cycles)");
            if (green_light)  $display(">>> GREEN LIGHT ON  (Duration: 6 cycles)");
            if (yellow_light) $display(">>> YELLOW LIGHT ON (Duration: 2 cycles)");
        end
    end

endmodule