// memory_controller_with_init_testbench.sv
module memory_controller_initialization_testbench;

  // Testbench signals
  logic        clock_signal;
  logic        reset_signal;
  logic        enable_signal;
  logic [7:0]  status_register;
  logic [15:0] address_register;
  logic [31:0] data_register;

  // Instantiate design under test
  memory_controller_with_init MEMORY_CONTROLLER_INSTANCE (
    .clock_signal(clock_signal),
    .reset_signal(reset_signal),
    .enable_signal(enable_signal),
    .status_register(status_register),
    .address_register(address_register),
    .data_register(data_register)
  );

  // Clock generation
  initial begin
    clock_signal = 0;
    forever #5 clock_signal = ~clock_signal;  // 100MHz clock
  end

  // Void function to initialize testbench signals
  function void initialize_testbench_signals();
    $display("Initializing testbench signals...");
    reset_signal = 1'b0;
    enable_signal = 1'b0;
    $display("Testbench signals initialized");
    $display();
  endfunction

  // Void function to apply reset sequence
  function void apply_hardware_reset_sequence();
    $display("Applying hardware reset sequence...");
    reset_signal = 1'b1;
    @(posedge clock_signal);  // Single clock cycle for reset
    reset_signal = 1'b0;
    @(posedge clock_signal);  // Wait for reset to complete
    $display("Hardware reset sequence complete");
    $display();
  endfunction

  // Void function to verify initialization values
  function void verify_hardware_initialization_values();
    $display("Verifying hardware initialization values...");
    $display("Status register: 0x%02h (expected: 0x80)", status_register);
    $display("Address register: 0x%04h (expected: 0x0000)", address_register);
    $display("Data register: 0x%08h (expected: 0x00000000)", data_register);
    
    if (status_register[7] == 1'b1) begin
      $display("Ready bit correctly set in status register");
    end else begin
      $display("Ready bit not set in status register");
    end
    $display();
  endfunction

  // Void function to test enable functionality
  function void test_enable_functionality();
    $display("Testing enable functionality...");
    enable_signal = 1'b1;
    repeat(2) @(posedge clock_signal);
    enable_signal = 1'b0;
    @(posedge clock_signal);
    
    $display("Status after enable: 0x%02h", status_register);
    if (status_register[0] == 1'b1) begin
      $display("Busy bit correctly set after enable");
    end else begin
      $display("Busy bit not set after enable");
    end
    $display();
  endfunction

  // Main test sequence
  initial begin
    // Dump waves for analysis
    $dumpfile("memory_controller_initialization_testbench.vcd");
    $dumpvars(0, memory_controller_initialization_testbench);

    $display("=== Hardware Initialization Functions Test ===");
    $display();

    // Initialize testbench
    initialize_testbench_signals();

    // Apply reset and observe initialization
    apply_hardware_reset_sequence();

    // Verify initialization worked correctly
    verify_hardware_initialization_values();

    // Test normal operation
    test_enable_functionality();

    $display("=== Test Complete ===");
    $finish;
  end

endmodule