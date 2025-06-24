// traffic_light_controller.sv
module traffic_light_controller (
    input  logic clk,
    input  logic reset,
    output logic red_light,
    output logic yellow_light,
    output logic green_light
);

    // State enumeration
    typedef enum logic [1:0] {
        RED    = 2'b00,
        GREEN  = 2'b01,
        YELLOW = 2'b10
    } traffic_state_t;

    traffic_state_t current_state, next_state;
    
    // Timer counter for state duration
    logic [3:0] timer_count;
    
    // State timing parameters (in clock cycles)
    parameter RED_TIME    = 4'd8;  // Red light duration
    parameter GREEN_TIME  = 4'd6;  // Green light duration  
    parameter YELLOW_TIME = 4'd2;  // Yellow light duration

    // State register
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= RED;
            timer_count <= 4'd0;
        end else begin
            current_state <= next_state;
            if (next_state != current_state) begin
                timer_count <= 4'd0;  // Reset timer on state change
            end else begin
                timer_count <= timer_count + 1;
            end
        end
    end

    // Next state logic
    always_comb begin
        next_state = current_state;  // Default: stay in current state
        
        case (current_state)
            RED: begin
                if (timer_count >= RED_TIME - 1) begin
                    next_state = GREEN;
                end
            end
            
            GREEN: begin
                if (timer_count >= GREEN_TIME - 1) begin
                    next_state = YELLOW;
                end
            end
            
            YELLOW: begin
                if (timer_count >= YELLOW_TIME - 1) begin
                    next_state = RED;
                end
            end
            
            default: next_state = RED;
        endcase
    end

    // Output logic
    always_comb begin
        red_light    = (current_state == RED);
        green_light  = (current_state == GREEN);
        yellow_light = (current_state == YELLOW);
    end

    // Display state changes for debugging
    always_ff @(posedge clk) begin
        if (next_state != current_state) begin
            case (next_state)
                RED:    $display("Time %0t: Traffic Light -> RED", $time);
                GREEN:  $display("Time %0t: Traffic Light -> GREEN", $time);
                YELLOW: $display("Time %0t: Traffic Light -> YELLOW", $time);
                default: $display("Time %0t: Traffic Light -> UNKNOWN STATE", $time);
            endcase
        end
    end

endmodule