// Fixed axi4_lite_memory.sv
// Simple AXI4-Lite interface and memory slave

// Simple AXI4-Lite Interface
interface axi4_lite_if (input logic clk, input logic rst_n);
  
  // Write Address Channel
  logic [31:0] awaddr;
  logic        awvalid;
  logic        awready;
  
  // Write Data Channel
  logic [31:0] wdata;
  logic [3:0]  wstrb;
  logic        wvalid;
  logic        wready;
  
  // Write Response Channel
  logic [1:0]  bresp;
  logic        bvalid;
  logic        bready;
  
  // Read Address Channel
  logic [31:0] araddr;
  logic        arvalid;
  logic        arready;
  
  // Read Data Channel
  logic [31:0] rdata;
  logic [1:0]  rresp;
  logic        rvalid;
  logic        rready;

  // Master modport (initiates transactions)
  modport master (
    output awaddr, awvalid, wdata, wstrb, wvalid, bready,
    output araddr, arvalid, rready,
    input  awready, wready, bresp, bvalid,
    input  arready, rdata, rresp, rvalid,
    input  clk, rst_n
  );

  // Slave modport (responds to transactions)
  modport slave (
    input  awaddr, awvalid, wdata, wstrb, wvalid, bready,
    input  araddr, arvalid, rready,
    output awready, wready, bresp, bvalid,
    output arready, rdata, rresp, rvalid,
    input  clk, rst_n
  );

  // Monitor modport (observes all signals)
  modport monitor (
    input awaddr, awvalid, awready, wdata, wstrb, wvalid, wready,
    input bresp, bvalid, bready, araddr, arvalid, arready,
    input rdata, rresp, rvalid, rready, clk, rst_n
  );

endinterface

// Fixed Memory Slave (just 4 registers)
module axi4_lite_memory_slave (
  axi4_lite_if.slave axi_bus
);

  // Just 4 32-bit registers
  logic [31:0] memory [0:3];
  
  // State tracking for proper handshakes
  logic write_addr_accepted;
  logic write_data_accepted;
  
  // Initialize memory
  initial begin
    memory[0] = 32'h00000000;
    memory[1] = 32'h00000000;
    memory[2] = 32'h00000000;
    memory[3] = 32'h00000000;
  end

  // Write logic - fixed to prevent infinite loops
  always_ff @(posedge axi_bus.clk or negedge axi_bus.rst_n) begin
    if (!axi_bus.rst_n) begin
      axi_bus.awready <= 1'b0;
      axi_bus.wready <= 1'b0;
      axi_bus.bvalid <= 1'b0;
      axi_bus.bresp <= 2'b00;
      write_addr_accepted <= 1'b0;
      write_data_accepted <= 1'b0;
    end else begin
      
      // Write address handshake - only pulse awready for one cycle
      if (axi_bus.awvalid && !axi_bus.awready && !write_addr_accepted) begin
        axi_bus.awready <= 1'b1;
        write_addr_accepted <= 1'b1;
      end else begin
        axi_bus.awready <= 1'b0;
      end
      
      // Write data handshake - only pulse wready for one cycle  
      if (axi_bus.wvalid && !axi_bus.wready && !write_data_accepted) begin
        axi_bus.wready <= 1'b1;
        write_data_accepted <= 1'b1;
      end else begin
        axi_bus.wready <= 1'b0;
      end
      
      // Perform write when both address and data are accepted
      if (write_addr_accepted && write_data_accepted && !axi_bus.bvalid) begin
        if (axi_bus.awaddr[31:4] == 28'h0) begin // Valid address range
          memory[axi_bus.awaddr[3:2]] <= axi_bus.wdata;
          axi_bus.bresp <= 2'b00; // OK
          $display("MEMORY: Write 0x%08h to address 0x%08h", axi_bus.wdata, axi_bus.awaddr);
        end else begin
          axi_bus.bresp <= 2'b10; // SLVERR - invalid address
          $display("MEMORY: Write error - invalid address 0x%08h", axi_bus.awaddr);
        end
        axi_bus.bvalid <= 1'b1;
      end
      
      // Clear response when acknowledged
      if (axi_bus.bvalid && axi_bus.bready) begin
        axi_bus.bvalid <= 1'b0;
        write_addr_accepted <= 1'b0;
        write_data_accepted <= 1'b0;
      end
    end
  end

  // Read logic - fixed to prevent infinite loops
  always_ff @(posedge axi_bus.clk or negedge axi_bus.rst_n) begin
    if (!axi_bus.rst_n) begin
      axi_bus.arready <= 1'b0;
      axi_bus.rvalid <= 1'b0;
      axi_bus.rdata <= 32'h0;
      axi_bus.rresp <= 2'b00;
    end else begin
      
      // Read address handshake - only pulse arready for one cycle
      if (axi_bus.arvalid && !axi_bus.arready && !axi_bus.rvalid) begin
        axi_bus.arready <= 1'b1;
        
        // Perform read immediately
        if (axi_bus.araddr[31:4] == 28'h0) begin // Valid address range
          axi_bus.rdata <= memory[axi_bus.araddr[3:2]];
          axi_bus.rresp <= 2'b00; // OK
          $display("MEMORY: Read 0x%08h from address 0x%08h", memory[axi_bus.araddr[3:2]], axi_bus.araddr);
        end else begin
          axi_bus.rdata <= 32'hDEADC0DE; // Error pattern
          axi_bus.rresp <= 2'b10; // SLVERR
          $display("MEMORY: Read error - invalid address 0x%08h", axi_bus.araddr);
        end
        axi_bus.rvalid <= 1'b1;
        
      end else begin
        axi_bus.arready <= 1'b0;
      end
      
      // Clear read data when acknowledged
      if (axi_bus.rvalid && axi_bus.rready) begin
        axi_bus.rvalid <= 1'b0;
      end
    end
  end

endmodule