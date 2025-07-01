// traffic_light_controller_testbench.sv
module traffic_light_testbench;

  // Testbench signals
  logic clk;
  logic reset_n;
  logic [2:0] light_outputs;

  // Instantiate design under test
  traffic_light_controller TRAFFIC_LIGHT_DUT (
    .clk(clk),
    .reset_n(reset_n),
    .light_outputs(light_outputs)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns period clock
  end

  // Test stimulus
  initial begin
    // Dump waves
    $dumpfile("traffic_light_testbench.vcd");
    $dumpvars(0, traffic_light_testbench);

    // Initialize signals
    reset_n = 0;
    
    $display();
    $display("=== Traffic Light Controller Testbench ===");
    $display("Time\tReset\tState\tRED\tYELLOW\tGREEN");
    $display("----\t-----\t-----\t---\t------\t-----");

    // Apply reset
    #20 reset_n = 1;
    
    // Monitor traffic light states
    repeat (200) begin
      @(posedge clk);
      $display("%4t\t%b\t%s\t%b\t%b\t%b", 
               $time, reset_n, 
               get_state_name(TRAFFIC_LIGHT_DUT.current_state),
               light_outputs[2], light_outputs[1], light_outputs[0]);
    end

    $display();
    $display("Traffic light simulation completed successfully!");
    $display();
    $finish;
  end

  // Function to convert state enum to string for display
  function string get_state_name(logic [1:0] state);
    case (state)
      2'b00: return "RED   ";
      2'b01: return "YELLOW";
      2'b10: return "GREEN ";
      default: return "UNKNWN";
    endcase
  endfunction

  // Monitor state changes
  always @(posedge clk) begin
    if (reset_n && TRAFFIC_LIGHT_DUT.current_state != 
        TRAFFIC_LIGHT_DUT.next_state) begin
      $display("State transition: %s -> %s at time %t",
               get_state_name(TRAFFIC_LIGHT_DUT.current_state),
               get_state_name(TRAFFIC_LIGHT_DUT.next_state),
               $time);
    end
  end

endmodule