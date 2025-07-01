// traffic_light_controller.sv
module traffic_light_controller (
    input logic clk,
    input logic reset_n,
    output logic [2:0] light_outputs  // RED, YELLOW, GREEN
);

  // Define traffic light states using enum
  typedef enum logic [1:0] {
    RED    = 2'b00,
    YELLOW = 2'b01,
    GREEN  = 2'b10
  } traffic_state_t;

  traffic_state_t current_state, next_state;
  logic [3:0] counter;  // Timer counter for state transitions

  // State register
  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      current_state <= RED;
      counter <= 4'b0000;
    end else begin
      current_state <= next_state;
      if (counter == 4'b1111)
        counter <= 4'b0000;
      else
        counter <= counter + 1;
    end
  end

  // Next state logic
  always_comb begin
    next_state = current_state;  // Default: stay in current state
    
    case (current_state)
      RED: begin
        if (counter == 4'b1111)  // Stay in RED for 16 cycles
          next_state = GREEN;
      end
      
      YELLOW: begin
        if (counter == 4'b0111)  // Stay in YELLOW for 8 cycles
          next_state = RED;
      end
      
      GREEN: begin
        if (counter == 4'b1111)  // Stay in GREEN for 16 cycles
          next_state = YELLOW;
      end
      
      default: next_state = RED;
    endcase
  end

  // Output logic
  always_comb begin
    light_outputs = 3'b000;  // All lights off by default
    
    case (current_state)
      RED:    light_outputs = 3'b100;  // Only RED on
      YELLOW: light_outputs = 3'b010;  // Only YELLOW on
      GREEN:  light_outputs = 3'b001;  // Only GREEN on
      default: light_outputs = 3'b100; // Default to RED
    endcase
  end

  // Display current state for debugging
  initial begin
    $display("Traffic Light Controller initialized");
    $display("State encoding: RED=00, YELLOW=01, GREEN=10");
  end

endmodule