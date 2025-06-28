// color_space_converter.sv
module rgb_to_hsv_converter (
    input  logic        clk,
    input  logic        reset_n,
    input  logic        convert_enable,
    input  logic [7:0]  red_channel,
    input  logic [7:0]  green_channel,
    input  logic [7:0]  blue_channel,
    output logic [8:0]  hue_output,        // 0-359 degrees
    output logic [7:0]  saturation_output, // 0-255 (0-100%)
    output logic [7:0]  value_output,      // 0-255 (0-100%)
    output logic        conversion_ready
);

    // Internal registers for RGB values
    logic [7:0] rgb_max, rgb_min, rgb_delta;
    logic [7:0] red_reg, green_reg, blue_reg;
    
    // State machine for conversion process
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        CALCULATE = 2'b01,
        READY = 2'b10
    } converter_state_t;
    
    converter_state_t current_state, next_state;

    // Find maximum and minimum RGB values
    always_comb begin
        rgb_max = (red_reg >= green_reg) ? 
                  ((red_reg >= blue_reg) ? red_reg : blue_reg) :
                  ((green_reg >= blue_reg) ? green_reg : blue_reg);
        
        rgb_min = (red_reg <= green_reg) ? 
                  ((red_reg <= blue_reg) ? red_reg : blue_reg) :
                  ((green_reg <= blue_reg) ? green_reg : blue_reg);
        
        rgb_delta = rgb_max - rgb_min;
    end

    // State machine sequential logic
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= IDLE;
            red_reg <= 8'h0;
            green_reg <= 8'h0;
            blue_reg <= 8'h0;
        end else begin
            current_state <= next_state;
            if (convert_enable && current_state == IDLE) begin
                red_reg <= red_channel;
                green_reg <= green_channel;
                blue_reg <= blue_channel;
            end
        end
    end

    // State machine combinational logic
    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (convert_enable)
                    next_state = CALCULATE;
            end
            CALCULATE: begin
                next_state = READY;
            end
            READY: begin
                if (!convert_enable)
                    next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // HSV calculation (simplified for demonstration)
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            hue_output <= 9'h0;
            saturation_output <= 8'h0;
            value_output <= 8'h0;
            conversion_ready <= 1'b0;
        end else begin
            case (current_state)
                CALCULATE: begin
                    // Value is simply the maximum RGB component
                    value_output <= rgb_max;
                    
                    // Saturation calculation
                    if (rgb_max == 0)
                        saturation_output <= 8'h0;
                    else
                        saturation_output <= (rgb_delta * 8'd255) / rgb_max;
                    
                    // Simplified hue calculation (demonstration only)
                    if (rgb_delta == 0) begin
                        hue_output <= 9'h0;  // Undefined, set to 0
                    end else if (rgb_max == red_reg) begin
                        hue_output <= 9'd60;  // Red dominant - simplified
                    end else if (rgb_max == green_reg) begin
                        hue_output <= 9'd120; // Green dominant - simplified
                    end else begin
                        hue_output <= 9'd240; // Blue dominant - simplified
                    end
                    
                    conversion_ready <= 1'b1;
                end
                IDLE: begin
                    conversion_ready <= 1'b0;
                end
                READY: begin
                    // Maintain current values
                end
                default: begin
                    hue_output <= 9'h0;
                    saturation_output <= 8'h0;
                    value_output <= 8'h0;
                    conversion_ready <= 1'b0;
                end
            endcase
        end
    end

endmodule