// hardware_config_registers_testbench.sv
module config_registers_testbench;

  // Testbench signals
  logic        clk;
  logic        rst_n;
  logic        write_enable;
  logic [31:0] config_data_in;
  logic [31:0] config_data_out;
  logic        interrupt_enable;
  logic [2:0]  priority_level;
  logic [7:0]  device_id;

  // Instantiate design under test
  hardware_config_registers CONFIG_DUT (
    .clk(clk),
    .rst_n(rst_n),
    .write_enable(write_enable),
    .config_data_in(config_data_in),
    .config_data_out(config_data_out),
    .interrupt_enable(interrupt_enable),
    .priority_level(priority_level),
    .device_id(device_id)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns period clock
  end

  // Test sequence
  initial begin
    // Dump waves
    $dumpfile("config_registers_testbench.vcd");
    $dumpvars(0, config_registers_testbench);

    // Initialize signals
    rst_n = 0;
    write_enable = 0;
    config_data_in = 32'h0;

    $display("=== Configuration Registers Test ===");
    $display();

    // Reset sequence
    #15;
    rst_n = 1;
    #10;

    $display("After Reset:");
    $display("  Device ID: 0x%02X", device_id);
    $display("  Priority:  %0d", priority_level);
    $display("  Int Enable: %b", interrupt_enable);
    $display("  Full Config: 0x%08X", config_data_out);
    $display();

    // Test configuration write 1: Enable interrupts with high priority
    #10;
    config_data_in = 32'h00FF_0701;  // DevID=0xFF, Priority=7, IntEn=1
    write_enable = 1;
    #10;
    write_enable = 0;
    #10;

    $display("Config Write 1 (High Priority + Interrupt Enable):");
    $display("  Device ID: 0x%02X", device_id);
    $display("  Priority:  %0d", priority_level);
    $display("  Int Enable: %b", interrupt_enable);
    $display("  Full Config: 0x%08X", config_data_out);
    $display();

    // Test configuration write 2: Different device ID, medium priority
    #10;
    config_data_in = 32'h0042_0420;  // DevID=0x42, Priority=4, IntEn=0
    write_enable = 1;
    #10;
    write_enable = 0;
    #10;

    $display("Config Write 2 (Medium Priority + Interrupt Disable):");
    $display("  Device ID: 0x%02X", device_id);
    $display("  Priority:  %0d", priority_level);
    $display("  Int Enable: %b", interrupt_enable);
    $display("  Full Config: 0x%08X", config_data_out);
    $display();

    // Test configuration write 3: Maximum values
    #10;
    config_data_in = 32'hABCD_EF01;  // Mixed values
    write_enable = 1;
    #10;
    write_enable = 0;
    #10;

    $display("Config Write 3 (Mixed Values):");
    $display("  Device ID: 0x%02X", device_id);
    $display("  Priority:  %0d", priority_level);
    $display("  Int Enable: %b", interrupt_enable);
    $display("  Full Config: 0x%08X", config_data_out);
    $display();

    // Test reset again
    #10;
    rst_n = 0;
    #10;
    rst_n = 1;
    #10;

    $display("After Second Reset:");
    $display("  Device ID: 0x%02X", device_id);
    $display("  Priority:  %0d", priority_level);
    $display("  Int Enable: %b", interrupt_enable);
    $display("  Full Config: 0x%08X", config_data_out);
    $display();

    $display("=== Configuration Registers Test Complete ===");
    $finish;
  end

endmodule