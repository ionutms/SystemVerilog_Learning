// color_space_converter_testbench.sv
module color_converter_testbench;

    // Clock and reset signals
    logic        system_clock;
    logic        reset_signal;
    
    // Input signals to design under test
    logic        conversion_trigger;
    logic [7:0]  input_red_value;
    logic [7:0]  input_green_value;
    logic [7:0]  input_blue_value;
    
    // Output signals from design under test
    logic [8:0]  output_hue_degrees;
    logic [7:0]  output_saturation_percent;
    logic [7:0]  output_value_brightness;
    logic        output_conversion_complete;

    // Instantiate the RGB to HSV converter
    rgb_to_hsv_converter COLOR_CONVERTER_INSTANCE (
        .clk(system_clock),
        .reset_n(reset_signal),
        .convert_enable(conversion_trigger),
        .red_channel(input_red_value),
        .green_channel(input_green_value),
        .blue_channel(input_blue_value),
        .hue_output(output_hue_degrees),
        .saturation_output(output_saturation_percent),
        .value_output(output_value_brightness),
        .conversion_ready(output_conversion_complete)
    );

    // Clock generation
    initial begin
        system_clock = 1'b0;
        forever #5 system_clock = ~system_clock; // 100MHz clock
    end

    // Test stimulus
    initial begin
        // Initialize VCD dump
        $dumpfile("color_converter_testbench.vcd");
        $dumpvars(0, color_converter_testbench);
        
        // Initialize signals
        reset_signal = 1'b0;
        conversion_trigger = 1'b0;
        input_red_value = 8'h0;
        input_green_value = 8'h0;
        input_blue_value = 8'h0;
        
        // Display test header
        $display();
        $display("=== RGB to HSV Color Space Converter Test ===");
        $display();
        
        // Reset sequence
        #10 reset_signal = 1'b1;
        #20;
        
        // Test Case 1: Pure Red (255, 0, 0)
        $display("Test 1: Converting Pure Red RGB(255, 0, 0)");
        input_red_value = 8'd255;
        input_green_value = 8'd0;
        input_blue_value = 8'd0;
        conversion_trigger = 1'b1;
        #10;
        
        // Wait for conversion to complete
        wait(output_conversion_complete);
        #10;
        $display("  Result: H=%d, S=%d, V=%d", 
                output_hue_degrees, output_saturation_percent, 
                output_value_brightness);
        
        conversion_trigger = 1'b0;
        #20;
        
        // Test Case 2: Pure Green (0, 255, 0)
        $display("Test 2: Converting Pure Green RGB(0, 255, 0)");
        input_red_value = 8'd0;
        input_green_value = 8'd255;
        input_blue_value = 8'd0;
        conversion_trigger = 1'b1;
        #10;
        
        wait(output_conversion_complete);
        #10;
        $display("  Result: H=%d, S=%d, V=%d", 
                output_hue_degrees, output_saturation_percent, 
                output_value_brightness);
        
        conversion_trigger = 1'b0;
        #20;
        
        // Test Case 3: Pure Blue (0, 0, 255)
        $display("Test 3: Converting Pure Blue RGB(0, 0, 255)");
        input_red_value = 8'd0;
        input_green_value = 8'd0;
        input_blue_value = 8'd255;
        conversion_trigger = 1'b1;
        #10;
        
        wait(output_conversion_complete);
        #10;
        $display("  Result: H=%d, S=%d, V=%d", 
                output_hue_degrees, output_saturation_percent, 
                output_value_brightness);
        
        conversion_trigger = 1'b0;
        #20;
        
        // Test Case 4: White (255, 255, 255)
        $display("Test 4: Converting White RGB(255, 255, 255)");
        input_red_value = 8'd255;
        input_green_value = 8'd255;
        input_blue_value = 8'd255;
        conversion_trigger = 1'b1;
        #10;
        
        wait(output_conversion_complete);
        #10;
        $display("  Result: H=%d, S=%d, V=%d", 
                output_hue_degrees, output_saturation_percent, 
                output_value_brightness);
        
        conversion_trigger = 1'b0;
        #20;
        
        // Test Case 5: Gray (128, 128, 128)
        $display("Test 5: Converting Gray RGB(128, 128, 128)");
        input_red_value = 8'd128;
        input_green_value = 8'd128;
        input_blue_value = 8'd128;
        conversion_trigger = 1'b1;
        #10;
        
        wait(output_conversion_complete);
        #10;
        $display("  Result: H=%d, S=%d, V=%d", 
                output_hue_degrees, output_saturation_percent, 
                output_value_brightness);
        
        conversion_trigger = 1'b0;
        #20;
        
        $display();
        $display("=== Color Space Conversion Tests Complete ===");
        $display();
        
        $finish;
    end

    // Monitor for debugging
    initial begin
        $monitor("Time=%0t: RGB(%d,%d,%d) -> HSV(%d,%d,%d) Ready=%b", 
                $time, input_red_value, input_green_value, input_blue_value,
                output_hue_degrees, output_saturation_percent, 
                output_value_brightness, output_conversion_complete);
    end

endmodule