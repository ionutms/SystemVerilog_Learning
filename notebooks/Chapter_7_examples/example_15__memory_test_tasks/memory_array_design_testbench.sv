// memory_array_design_testbench.sv
module memory_test_pattern_testbench;

  // Clock and reset signals
  logic        clock_signal;
  logic        reset_signal;
  logic        write_enable_signal;
  logic [7:0]  address_bus;
  logic [15:0] write_data_bus;
  logic [15:0] read_data_bus;

  // Instantiate memory design under test
  simple_memory_array_module MEMORY_DESIGN_INSTANCE (
    .clock_signal(clock_signal),
    .reset_signal(reset_signal),
    .write_enable_signal(write_enable_signal),
    .address_bus(address_bus),
    .write_data_bus(write_data_bus),
    .read_data_bus(read_data_bus)
  );

  // Clock generation
  initial begin
    clock_signal = 0;
    forever #5 clock_signal = ~clock_signal;  // 10ns period
  end

  // Task: Walking ones pattern test
  task automatic walking_ones_pattern_test();
    logic [15:0] walking_pattern;
    $display("\n=== WALKING ONES PATTERN TEST ===");
    
    for (int address_index = 0; address_index < 16; address_index++) begin
      walking_pattern = 16'h0001 << address_index;
      write_memory_location(address_index[7:0], walking_pattern);
      verify_memory_location(address_index[7:0], walking_pattern);
    end
  endtask

  // Task: Walking zeros pattern test  
  task automatic walking_zeros_pattern_test();
    logic [15:0] walking_pattern;
    $display("\n=== WALKING ZEROS PATTERN TEST ===");
    
    for (int address_index = 0; address_index < 16; address_index++) begin
      walking_pattern = ~(16'h0001 << address_index);
      write_memory_location(address_index[7:0], walking_pattern);
      verify_memory_location(address_index[7:0], walking_pattern);
    end
  endtask

  // Task: Checkerboard pattern test
  task automatic checkerboard_pattern_test();
    logic [15:0] checkerboard_pattern_a = 16'hAAAA;
    logic [15:0] checkerboard_pattern_b = 16'h5555;
    $display("\n=== CHECKERBOARD PATTERN TEST ===");
    
    // Write checkerboard pattern A to even addresses
    for (int address_index = 0; address_index < 32; address_index += 2) begin
      write_memory_location(address_index[7:0], checkerboard_pattern_a);
    end
    
    // Write checkerboard pattern B to odd addresses  
    for (int address_index = 1; address_index < 32; address_index += 2) begin
      write_memory_location(address_index[7:0], checkerboard_pattern_b);
    end
    
    // Verify all patterns
    for (int address_index = 0; address_index < 32; address_index++) begin
      if (address_index % 2 == 0)
        verify_memory_location(address_index[7:0], checkerboard_pattern_a);
      else
        verify_memory_location(address_index[7:0], checkerboard_pattern_b);
    end
  endtask

  // Task: Address-in-data pattern test
  task automatic address_in_data_pattern_test();
    $display("\n=== ADDRESS-IN-DATA PATTERN TEST ===");
    
    for (int address_index = 0; address_index < 64; address_index++) begin
      write_memory_location(address_index[7:0], {8'h00, address_index[7:0]});
      verify_memory_location(address_index[7:0], {8'h00, address_index[7:0]});
    end
  endtask

  // Helper task: Write to memory location
  task automatic write_memory_location(input [7:0] addr, input [15:0] data);
    @(posedge clock_signal);
    address_bus = addr;
    write_data_bus = data;
    write_enable_signal = 1'b1;
    @(posedge clock_signal);
    write_enable_signal = 1'b0;
  endtask

  // Helper task: Verify memory location
  task automatic verify_memory_location(input [7:0] addr, 
                                       input [15:0] expected_data);
    @(posedge clock_signal);
    address_bus = addr;
    write_enable_signal = 1'b0;
    @(posedge clock_signal);
    
    if (read_data_bus === expected_data) begin
      $display("PASS: Addr[%02h] = %04h (Expected: %04h)", 
               addr, read_data_bus, expected_data);
    end else begin
      $display("FAIL: Addr[%02h] = %04h (Expected: %04h)", 
               addr, read_data_bus, expected_data);
    end
  endtask

  // Main test sequence
  initial begin
    // Setup waveform dump
    $dumpfile("memory_test_pattern_testbench.vcd");
    $dumpvars(0, memory_test_pattern_testbench);

    // Initialize signals
    reset_signal = 1'b1;
    write_enable_signal = 1'b0;
    address_bus = 8'h00;
    write_data_bus = 16'h0000;

    // Release reset
    repeat(3) @(posedge clock_signal);
    reset_signal = 1'b0;
    $display("Memory test patterns starting...\n");

    // Execute comprehensive memory test patterns
    walking_ones_pattern_test();
    walking_zeros_pattern_test();
    checkerboard_pattern_test();
    address_in_data_pattern_test();

    $display("\n=== MEMORY PATTERN TESTING COMPLETE ===");
    $display();
    
    // Finish simulation
    repeat(5) @(posedge clock_signal);
    $finish;
  end

endmodule