// circular_buffer_manager_testbench.sv
module buffer_manager_testbench;

  // Testbench parameters
  parameter int BUFFER_SIZE = 4;
  parameter int DATA_WIDTH = 8;
  parameter int CLK_PERIOD = 10;

  // Testbench signals
  logic                    clk;
  logic                    rst_n;
  logic                    write_enable;
  logic                    read_enable;
  logic [DATA_WIDTH-1:0]   write_data;
  logic [DATA_WIDTH-1:0]   read_data;
  logic                    buffer_full;
  logic                    buffer_empty;
  logic [$clog2(BUFFER_SIZE):0] buffer_count;

  // Clock generation
  always #(CLK_PERIOD/2) clk = ~clk;

  // Instantiate design under test
  circular_buffer_manager #(
    .BUFFER_SIZE(BUFFER_SIZE),
    .DATA_WIDTH(DATA_WIDTH)
  ) BUFFER_MANAGER_INSTANCE (
    .clk(clk),
    .rst_n(rst_n),
    .write_enable(write_enable),
    .read_enable(read_enable),
    .write_data(write_data),
    .read_data(read_data),
    .buffer_full(buffer_full),
    .buffer_empty(buffer_empty),
    .buffer_count(buffer_count)
  );

  // Test sequence
  initial begin
    // Initialize VCD dump
    $dumpfile("buffer_manager_testbench.vcd");
    $dumpvars(0, buffer_manager_testbench);

    // Initialize signals
    clk = 0;
    rst_n = 0;
    write_enable = 0;
    read_enable = 0;
    write_data = 0;

    $display("=== Buffer Management Test Started ===");
    $display();

    // Reset sequence
    #(CLK_PERIOD * 2);
    rst_n = 1;
    #(CLK_PERIOD);

    // Test 1: Fill buffer with data
    $display("Test 1: Writing data to buffer");
    for (int i = 0; i < BUFFER_SIZE; i++) begin
      write_data = 8'hA0 + 8'(i);
      write_enable = 1;
      #(CLK_PERIOD);
      write_enable = 0;
      $display("  Written: 0x%02X, Count: %0d, Full: %b", 
               write_data, buffer_count, buffer_full);
      #(CLK_PERIOD);
    end

    // Test 2: Try to write when buffer is full
    $display("\nTest 2: Attempting to write when buffer is full");
    write_data = 8'hFF;
    write_enable = 1;
    #(CLK_PERIOD);
    write_enable = 0;
    $display("  Write attempt: 0x%02X, Count: %0d, Full: %b", 
             write_data, buffer_count, buffer_full);
    #(CLK_PERIOD);

    // Test 3: Read data from buffer
    $display("\nTest 3: Reading data from buffer");
    for (int i = 0; i < BUFFER_SIZE; i++) begin
      read_enable = 1;
      #(CLK_PERIOD);
      read_enable = 0;
      $display("  Read: 0x%02X, Count: %0d, Empty: %b", 
               read_data, buffer_count, buffer_empty);
      #(CLK_PERIOD);
    end

    // Test 4: Try to read when buffer is empty
    $display("\nTest 4: Attempting to read when buffer is empty");
    read_enable = 1;
    #(CLK_PERIOD);
    read_enable = 0;
    $display("  Read attempt: 0x%02X, Count: %0d, Empty: %b", 
             read_data, buffer_count, buffer_empty);
    #(CLK_PERIOD);

    // Test 5: Simultaneous read/write operations
    $display("\nTest 5: Simultaneous read/write operations");
    write_data = 8'hBB;
    write_enable = 1;
    #(CLK_PERIOD);
    write_enable = 0;
    $display("  Written: 0x%02X, Count: %0d", write_data, buffer_count);
    
    read_enable = 1;
    write_enable = 1;
    write_data = 8'hCC;
    #(CLK_PERIOD);
    write_enable = 0;
    read_enable = 0;
    $display("  Simultaneous R/W - Read: 0x%02X, Written: 0x%02X, Count: %0d", 
             read_data, write_data, buffer_count);

    #(CLK_PERIOD * 2);
    $display();
    $display("=== Buffer Management Test Completed ===");
    $display("Final buffer state - Count: %0d, Full: %b, Empty: %b", 
             buffer_count, buffer_full, buffer_empty);

    $finish;
  end

endmodule