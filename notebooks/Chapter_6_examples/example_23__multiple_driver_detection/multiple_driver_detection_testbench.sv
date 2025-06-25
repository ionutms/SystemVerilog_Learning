// multiple_driver_detection_testbench.sv
module multiple_driver_detection_testbench;

  // Clock and reset
  logic clk, rst_n;
  
  // Test signals for main module
  logic enable_a, enable_b;
  logic data_a, data_b;
  logic output_contested, output_resolved, output_tristate;
  
  // Test signals for bus contention demo
  logic [1:0] select;
  logic [7:0] data_source_0, data_source_1, data_source_2;
  logic [7:0] bus_contested, bus_resolved;
  
  // Instantiate main multiple driver detection module
  multiple_driver_detection MAIN_DUT (
    .clk(clk),
    .rst_n(rst_n),
    .enable_a(enable_a),
    .enable_b(enable_b),
    .data_a(data_a),
    .data_b(data_b),
    .output_contested(output_contested),
    .output_resolved(output_resolved),
    .output_tristate(output_tristate)
  );
  
  // Instantiate bus contention demo
  bus_contention_demo BUS_DEMO (
    .clk(clk),
    .rst_n(rst_n),
    .select(select),
    .data_source_0(data_source_0),
    .data_source_1(data_source_1),
    .data_source_2(data_source_2),
    .bus_contested(bus_contested),
    .bus_resolved(bus_resolved)
  );

  // Generate clock (50 MHz)
  initial begin
    clk = 0;
    forever #10 clk = ~clk;  // 20ns period
  end
  
  // Reset generation
  initial begin
    rst_n = 0;
    #25;
    rst_n = 1;
  end

  // Test stimulus
  initial begin
    // Setup waveform dumping
    $dumpfile("multiple_driver_detection_testbench.vcd");
    $dumpvars(0, multiple_driver_detection_testbench);
    
    $display("Multiple Driver Detection Demonstration");
    $display("======================================");
    
    // Initialize signals
    enable_a = 0;
    enable_b = 0;
    data_a = 0;
    data_b = 0;
    select = 2'b00;
    data_source_0 = 8'hAA;
    data_source_1 = 8'hBB;
    data_source_2 = 8'hCC;
    
    // Wait for reset
    wait(rst_n);
    repeat(2) @(posedge clk);
    
    $display("\n--- Single Driver Test (No Conflict) ---");
    
    // Test with only one driver active
    data_a = 1'b1;
    enable_a = 1'b1;
    repeat(3) @(posedge clk);
    
    $display("Time %0t: Only A enabled - Contested=%b, Resolved=%b, Tristate=%b", 
             $time, output_contested, output_resolved, output_tristate);
    
    enable_a = 1'b0;
    data_b = 1'b1;
    enable_b = 1'b1;
    repeat(3) @(posedge clk);
    
    $display("Time %0t: Only B enabled - Contested=%b, Resolved=%b, Tristate=%b", 
             $time, output_contested, output_resolved, output_tristate);
    
    $display("\n--- Multiple Driver Conflict Test ---");
    
    // Create the problematic scenario: both drivers active
    data_a = 1'b1;
    data_b = 1'b0;
    enable_a = 1'b1;
    enable_b = 1'b1;
    
    repeat(3) @(posedge clk);
    
    $display("Time %0t: BOTH drivers active!", $time);
    $display("  Data A = %b, Data B = %b", data_a, data_b);
    $display("  Contested output = %b (undefined behavior!)", output_contested);
    $display("  Resolved output = %b (A has priority)", output_resolved);
    $display("  Tristate output = %b (wired-OR)", output_tristate);
    
    // Try opposite data values
    data_a = 1'b0;
    data_b = 1'b1;
    repeat(3) @(posedge clk);
    
    $display("Time %0t: Opposite data values", $time);
    $display("  Data A = %b, Data B = %b", data_a, data_b);
    $display("  Contested output = %b", output_contested);
    $display("  Resolved output = %b (A still has priority)", output_resolved);
    $display("  Tristate output = %b", output_tristate);
    
    $display("\n--- Bus Contention Test ---");
    
    // Test proper bus operation
    select = 2'b00;
    repeat(2) @(posedge clk);
    $display("Time %0t: Select=00, Bus_resolved=0x%02X (should be 0xAA)", 
             $time, bus_resolved);
    
    select = 2'b01;
    repeat(2) @(posedge clk);
    $display("Time %0t: Select=01, Bus_resolved=0x%02X (should be 0xBB)", 
             $time, bus_resolved);
    
    select = 2'b10;
    repeat(2) @(posedge clk);
    $display("Time %0t: Select=10, Bus_resolved=0x%02X (should be 0xCC)", 
             $time, bus_resolved);
    
    // Test invalid select (potential contention in bad design)
    select = 2'b11;
    repeat(2) @(posedge clk);
    $display("Time %0t: Select=11, Bus_resolved=0x%02X (default case)", 
             $time, bus_resolved);
    
    $display("\n--- X-State Propagation Test ---");
    
    // Force X values to show propagation
    force MAIN_DUT.driver_a_active = 1'bx;
    repeat(2) @(posedge clk);
    $display("Time %0t: Forced X in driver - outputs may show X", $time);
    release MAIN_DUT.driver_a_active;
    
    repeat(5) @(posedge clk);
    
    $display("\n======================================");
    $display("Key Observations:");
    $display("1. Multiple drivers create undefined behavior");
    $display("2. Proper resolution uses priority or muxing");
    $display("3. Tri-state logic allows multiple drivers with Z");
    $display("4. Bus contention can cause X propagation");
    $display("5. Always use single-driver design patterns");
    $display("Simulation complete - Check VCD for detailed timing");
    
    $finish;
  end
  
  // Monitor for X states
  always @(output_contested, bus_contested) begin
    if (^output_contested === 1'bx) begin
      $display("ALERT: X detected on contested output at time %0t", $time);
    end
    if (^bus_contested === 1'bx) begin
      $display("ALERT: X detected on contested bus at time %0t", $time);
    end
  end
  
  // Monitor driver conflicts
  always @(posedge clk) begin
    if (enable_a && enable_b && MAIN_DUT.driver_a_active && MAIN_DUT.driver_b_active) begin
      $display("CONFLICT: Both drivers active at time %0t", $time);
    end
  end

endmodule