// counter_with_enable_testbench.sv - Simplified Output Version
module counter_testbench;

  // Clock and reset signals
  logic       clk;
  logic       reset_n;
  logic       enable;
  logic [3:0] count;

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns clock period (100MHz)
  end

  // Instantiate design under test
  counter_with_enable counter_dut (
    .clk(clk),
    .reset_n(reset_n),
    .enable(enable),
    .count(count)
  );

  // Clocking block
  clocking cb @(posedge clk);
    default input #1step output #2ns;
    output reset_n;   
    output enable;    
    input  count;     
  endclocking

  // Simplified signal driving task
  task drive_signals(input logic rst_val, input logic en_val);
    @(posedge clk);
    #2ns;
    reset_n = rst_val;
    enable = en_val;
  endtask

  // Test sequence
  initial begin
    // Initialize VCD dump
    $dumpfile("counter_testbench.vcd");
    $dumpvars(0, counter_testbench);
    
    $display("Starting Counter Test");
    
    // Initialize
    reset_n = 1'b0;
    enable = 1'b0;
    repeat(2) @(posedge clk);
    
    // Release reset
    $display("Reset released");
    drive_signals(1'b1, 1'b0);
    repeat(2) @(posedge clk);
    
    // Test enable=0
    $display("Testing enable=0");
    drive_signals(1'b1, 1'b0);
    repeat(4) @(posedge clk);
    
    // Test enable=1
    $display("Testing enable=1 - counting");
    drive_signals(1'b1, 1'b1);
    repeat(8) @(posedge clk);
    
    // Test reset during counting
    $display("Reset during count");
    drive_signals(1'b0, 1'b1);
    repeat(2) @(posedge clk);
    
    // Continue counting
    drive_signals(1'b1, 1'b1);
    repeat(6) @(posedge clk);
    
    // Disable counter
    $display("Counter disabled");
    drive_signals(1'b1, 1'b0);
    repeat(4) @(posedge clk);
    
    $display("Test completed");
    $finish;
  end

endmodule