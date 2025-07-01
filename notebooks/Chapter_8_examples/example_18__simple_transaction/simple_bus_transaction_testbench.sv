// simple_bus_transaction_testbench.sv
// Testbench for simple bus transaction example

module simple_bus_transaction_testbench;
  
  // Clock and reset generation
  logic clk;
  logic reset_n;
  
  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns period clock
  end
  
  // Reset generation
  initial begin
    reset_n = 0;
    #25 reset_n = 1;
  end
  
  // Bus interface instance
  simple_bus_interface bus_if();
  
  // Simple slave ready signal generation
  initial begin
    bus_if.ready = 0;
    #50 bus_if.ready = 1;
    #20 bus_if.ready = 0;
    #30 bus_if.ready = 1;
  end
  
  // DUT instantiation
  simple_bus_master dut (
    .clk(clk),
    .reset_n(reset_n),
    .bus_if(bus_if.master)
  );
  
  // Transaction objects for testing
  simple_bus_transaction original_trans;
  simple_bus_transaction copied_trans;
  simple_bus_transaction compare_trans;
  
  // Main test sequence
  initial begin
    // Dump waves
    $dumpfile("simple_bus_transaction_testbench.vcd");
    $dumpvars(0, simple_bus_transaction_testbench);
    
    $display("=== Simple Bus Transaction Example ===");
    $display();
    
    // Wait for reset deassertion
    wait(reset_n);
    #10;
    
    // Create and configure original transaction
    original_trans = new();
    original_trans.address = 32'h1000_BEEF;
    original_trans.data = 32'hDEAD_CAFE;
    original_trans.write_enable = 1'b1;
    original_trans.valid = 1'b1;
    
    $display("Original transaction created:");
    original_trans.display("ORIG");
    
    // Test copy function
    copied_trans = original_trans.copy();
    $display("Copied transaction:");
    copied_trans.display("COPY");
    
    // Test compare function - should match
    if (original_trans.compare(copied_trans)) begin
      $display("Copy comparison: PASSED - Transactions match");
    end else begin
      $display("Copy comparison: FAILED - Transactions don't match");
    end
    $display();
    
    // Create different transaction for comparison test
    compare_trans = new();
    compare_trans.address = 32'h2000_BEEF;  // Different address
    compare_trans.data = 32'hDEAD_CAFE;
    compare_trans.write_enable = 1'b1;
    compare_trans.valid = 1'b1;
    
    $display("Different transaction for comparison:");
    compare_trans.display("DIFF");
    
    // Test compare function - should not match
    if (!original_trans.compare(compare_trans)) begin
      $display("Different comparison: PASSED - Transactions differ");
    end else begin
      $display("Different comparison: FAILED - Should not match");
    end
    $display();
    
    // Test randomization
    $display("Testing transaction randomization:");
    repeat (3) begin
      int rand_result;
      rand_result = original_trans.randomize();
      if (rand_result == 0) begin
        $display("Warning: Randomization failed");
      end
      original_trans.display("RAND");
    end
    
    // Monitor bus interface activity
    $display("Monitoring bus interface activity:");
    fork
      // Monitor bus signals
      begin
        forever begin
          @(posedge clk);
          if (bus_if.valid && bus_if.ready) begin
            $display("Bus Transaction Detected:");
            $display("  Time: %0t", $time);
            $display("  Addr: 0x%08h", bus_if.address);
            $display("  Data: 0x%08h", bus_if.data);
            $display("  Write: %b", bus_if.write_enable);
            $display();
          end
        end
      end
      
      // Test timeout
      begin
        #200;
      end
    join_any
    
    $display("=== Test Complete ===");
    $finish;
  end
  
  // Optional: Monitor all bus activity
  always @(posedge clk) begin
    if (bus_if.valid) begin
      $display("Time %0t: Bus Active - Addr:0x%h Data:0x%h WE:%b Ready:%b", 
               $time, bus_if.address, bus_if.data, 
               bus_if.write_enable, bus_if.ready);
    end
  end
  
endmodule