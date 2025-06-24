// pwm_generator_design.sv
module pwm_generator_8bit (
    input  logic       clock,
    input  logic       reset_n,
    input  logic       enable,
    input  logic [7:0] duty_cycle,    // 0-255 (0% to 100% duty cycle)
    output logic       pwm_output,
    output logic [7:0] counter_value
);

    // 8-bit counter for PWM period
    logic [7:0] pwm_counter;
    
    // PWM counter logic
    always_ff @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            pwm_counter <= 8'b0;
        end
        else if (enable) begin
            pwm_counter <= pwm_counter + 1;  // Auto-wraps at 255->0
        end
    end
    
    // PWM output generation
    // Output is HIGH when counter < duty_cycle, LOW otherwise
    assign pwm_output = enable ? (pwm_counter < duty_cycle) : 1'b0;
    
    // Counter output for monitoring
    assign counter_value = pwm_counter;
    
    // Display PWM parameters when duty cycle changes
    always @(duty_cycle) begin
        if (reset_n) begin
            real duty_percent;
            duty_percent = (duty_cycle * 100.0) / 256.0;
            $display("PWM Config: Duty Cycle = %d/256 (%.1f percent)", duty_cycle, duty_percent);
        end
    end
    
    // Optional: Display counter rollover
    always @(posedge clock) begin
        if (enable && reset_n && (pwm_counter == 8'hFF)) begin
            $display("PWM Period Complete (Counter rolled over)");
        end
    end

endmodule