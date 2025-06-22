// axi4_lite_memory_testbench.sv
// Simple testbench for AXI4-Lite Memory

module axi4_lite_memory_testbench;

  logic clk, rst_n;
  
  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Interface instance
  axi4_lite_if axi_bus (clk, rst_n);

  // Memory slave instance
  axi4_lite_memory_slave memory_slave (.axi_bus(axi_bus.slave));

  // Simple Monitor
  always @(posedge axi_bus.clk) begin
    // Monitor writes
    if (axi_bus.awvalid && axi_bus.awready) begin
      $display("MONITOR: Write Address = 0x%08h", axi_bus.awaddr);
    end
    if (axi_bus.wvalid && axi_bus.wready) begin
      $display("MONITOR: Write Data = 0x%08h", axi_bus.wdata);
    end
    if (axi_bus.bvalid && axi_bus.bready) begin
      $display("MONITOR: Write Response = %s", (axi_bus.bresp == 2'b00) ? "OK" : "ERROR");
    end
    
    // Monitor reads
    if (axi_bus.arvalid && axi_bus.arready) begin
      $display("MONITOR: Read Address = 0x%08h", axi_bus.araddr);
    end
    if (axi_bus.rvalid && axi_bus.rready) begin
      $display("MONITOR: Read Data = 0x%08h, Response = %s", 
               axi_bus.rdata, (axi_bus.rresp == 2'b00) ? "OK" : "ERROR");
    end
  end

  // Simple master tasks
  task write_data(input [31:0] addr, input [31:0] data);
    $display("MASTER: Starting write - addr=0x%08h, data=0x%08h", addr, data);
    @(posedge clk);
    axi_bus.awaddr = addr;
    axi_bus.awvalid = 1'b1;
    axi_bus.wdata = data;
    axi_bus.wstrb = 4'hF;
    axi_bus.wvalid = 1'b1;
    axi_bus.bready = 1'b1;
    
    wait(axi_bus.awready && axi_bus.wready);
    @(posedge clk);
    axi_bus.awvalid = 1'b0;
    axi_bus.wvalid = 1'b0;
    
    wait(axi_bus.bvalid);
    @(posedge clk);
    axi_bus.bready = 1'b0;
    $display("MASTER: Write complete");
  endtask

  task read_data(input [31:0] addr, output [31:0] data);
    $display("MASTER: Starting read - addr=0x%08h", addr);
    @(posedge clk);
    axi_bus.araddr = addr;
    axi_bus.arvalid = 1'b1;
    axi_bus.rready = 1'b1;
    
    wait(axi_bus.arready);
    @(posedge clk);
    axi_bus.arvalid = 1'b0;
    
    wait(axi_bus.rvalid);
    data = axi_bus.rdata;
    @(posedge clk);
    axi_bus.rready = 1'b0;
    $display("MASTER: Read complete - data=0x%08h", data);
  endtask

  // Initialize master signals
  initial begin
    axi_bus.awaddr = 0;
    axi_bus.awvalid = 0;
    axi_bus.wdata = 0;
    axi_bus.wstrb = 0;
    axi_bus.wvalid = 0;
    axi_bus.bready = 0;
    axi_bus.araddr = 0;
    axi_bus.arvalid = 0;
    axi_bus.rready = 0;
  end

  // Test sequence
  initial begin
    logic [31:0] data_read;
    
    // Dump waves
    $dumpfile("axi4_lite_memory_testbench.vcd");
    $dumpvars(0, axi4_lite_memory_testbench);
    
    $display("=== AXI4-Lite Memory Test Starting ===");
    
    // Reset
    rst_n = 0;
    repeat(10) @(posedge clk);
    rst_n = 1;
    repeat(5) @(posedge clk);
    
    $display("\n--- Testing Basic Operations ---");
    
    // Write to register 0
    write_data(32'h00000000, 32'hCAFEBABE);
    repeat(2) @(posedge clk);
    
    // Read from register 0
    read_data(32'h00000000, data_read);
    assert(data_read == 32'hCAFEBABE) else $error("Read mismatch at address 0x00000000");
    repeat(2) @(posedge clk);
    
    // Write to register 1
    write_data(32'h00000004, 32'h12345678);
    repeat(2) @(posedge clk);
    
    // Read from register 1
    read_data(32'h00000004, data_read);
    assert(data_read == 32'h12345678) else $error("Read mismatch at address 0x00000004");
    repeat(2) @(posedge clk);
    
    // Write to register 2
    write_data(32'h00000008, 32'hDEADBEEF);
    repeat(2) @(posedge clk);
    
    // Read from register 2
    read_data(32'h00000008, data_read);
    assert(data_read == 32'hDEADBEEF) else $error("Read mismatch at address 0x00000008");
    repeat(2) @(posedge clk);
    
    $display("\n--- Testing Error Conditions ---");
    
    // Try invalid address (should generate error)
    write_data(32'h00000020, 32'hBADDAD00);
    repeat(2) @(posedge clk);
    
    // Try to read invalid address
    read_data(32'h00000020, data_read);
    repeat(2) @(posedge clk);
    
    $display("\n--- Testing Uninitialized Memory ---");
    
    // Read from register 3 (should be 0)
    read_data(32'h0000000C, data_read);
    assert(data_read == 32'h00000000) else $error("Uninitialized memory not zero");
    repeat(2) @(posedge clk);
    
    $display("\n=== AXI4-Lite Memory Test Complete ===");
    $display("All tests passed successfully!");
    
    repeat(10) @(posedge clk);
    $finish;
  end

endmodule