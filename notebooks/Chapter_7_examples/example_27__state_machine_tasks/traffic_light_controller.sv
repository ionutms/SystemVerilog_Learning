// traffic_light_controller.sv
module traffic_light_controller (
  input  logic clock_signal,
  input  logic reset_signal,
  input  logic pedestrian_button_pressed,
  output logic red_light_active,
  output logic yellow_light_active,
  output logic green_light_active
);

  // State definitions
  typedef enum logic [2:0] {
    IDLE_STATE           = 3'b000,
    GREEN_ACTIVE_STATE   = 3'b001,
    YELLOW_ACTIVE_STATE  = 3'b010,
    RED_ACTIVE_STATE     = 3'b011,
    PEDESTRIAN_STATE     = 3'b100
  } traffic_state_type;

  // State machine variables
  traffic_state_type current_state, next_state;
  logic [3:0] timer_counter;
  logic pedestrian_crossing_requested;

  // State machine task to update complex state structure
  task update_traffic_state_machine(
    input traffic_state_type new_state,
    input logic [3:0] timer_value,
    input logic pedestrian_request
  );
    begin
      current_state = new_state;
      timer_counter = timer_value;
      pedestrian_crossing_requested = pedestrian_request;
      
      // Update output lights based on state
      case (current_state)
        IDLE_STATE: begin
          red_light_active = 1'b1;
          yellow_light_active = 1'b0;
          green_light_active = 1'b0;
        end
        GREEN_ACTIVE_STATE: begin
          red_light_active = 1'b0;
          yellow_light_active = 1'b0;
          green_light_active = 1'b1;
        end
        YELLOW_ACTIVE_STATE: begin
          red_light_active = 1'b0;
          yellow_light_active = 1'b1;
          green_light_active = 1'b0;
        end
        RED_ACTIVE_STATE, PEDESTRIAN_STATE: begin
          red_light_active = 1'b1;
          yellow_light_active = 1'b0;
          green_light_active = 1'b0;
        end
        default: begin
          red_light_active = 1'b1;
          yellow_light_active = 1'b0;
          green_light_active = 1'b0;
        end
      endcase
    end
  endtask

  // Initialize state machine
  initial begin
    update_traffic_state_machine(IDLE_STATE, 4'b0000, 1'b0);
  end

  // State machine clock process
  always @(posedge clock_signal or posedge reset_signal) begin
    if (reset_signal) begin
      update_traffic_state_machine(IDLE_STATE, 4'b0000, 1'b0);
    end else begin
      // Update pedestrian request
      if (pedestrian_button_pressed) 
        pedestrian_crossing_requested = 1'b1;

      // State transitions with timer
      case (current_state)
        IDLE_STATE: begin
          update_traffic_state_machine(GREEN_ACTIVE_STATE, 4'b0000, 
                                     pedestrian_crossing_requested);
        end
        
        GREEN_ACTIVE_STATE: begin
          if (timer_counter >= 4'd5) begin
            if (pedestrian_crossing_requested)
              update_traffic_state_machine(YELLOW_ACTIVE_STATE, 4'b0000, 
                                         pedestrian_crossing_requested);
            else
              update_traffic_state_machine(GREEN_ACTIVE_STATE, 4'b0000, 
                                         pedestrian_crossing_requested);
          end else begin
            update_traffic_state_machine(GREEN_ACTIVE_STATE, 
                                       timer_counter + 1'b1, 
                                       pedestrian_crossing_requested);
          end
        end
        
        YELLOW_ACTIVE_STATE: begin
          if (timer_counter >= 4'd2) begin
            if (pedestrian_crossing_requested)
              update_traffic_state_machine(PEDESTRIAN_STATE, 4'b0000, 1'b1);
            else
              update_traffic_state_machine(RED_ACTIVE_STATE, 4'b0000, 1'b0);
          end else begin
            update_traffic_state_machine(YELLOW_ACTIVE_STATE, 
                                       timer_counter + 1'b1, 
                                       pedestrian_crossing_requested);
          end
        end
        
        RED_ACTIVE_STATE: begin
          if (timer_counter >= 4'd3) begin
            update_traffic_state_machine(GREEN_ACTIVE_STATE, 4'b0000, 1'b0);
          end else begin
            update_traffic_state_machine(RED_ACTIVE_STATE, 
                                       timer_counter + 1'b1, 
                                       pedestrian_crossing_requested);
          end
        end
        
        PEDESTRIAN_STATE: begin
          if (timer_counter >= 4'd4) begin
            update_traffic_state_machine(GREEN_ACTIVE_STATE, 4'b0000, 1'b0);
          end else begin
            update_traffic_state_machine(PEDESTRIAN_STATE, 
                                       timer_counter + 1'b1, 1'b1);
          end
        end
        
        default: begin
          update_traffic_state_machine(IDLE_STATE, 4'b0000, 1'b0);
        end
      endcase
    end
  end

endmodule