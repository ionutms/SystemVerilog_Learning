// memory_access_controller_testbench.sv
module memory_access_testbench;

  // Memory access type constants (must match design)
  localparam logic [2:0] MEM_READ    = 3'b001;  // Read operation    - bit 0 set
  localparam logic [2:0] MEM_WRITE   = 3'b010;  // Write operation   - bit 1 set
  localparam logic [2:0] MEM_EXECUTE = 3'b100;  // Execute operation - bit 2 set

  // Testbench signals
  logic                    clk;
  logic                    reset_n;
  logic [15:0]             address;
  logic [31:0]             write_data;
  logic [2:0]              access_type;
  logic                    access_enable;
  logic [31:0]             read_data;
  logic                    access_valid;
  logic                    access_error;

  // Instantiate the design under test
  memory_access_controller #(
    .DATA_WIDTH(32),
    .ADDR_WIDTH(16)
  ) MEMORY_CONTROLLER_INST (
    .clk(clk),
    .reset_n(reset_n),
    .address(address),
    .write_data(write_data),
    .access_type(access_type),
    .access_enable(access_enable),
    .read_data(read_data),
    .access_valid(access_valid),
    .access_error(access_error)
  );

  // Clock generation
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;  // 10ns period (100MHz)
  end

  // Test sequence
  initial begin
    // Initialize waveform dump
    $dumpfile("memory_access_testbench.vcd");
    $dumpvars(0, memory_access_testbench);
    
    $display();
    $display("=== Memory Access Types Test ===");
    $display();
    
    // Initialize signals
    reset_n      = 1'b0;
    address      = 16'h0000;
    write_data   = 32'h00000000;
    access_type  = MEM_READ;
    access_enable = 1'b0;
    
    // Reset sequence
    #20 reset_n = 1'b1;
    #10;
    
    // Test READ operation
    $display("--- Testing READ Operation ---");
    test_memory_access(16'h0000, 32'h00000000, MEM_READ);
    test_memory_access(16'h0001, 32'h00000000, MEM_READ);
    
    // Test WRITE operation
    $display("--- Testing WRITE Operation ---");
    test_memory_access(16'h0100, 32'hABCD1234, MEM_WRITE);
    test_memory_access(16'h0101, 32'h5678CDEF, MEM_WRITE);
    
    // Test READ after WRITE
    $display("--- Testing READ after WRITE ---");
    test_memory_access(16'h0100, 32'h00000000, MEM_READ);
    test_memory_access(16'h0101, 32'h00000000, MEM_READ);
    
    // Test EXECUTE operation
    $display("--- Testing EXECUTE Operation ---");
    test_memory_access(16'h0002, 32'h00000000, MEM_EXECUTE);
    test_memory_access(16'h0003, 32'h00000000, MEM_EXECUTE);
    
    // Test invalid access type
    $display("--- Testing Invalid Access Type ---");
    address      = 16'h0000;
    access_type  = 3'b111;  // Invalid type
    access_enable = 1'b1;
    @(posedge clk);
    access_enable = 1'b0;
    @(posedge clk);
    
    $display();
    $display("=== Test Complete ===");
    $display();
    
    #50 $finish;
  end

  // Task to perform memory access test
  task test_memory_access(
    input [15:0] addr,
    input [31:0] wdata,
    input [2:0] acc_type
  );
    begin
      address      = addr;
      write_data   = wdata;
      access_type  = acc_type;
      access_enable = 1'b1;
      
      @(posedge clk);
      access_enable = 1'b0;
      
      @(posedge clk);
      
      // Check results
      if (access_valid && !access_error) begin
        $display("✓ Access successful");
      end else if (access_error) begin
        $display("✗ Access error detected");
      end else begin
        $display("? Access pending");
      end
      $display();
    end
  endtask

endmodule