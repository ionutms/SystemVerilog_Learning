// clocked_processor_interface_testbench.sv
module clocked_processor_interface_testbench;
  
  // Clock and reset
  logic clk;
  logic rst_n;
  
  // Interface signals
  logic [7:0] data_in;
  logic       valid_in;
  logic [7:0] data_out;
  logic       valid_out;
  logic       ready;

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns period
  end

  // Clocking block for driving inputs (setup before clock edge)
  clocking driver_cb @(posedge clk);
    default input #1step output #2ns;  // Input skew 1 step, output skew 2ns
    output data_in;
    output valid_in;
    input  ready;
  endclocking

  // Clocking block for monitoring outputs (sample after clock edge)
  clocking monitor_cb @(posedge clk);
    default input #3ns;  // Sample 3ns after clock edge
    input data_out;
    input valid_out;
    input ready;
  endclocking

  // Instantiate design under test
  clocked_processor_interface dut(
    .clk(clk),
    .rst_n(rst_n),
    .data_in(data_in),
    .valid_in(valid_in),
    .data_out(data_out),
    .valid_out(valid_out),
    .ready(ready)
  );

  // Test sequence
  initial begin
    // Dump waves
    $dumpfile("clocked_processor_interface_testbench.vcd");
    $dumpvars(0, clocked_processor_interface_testbench);
    
    $display("Starting clocked processor interface test");
    
    // Initialize signals
    rst_n = 0;
    data_in = 8'h00;
    valid_in = 0;
    
    // Reset sequence
    repeat(3) @(posedge clk);
    rst_n = 1;
    $display("Reset released at time %0t", $time);
    
    // Wait for ready
    wait(ready);
    
    // Test case 1: Send data 0x05
    @(driver_cb);
    driver_cb.data_in <= 8'h05;
    driver_cb.valid_in <= 1'b1;
    $display("Sending data 0x05 at time %0t", $time);
    
    @(driver_cb);
    driver_cb.valid_in <= 1'b0;
    
    // Wait for output and check
    @(monitor_cb iff monitor_cb.valid_out);
    $display("Received data 0x%02h at time %0t (expected 0x0A)", monitor_cb.data_out, $time);
    
    // Test case 2: Send data 0x0F
    wait(monitor_cb.ready);
    @(driver_cb);
    driver_cb.data_in <= 8'h0F;
    driver_cb.valid_in <= 1'b1;
    $display("Sending data 0x0F at time %0t", $time);
    
    @(driver_cb);
    driver_cb.valid_in <= 1'b0;
    
    // Wait for output and check
    @(monitor_cb iff monitor_cb.valid_out);
    $display("Received data 0x%02h at time %0t (expected 0x1E)", monitor_cb.data_out, $time);
    
    // Test case 3: Send data 0x80 (test overflow)
    wait(monitor_cb.ready);
    @(driver_cb);
    driver_cb.data_in <= 8'h80;
    driver_cb.valid_in <= 1'b1;
    $display("Sending data 0x80 at time %0t", $time);
    
    @(driver_cb);
    driver_cb.valid_in <= 1'b0;
    
    // Wait for output and check
    @(monitor_cb iff monitor_cb.valid_out);
    $display("Received data 0x%02h at time %0t (expected 0x00 due to overflow)", monitor_cb.data_out, $time);
    
    // Wait a few more cycles
    repeat(5) @(posedge clk);
    
    $display("Clocked processor interface test completed at time %0t", $time);
    $finish;
  end

  // Timeout watchdog
  initial begin
    #1000ns;
    $display("ERROR: Test timeout!");
    $finish;
  end

endmodule