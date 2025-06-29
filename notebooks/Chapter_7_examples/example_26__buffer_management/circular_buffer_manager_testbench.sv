// circular_buffer_manager_testbench.sv - Fixed Version
module buffer_manager_testbench;

  // Testbench parameters
  parameter BUFFER_DEPTH = 4;
  parameter DATA_WIDTH   = 8;
  parameter CLK_PERIOD   = 10;

  // Testbench signals
  logic                    clk;
  logic                    reset_n;
  logic                    write_enable;
  logic                    read_enable;
  logic [DATA_WIDTH-1:0]   write_data;
  logic [DATA_WIDTH-1:0]   read_data;
  logic                    buffer_full;
  logic                    buffer_empty;
  logic [$clog2(BUFFER_DEPTH):0] occupancy_count;

  // Test data storage
  logic [DATA_WIDTH-1:0] test_write_sequence [8] = 
    '{8'hAA, 8'hBB, 8'hCC, 8'hDD, 8'hEE, 8'hFF, 8'h11, 8'h22};
  logic [DATA_WIDTH-1:0] expected_read_data;
  logic [DATA_WIDTH-1:0] captured_read_data;

  // Instantiate design under test
  circular_buffer_manager #(
    .BUFFER_DEPTH(BUFFER_DEPTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) buffer_manager_instance (
    .clk(clk),
    .reset_n(reset_n),
    .write_enable(write_enable),
    .read_enable(read_enable),
    .write_data(write_data),
    .read_data(read_data),
    .buffer_full(buffer_full),
    .buffer_empty(buffer_empty),
    .occupancy_count(occupancy_count)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  // Test stimulus and buffer management verification
  initial begin
    // Dump waves for buffer analysis
    $dumpfile("buffer_manager_testbench.vcd");
    $dumpvars(0, buffer_manager_testbench);

    $display();
    $display("=== Buffer Management Functions Test ===");
    
    // Initialize signals
    reset_n      = 0;
    write_enable = 0;
    read_enable  = 0;
    write_data   = 0;
    
    // Reset sequence
    repeat(2) @(posedge clk);
    reset_n = 1;
    @(posedge clk);
    
    $display("Initial state - Empty: %0b, Full: %0b, Count: %0d", 
             buffer_empty, buffer_full, occupancy_count);

    // Test 1: Fill circular buffer completely
    $display("\n--- Test 1: Filling circular buffer ---");
    for (int write_index = 0; write_index < BUFFER_DEPTH; write_index++) begin
      write_enable = 1;
      write_data = test_write_sequence[write_index];
      $display("Writing data: 0x%02X, Count: %0d, Full: %0b", 
               write_data, occupancy_count, buffer_full);
      @(posedge clk);
    end
    write_enable = 0;

    // Test 2: Attempt overflow write
    $display("\n--- Test 2: Testing buffer overflow protection ---");
    write_enable = 1;
    write_data = 8'hFF;
    $display("Overflow attempt - Full: %0b, Count: %0d", 
             buffer_full, occupancy_count);
    @(posedge clk);
    write_enable = 0;

    // Test 3: Read from circular buffer
    $display("\n--- Test 3: Reading from circular buffer ---");
    for (int read_index = 0; read_index < BUFFER_DEPTH; read_index++) begin
      expected_read_data = test_write_sequence[read_index];
      
      // Capture read data BEFORE applying read enable
      captured_read_data = read_data;
      
      $display("Before read - Read ptr: %0d, Write ptr: %0d, Data[0-3]: %02X %02X %02X %02X", 
               buffer_manager_instance.read_pointer, 
               buffer_manager_instance.write_pointer,
               buffer_manager_instance.memory_pool[0],
               buffer_manager_instance.memory_pool[1], 
               buffer_manager_instance.memory_pool[2],
               buffer_manager_instance.memory_pool[3]);
      
      $display("Read data: 0x%02X, Expected: 0x%02X, Match: %0b, Count: %0d", 
               captured_read_data, expected_read_data, 
               (captured_read_data == expected_read_data), occupancy_count);
      
      // Apply read enable and clock edge
      read_enable = 1;
      @(posedge clk);
      read_enable = 0;
    end

    // Test 4: Attempt underflow read
    $display("\n--- Test 4: Testing buffer underflow protection ---");
    read_enable = 1;
    $display("Underflow attempt - Empty: %0b, Count: %0d", 
             buffer_empty, occupancy_count);
    @(posedge clk);
    read_enable = 0;

    // Test 5: Simultaneous read/write operations
    $display("\n--- Test 5: Simultaneous buffer operations ---");
    // First write some data to have something to read
    write_enable = 1;
    write_data = test_write_sequence[4]; // 0xEE
    @(posedge clk);
    write_enable = 0;
    
    $display("Setup for simultaneous ops - Count: %0d", occupancy_count);
    
    for (int sim_index = 5; sim_index < 8; sim_index++) begin
      // Capture current read data before operation
      captured_read_data = read_data;
      
      // Set up simultaneous read/write
      write_enable = 1;
      read_enable  = 1;
      write_data = test_write_sequence[sim_index];
      
      $display("Simultaneous - Write: 0x%02X, Read: 0x%02X, Count before: %0d", 
               write_data, captured_read_data, occupancy_count);
      
      @(posedge clk); // Execute both operations
      
      $display("After simultaneous op - Count: %0d", occupancy_count);
      
      write_enable = 0;
      read_enable  = 0;
    end

    repeat(2) @(posedge clk);
    $display("\n=== Buffer Management Test Complete ===");
    $display();
    $finish;
  end

endmodule