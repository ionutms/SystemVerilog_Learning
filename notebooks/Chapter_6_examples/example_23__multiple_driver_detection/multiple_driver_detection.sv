// multiple_driver_detection.sv
// Demonstrates multiple driver scenarios and resolution methods
// NOTE: This example simulates multiple driver problems without actually 
// creating them (to avoid compiler errors), but shows the concepts

module multiple_driver_detection (
  input  logic clk,
  input  logic rst_n,
  input  logic enable_a,
  input  logic enable_b,
  input  logic data_a,
  input  logic data_b,
  output logic output_contested,    // Simulates contested behavior
  output logic output_resolved,     // Properly resolved (GOOD)
  output logic output_tristate      // Using tri-state logic (GOOD)
);

  // BAD EXAMPLE: Simulated multiple driver behavior
  // In real code, this would be separate always blocks causing conflicts
  logic driver_a_active, driver_b_active;
  
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      driver_a_active <= 1'b0;
    end else if (enable_a) begin
      driver_a_active <= data_a;
    end
  end
  
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      driver_b_active <= 1'b0;
    end else if (enable_b) begin
      driver_b_active <= data_b;
    end
  end
  
  // PROBLEMATIC: This simulates contested behavior without actual multiple drivers
  // In real hardware, this would be multiple always blocks (which causes warnings)
  always_comb begin
    if (enable_a && driver_a_active && !(enable_b && driver_b_active)) begin
      output_contested = data_a;  // Driver A wins when only A active
    end else if (enable_b && driver_b_active && !(enable_a && driver_a_active)) begin
      output_contested = data_b;  // Driver B wins when only B active
    end else if (enable_a && driver_a_active && enable_b && driver_b_active) begin
      output_contested = 1'bx;    // Simulate conflict with X
    end else begin
      output_contested = 1'b0;    // Default value
    end
  end

  // GOOD EXAMPLE: Properly resolved using priority logic
  always_comb begin
    if (enable_a && driver_a_active) begin
      output_resolved = data_a;     // Driver A has priority
    end else if (enable_b && driver_b_active) begin
      output_resolved = data_b;     // Driver B is secondary
    end else begin
      output_resolved = 1'b0;       // Default value
    end
  end

  // GOOD EXAMPLE: Using tri-state logic
  logic tri_a, tri_b;
  
  assign tri_a = (enable_a && driver_a_active) ? data_a : 1'bz;
  assign tri_b = (enable_b && driver_b_active) ? data_b : 1'bz;
  assign output_tristate = tri_a | tri_b;  // Wired-OR resolution

endmodule


// Additional module showing bus contention scenarios
module bus_contention_demo (
  input  logic clk,
  input  logic rst_n,
  input  logic [1:0] select,
  input  logic [7:0] data_source_0,
  input  logic [7:0] data_source_1,
  input  logic [7:0] data_source_2,
  output logic [7:0] bus_contested,
  output logic [7:0] bus_resolved
);

  /* 
   * EDUCATIONAL NOTE: 
   * In real problematic code, bus_contested would be driven by multiple
   * always blocks like this (which creates compiler warnings):
   * 
   * always_comb begin
   *   if (select == 2'b00) bus_contested = data_source_0;
   *   else bus_contested = 8'hzz;
   * end
   * 
   * always_comb begin  // <-- This creates multiple drivers!
   *   if (select == 2'b01) bus_contested = data_source_1;
   *   else bus_contested = 8'hzz;
   * end
   * 
   * We simulate this behavior below without actual multiple drivers
   */

  // BAD: Simulated multiple drivers on bus (demonstrates contention)
  always_comb begin
    if (select == 2'b00) begin
      bus_contested = data_source_0;
    end else if (select == 2'b01) begin
      bus_contested = data_source_1;
    end else if (select == 2'b10) begin
      bus_contested = data_source_2;
    end else if (select == 2'b11) begin
      // Simulate contention with invalid select
      bus_contested = 8'hxx;  // Show X to represent bus fight
    end else begin
      bus_contested = 8'hzz;
    end
  end

  // GOOD: Single driver with proper multiplexing
  always_comb begin
    case (select)
      2'b00:   bus_resolved = data_source_0;
      2'b01:   bus_resolved = data_source_1;
      2'b10:   bus_resolved = data_source_2;
      default: bus_resolved = 8'h00;
    endcase
  end

  // Monitor for bus contention
  always @(bus_contested) begin
    if (^bus_contested === 1'bx) begin
      $display("WARNING: Bus contention detected at time %0t - value is X", $time);
    end
  end

endmodule