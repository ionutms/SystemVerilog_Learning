// pwm_generator_design_testbench.sv
module pwm_generator_testbench;
    
    // Testbench signals
    logic       clock;
    logic       reset_n;
    logic       enable;
    logic [7:0] duty_cycle;
    logic       pwm_output;
    logic [7:0] counter_value;
    
    // Variables for duty cycle measurement
    integer high_count, total_count;
    real measured_duty;
    
    // Instantiate the PWM generator design
    pwm_generator_8bit PWM_GENERATOR_INSTANCE (
        .clock(clock),
        .reset_n(reset_n),
        .enable(enable),
        .duty_cycle(duty_cycle),
        .pwm_output(pwm_output),
        .counter_value(counter_value)
    );
    
    // Clock generation (10ns period = 100MHz)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end
    
    // Task to measure duty cycle over one complete period
    task measure_duty_cycle;
        input [7:0] expected_duty;
        begin
            high_count = 0;
            total_count = 0;
            
            // Wait for counter to start from 0
            while (counter_value != 0) @(posedge clock);
            
            // Measure for one complete period (256 clock cycles)
            repeat(256) begin
                @(posedge clock);
                if (pwm_output) high_count++;
                total_count++;
            end
            
            measured_duty = (high_count * 100.0) / total_count;
            $display("Expected: %d/256 (%.1f percent), Measured: %d/256 (%.1f percent) %s",
                     expected_duty, (expected_duty * 100.0)/256.0,
                     high_count, measured_duty,
                     (high_count == int'(expected_duty)) ? "✓" : "✗");
        end
    endtask
    
    // Test sequence
    initial begin
        // Setup waveform dumping
        $dumpfile("pwm_generator_testbench.vcd");
        $dumpvars(0, pwm_generator_testbench);
        
        // Display header
        $display();
        $display("=== 8-Bit PWM Generator Test ===");
        $display("PWM Frequency = Clock/256");
        $display("Resolution = 8 bits (256 steps)");
        $display();
        
        // Initialize signals
        reset_n = 0;
        enable = 0;
        duty_cycle = 0;
        
        // Apply reset
        #25;
        reset_n = 1;
        $display("=== RESET COMPLETE ===");
        #10;
        
        // Test 1: Different duty cycles
        $display();
        $display("=== TEST 1: Various Duty Cycles ===");
        
        enable = 1;
        
        // Test 0% duty cycle
        $display();
        $display("Testing 0 percent duty cycle:");
        duty_cycle = 8'd0;
        measure_duty_cycle(8'd0);
        
        // Test 25% duty cycle
        $display();
        $display("Testing 25 percent duty cycle:");
        duty_cycle = 8'd64;  // 64/256 = 25%
        measure_duty_cycle(8'd64);
        
        // Test 50% duty cycle
        $display();
        $display("Testing 50 percent duty cycle:");
        duty_cycle = 8'd128; // 128/256 = 50%
        measure_duty_cycle(8'd128);
        
        // Test 75% duty cycle
        $display();
        $display("Testing 75 percent duty cycle:");
        duty_cycle = 8'd192; // 192/256 = 75%
        measure_duty_cycle(8'd192);
        
        // Test 100% duty cycle
        $display();
        $display("Testing ~100 percent duty cycle:");
        duty_cycle = 8'd255; // 255/256 ≈ 99.6%
        measure_duty_cycle(8'd255);
        
        // Test 2: Dynamic duty cycle changes
        $display();
        $display("=== TEST 2: Dynamic Duty Cycle Changes ===");
        
        // Show real-time changes
        $display("Changing duty cycle every 0.5 periods...");
        
        duty_cycle = 8'd32;   // 12.5 percent
        #1280;  // 0.5 period (128 clocks)
        
        duty_cycle = 8'd96;   // 37.5 percent
        #1280;
        
        duty_cycle = 8'd160;  // 62.5 percent
        #1280;
        
        duty_cycle = 8'd224;  // 87.5 percent
        #1280;
        
        // Test 3: Enable/Disable functionality
        $display();
        $display("=== TEST 3: Enable/Disable Test ===");
        
        duty_cycle = 8'd128;  // 50 percent
        $display("PWM Enabled (50 percent duty cycle):");
        #500;
        
        enable = 0;
        $display("PWM Disabled (output should be 0):");
        #500;
        
        enable = 1;
        $display("PWM Re-enabled:");
        #500;
        
        // Test 4: Edge cases
        $display();
        $display("=== TEST 4: Edge Cases ===");
        
        // Minimum non-zero duty cycle
        $display();
        $display("Testing minimum duty cycle (1/256):");
        duty_cycle = 8'd1;
        measure_duty_cycle(8'd1);
        
        // Maximum duty cycle
        $display();
        $display("Testing maximum duty cycle (255/256):");
        duty_cycle = 8'd255;
        measure_duty_cycle(8'd255);
        
        // Show a few complete PWM periods with 50% duty cycle
        $display();
        $display("=== Showing 2 complete PWM periods (50 percent duty) ===");
        duty_cycle = 8'd128;
        
        repeat(512) begin  // 2 complete periods
            @(posedge clock);
            if (counter_value == 0) begin
                $display("--- New PWM Period Starting ---");
            end
        end
        
        $display();
        $display("=== PWM Generator Test Complete ===");
        $display();
        
        #100;
        $finish;
    end
    
    // Monitor PWM output transitions
    always @(pwm_output) begin
        if (reset_n && enable) begin
            $display("PWM: %s at counter=%d", pwm_output ? "HIGH" : "LOW", counter_value);
        end
    end

endmodule