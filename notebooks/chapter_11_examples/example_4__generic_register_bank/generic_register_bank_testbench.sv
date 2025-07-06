// generic_register_bank_testbench.sv
`include "register_bank_pkg.sv"

module register_bank_test_module;
  import register_bank_pkg::*;
  
  // Test parameters for different configurations
  parameter int unsigned NUM_REGS_SMALL = 8;
  parameter int unsigned DATA_WIDTH_SMALL = 16;
  parameter int unsigned NUM_REGS_LARGE = 32;
  parameter int unsigned DATA_WIDTH_LARGE = 64;
  
  // Clock and reset
  logic clk = 0;
  logic rst_n = 0;
  
  // Test signals for small register bank
  logic        we_small;
  logic [2:0]  addr_small;   // 3 bits for 8 registers
  logic [15:0] wdata_small;
  logic [15:0] rdata_small;
  logic        valid_small;
  
  // Test signals for large register bank
  logic        we_large;
  logic [4:0]  addr_large;   // 5 bits for 32 registers
  logic [63:0] wdata_large;
  logic [63:0] rdata_large;
  logic        valid_large;
  
  // Clock generation
  always #5 clk = ~clk;
  
  // Instantiate small register bank (8 registers, 16-bit data)
  generic_register_bank #(
    .NUM_REGISTERS(NUM_REGS_SMALL),
    .DATA_WIDTH(DATA_WIDTH_SMALL)
  ) small_register_bank (
    .clk(clk),
    .rst_n(rst_n),
    .write_enable(we_small),
    .address(addr_small),
    .write_data(wdata_small),
    .read_data(rdata_small),
    .valid_address(valid_small)
  );
  
  // Instantiate large register bank (32 registers, 64-bit data)
  generic_register_bank #(
    .NUM_REGISTERS(NUM_REGS_LARGE),
    .DATA_WIDTH(DATA_WIDTH_LARGE)
  ) large_register_bank (
    .clk(clk),
    .rst_n(rst_n),
    .write_enable(we_large),
    .address(addr_large),
    .write_data(wdata_large),
    .read_data(rdata_large),
    .valid_address(valid_large)
  );
  
  // Test class instances
  register_bank_config small_config;
  register_bank_config large_config;
  register_transaction trans;
  
  // Test procedure
  initial begin
    // Setup VCD dumping
    $dumpfile("register_bank_test_module.vcd");
    $dumpvars(0, register_bank_test_module);
    
    // Initialize configurations
    small_config = new(NUM_REGS_SMALL, DATA_WIDTH_SMALL);
    large_config = new(NUM_REGS_LARGE, DATA_WIDTH_LARGE);
    trans = new();
    
    $display("=== Generic Register Bank Test ===");
    $display();
    
    // Display configurations
    small_config.display_config();
    $display();
    large_config.display_config();
    $display();
    
    // Initialize signals
    we_small = 0;
    addr_small = 0;
    wdata_small = 0;
    we_large = 0;
    addr_large = 0;
    wdata_large = 0;
    
    // Reset sequence
    $display("Applying reset...");
    rst_n = 0;
    #20;
    rst_n = 1;
    #10;
    
    // Test small register bank
    $display("=== Testing Small Register Bank ===");
    test_register_bank_small();
    
    #50;
    
    // Test large register bank
    $display("=== Testing Large Register Bank ===");
    test_register_bank_large();
    
    #50;
    
    // Test address validation
    $display("=== Testing Address Validation ===");
    test_address_validation();
    
    #50;
    $display("=== Test Complete ===");
    $finish;
  end
  
  // Test task for small register bank
  task test_register_bank_small();
    $display("Writing test patterns to small register bank...");
    
    // Write to all registers
    for (int i = 0; i < NUM_REGS_SMALL; i++) begin
      @(posedge clk);
      we_small = 1;
      addr_small = i[2:0];  // Explicit width conversion
      wdata_small = 16'hA000 + 16'(i);  // Explicit width conversion
      @(posedge clk);
      we_small = 0;
      $display("  Written 0x%04X to register %0d", wdata_small, i);
    end
    
    $display("Reading back from small register bank...");
    
    // Read from all registers
    for (int i = 0; i < NUM_REGS_SMALL; i++) begin
      @(posedge clk);
      addr_small = i[2:0];  // Explicit width conversion
      @(posedge clk);
      #1; // Small delay for combinatorial read
      $display("  Register %0d: 0x%04X", i, rdata_small);
    end
  endtask
  
  // Test task for large register bank
  task test_register_bank_large();
    $display("Writing test patterns to large register bank...");
    
    // Write to first 8 registers
    for (int i = 0; i < 8; i++) begin
      @(posedge clk);
      we_large = 1;
      addr_large = i[4:0];  // Explicit width conversion
      wdata_large = 64'hDEADBEEF00000000 + 64'(i);  // Explicit width conversion
      @(posedge clk);
      we_large = 0;
      $display("  Written 0x%016X to register %0d", wdata_large, i);
    end
    
    $display("Reading back from large register bank...");
    
    // Read from first 8 registers
    for (int i = 0; i < 8; i++) begin
      @(posedge clk);
      addr_large = i[4:0];  // Explicit width conversion
      @(posedge clk);
      #1; // Small delay for combinatorial read
      $display("  Register %0d: 0x%016X", i, rdata_large);
    end
  endtask
  
  // Test address validation
  task test_address_validation();
    $display("Testing invalid addresses...");
    
    // Test invalid address on small bank
    @(posedge clk);
    addr_small = 3'h7; // Address 7 (max valid for 8-register bank)
    @(posedge clk);
    #1;
    $display("  Small bank addr=7, valid=%b, data=0x%04X", 
             valid_small, rdata_small);
    
    // Test valid address on large bank
    @(posedge clk);
    addr_large = 5'h1F; // Address 31 (valid for 32-register bank)
    @(posedge clk);
    #1;
    $display("  Large bank addr=31, valid=%b, data=0x%016X", 
             valid_large, rdata_large);
    
    // Test maximum address on large bank
    @(posedge clk);
    addr_large = 5'h1F; // Address 31 (maximum valid address)
    @(posedge clk);
    #1;
    $display("  Large bank max addr=31, valid=%b, data=0x%016X", 
             valid_large, rdata_large);
  endtask

endmodule