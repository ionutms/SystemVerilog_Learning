// clock_domain_crossing_testbench.sv
module clock_domain_crossing_testbench;

  // Clock and reset signals
  logic clk_a, clk_b;
  logic rst_a_n, rst_b_n;
  
  // Test signals for basic CDC
  logic data_a;
  logic data_b_sync, data_b_unsafe;
  
  // Test signals for handshake CDC
  logic send_req, ready, data_valid;
  logic [7:0] data_in, data_out;
  
  // Instantiate basic clock domain crossing
  clock_domain_crossing BASIC_CDC (
    .clk_a(clk_a),
    .rst_a_n(rst_a_n),
    .data_a(data_a),
    .clk_b(clk_b),
    .rst_b_n(rst_b_n),
    .data_b_sync(data_b_sync),
    .data_b_unsafe(data_b_unsafe)
  );
  
  // Instantiate handshake CDC
  cdc_handshake HANDSHAKE_CDC (
    .clk_a(clk_a),
    .rst_a_n(rst_a_n),
    .send_req(send_req),
    .data_in(data_in),
    .ready(ready),
    .clk_b(clk_b),
    .rst_b_n(rst_b_n),
    .data_valid(data_valid),
    .data_out(data_out)
  );

  // Generate Clock A (100 MHz)
  initial begin
    clk_a = 0;
    forever #5 clk_a = ~clk_a;  // 10ns period
  end
  
  // Generate Clock B (67 MHz - different frequency)
  initial begin
    clk_b = 0;
    forever #7.5 clk_b = ~clk_b;  // 15ns period
  end
  
  // Reset generation
  initial begin
    rst_a_n = 0;
    rst_b_n = 0;
    #20;
    rst_a_n = 1;
    rst_b_n = 1;
  end

  // Test stimulus
  initial begin
    // Setup waveform dumping
    $dumpfile("clock_domain_crossing_testbench.vcd");
    $dumpvars(0, clock_domain_crossing_testbench);
    
    $display("Clock Domain Crossing Demonstration");
    $display("==================================");
    
    // Initialize signals
    data_a = 1'b0;
    send_req = 1'b0;
    data_in = 8'h00;
    
    // Wait for reset deassertion
    wait(rst_a_n && rst_b_n);
    #30;
    
    $display("\n--- Basic 2-FF Synchronizer Test ---");
    
    // Test basic synchronizer with various data patterns
    @(posedge clk_a);
    data_a = 1'b1;
    $display("Time %0t: Data_A changed to %b", $time, data_a);
    
    // Wait to see synchronization
    repeat(10) @(posedge clk_b);
    $display("Time %0t: Data_B_sync = %b, Data_B_unsafe = %b", 
             $time, data_b_sync, data_b_unsafe);
    
    // Change data back to 0
    @(posedge clk_a);
    data_a = 1'b0;
    $display("Time %0t: Data_A changed to %b", $time, data_a);
    
    repeat(10) @(posedge clk_b);
    $display("Time %0t: Data_B_sync = %b, Data_B_unsafe = %b", 
             $time, data_b_sync, data_b_unsafe);
    
    $display("\n--- Handshake Protocol Test ---");
    
    // Test handshake CDC with multiple data transfers
    for (int i = 1; i <= 5; i++) begin
      // Wait for ready
      wait(ready);
      @(posedge clk_a);
      
      data_in = 8'(8'h10 * i);  // Test data: 0x10, 0x20, 0x30, etc.
      send_req = 1'b1;
      $display("Time %0t: Sending data 0x%02X", $time, data_in);
      
      @(posedge clk_a);
      send_req = 1'b0;
      
      // Wait for data to be received
      wait(data_valid);
      @(posedge clk_b);
      $display("Time %0t: Received data 0x%02X", $time, data_out);
      
      // Small delay between transfers
      #50;
    end
    
    $display("\n--- Race Condition Demonstration ---");
    
    // Show what happens with rapid changes
    repeat(20) begin
      @(posedge clk_a);
      data_a = ~data_a;
      #1;  // Very short pulse - might cause issues
    end
    
    #100;
    
    $display("\n==================================");
    $display("Key observations:");
    $display("1. 2-FF synchronizer adds 2 clock cycle latency");
    $display("2. Handshake protocol ensures reliable data transfer");
    $display("3. Unsafe crossing can cause metastability");
    $display("4. Different clock frequencies require careful design");
    $display("Simulation complete - Check VCD for timing details");
    
    $finish;
  end
  
  // Monitor for demonstration purposes
  always @(posedge clk_b) begin
    if (data_b_sync !== data_b_unsafe) begin
      $display("Time %0t: NOTICE - Sync vs Unsafe difference: sync=%b, unsafe=%b", 
               $time, data_b_sync, data_b_unsafe);
    end
  end

endmodule