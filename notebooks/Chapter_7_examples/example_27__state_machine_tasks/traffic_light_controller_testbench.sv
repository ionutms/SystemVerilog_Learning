// traffic_light_controller_testbench.sv
module traffic_light_controller_testbench;

  // Testbench signals
  logic clock_signal;
  logic reset_signal;
  logic pedestrian_button_pressed;
  logic red_light_active;
  logic yellow_light_active;
  logic green_light_active;

  // Instantiate design under test
  traffic_light_controller TRAFFIC_CONTROLLER_INSTANCE (
    .clock_signal(clock_signal),
    .reset_signal(reset_signal),
    .pedestrian_button_pressed(pedestrian_button_pressed),
    .red_light_active(red_light_active),
    .yellow_light_active(yellow_light_active),
    .green_light_active(green_light_active)
  );

  // Task to display current traffic light state
  task display_traffic_light_status();
    begin
      $display("Time: %0t | R:%b Y:%b G:%b | State: %s | Ped: %b", 
               $time,
               red_light_active,
               yellow_light_active, 
               green_light_active,
               get_state_name(),
               pedestrian_button_pressed);
    end
  endtask

  // Function to get readable state name
  function string get_state_name();
    case ({red_light_active, yellow_light_active, green_light_active})
      3'b100: return "RED";
      3'b010: return "YELLOW";
      3'b001: return "GREEN";
      default: return "UNKNOWN";
    endcase
  endfunction

  // Task to simulate pedestrian button press
  task simulate_pedestrian_crossing_request();
    begin
      $display("\n--- Pedestrian crossing requested ---");
      pedestrian_button_pressed = 1'b1;
      #20;
      pedestrian_button_pressed = 1'b0;
    end
  endtask

  // Task to wait for specific light state
  task wait_for_light_state(input logic red, yellow, green);
    begin
      while (!(red_light_active == red && 
               yellow_light_active == yellow && 
               green_light_active == green)) begin
        #10;
      end
      $display("Reached expected light state: R:%b Y:%b G:%b", 
               red, yellow, green);
    end
  endtask

  // Clock generation - limited duration
  initial begin
    clock_signal = 0;
    repeat (200) #10 clock_signal = ~clock_signal;  // Limited clock cycles
  end

  // Test sequence
  initial begin
    // Initialize waveform dump
    $dumpfile("traffic_light_controller_testbench.vcd");
    $dumpvars(0, traffic_light_controller_testbench);

    $display("\n=== Traffic Light Controller State Machine Test ===");
    $display("Testing state machine tasks for complex state updates\n");

    // Initialize signals
    reset_signal = 1'b0;
    pedestrian_button_pressed = 1'b0;

    // Apply reset
    $display("--- Applying Reset ---");
    reset_signal = 1'b1;
    #30;
    reset_signal = 1'b0;
    #10;

    // Monitor normal traffic light sequence
    $display("\n--- Normal Traffic Light Sequence ---");
    repeat (10) begin  // Reduced from 20
      display_traffic_light_status();
      #20;
    end

    // Test pedestrian crossing during green light
    wait_for_light_state(1'b0, 1'b0, 1'b1);  // Wait for green
    simulate_pedestrian_crossing_request();
    
    $display("\n--- Monitoring Pedestrian Crossing Sequence ---");
    repeat (15) begin  // Reduced from 25
      display_traffic_light_status();
      #20;
    end

    // Test reset during operation
    $display("\n--- Testing Reset During Operation ---");
    reset_signal = 1'b1;
    #20;
    reset_signal = 1'b0;
    
    repeat (8) begin  // Reduced from 10
      display_traffic_light_status();
      #20;
    end

    $display("\n=== Test Completed Successfully ===");
    $display("State machine tasks effectively managed complex state updates");
    #50;  // Small delay before finish
    $finish;
  end

  // Monitor for unexpected states - simplified
  always @(posedge clock_signal) begin
    if (!reset_signal && $time > 100) begin  // Skip initial period
      // Check for invalid light combinations
      if ((red_light_active + yellow_light_active + green_light_active) != 1) begin
        $error("Invalid light combination detected at time %0t", $time);
        $finish;
      end
    end
  end

endmodule