// memory_type_selector_testbench.sv
module memory_type_selector_testbench;

  logic clk, reset, write_en;
  logic [3:0] addr;
  logic [7:0] data_in, data_out_sram, data_out_dram, data_out_rom;

  // Instance 1: SRAM memory
  memory_type_selector #(
    .MEMORY_TYPE("SRAM"),
    .DATA_WIDTH(8),
    .ADDR_WIDTH(4)
  ) sram_inst (
    .clk(clk), .reset(reset),
    .addr(addr), .data_in(data_in), .write_en(write_en),
    .data_out(data_out_sram)
  );

  // Instance 2: DRAM memory
  memory_type_selector #(
    .MEMORY_TYPE("DRAM"),
    .DATA_WIDTH(8),
    .ADDR_WIDTH(4)
  ) dram_inst (
    .clk(clk), .reset(reset),
    .addr(addr), .data_in(data_in), .write_en(write_en),
    .data_out(data_out_dram)
  );

  // Instance 3: ROM memory
  memory_type_selector #(
    .MEMORY_TYPE("ROM"),
    .DATA_WIDTH(8),
    .ADDR_WIDTH(4)
  ) rom_inst (
    .clk(clk), .reset(reset),
    .addr(addr), .data_in(data_in), .write_en(write_en),
    .data_out(data_out_rom)
  );

  // Instance 4: Invalid memory type
  memory_type_selector #(
    .MEMORY_TYPE("FLASH"),
    .DATA_WIDTH(8),
    .ADDR_WIDTH(4)
  ) invalid_inst (
    .clk(clk), .reset(reset),
    .addr(addr), .data_in(data_in), .write_en(write_en),
    .data_out()  // Don't care about output
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    // Dump waves
    $dumpfile("memory_type_selector_testbench.vcd");
    $dumpvars(0, memory_type_selector_testbench);
    
    $display("=== Memory Type Selector Testbench ===");
    $display("Testing conditional compilation with generate if-else");
    $display();
    
    // Reset sequence
    reset = 1;
    addr = 0;
    data_in = 0;
    write_en = 0;
    #20;
    reset = 0;
    #10;
    
    // Test write operation
    $display("--- Testing Write Operations ---");
    write_en = 1;
    addr = 4'h5;
    data_in = 8'hAA;
    #10;
    write_en = 0;
    #10;
    
    $display("SRAM[5] = 0x%02X", data_out_sram);
    $display("DRAM[5] = 0x%02X", data_out_dram);
    $display("ROM[5] = 0x%02X (should be %0d)", data_out_rom, 5*3);
    
    // Test read operation
    $display("--- Testing Read Operations ---");
    addr = 4'h3;
    #10;
    
    $display("SRAM[3] = 0x%02X", data_out_sram);
    $display("DRAM[3] = 0x%02X", data_out_dram);
    $display("ROM[3] = 0x%02X (should be %0d)", data_out_rom, 3*3);
    
    $display();
    $display("Each instance compiled different memory logic based on MEMORY_TYPE!");
    $display("Same module, different hardware generated!");
    
    #50;
    $finish;
  end

endmodule