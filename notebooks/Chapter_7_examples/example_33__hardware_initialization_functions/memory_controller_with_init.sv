// memory_controller_with_init.sv
module memory_controller_with_init (
  input  logic        clock_signal,
  input  logic        reset_signal,
  input  logic        enable_signal,
  output logic [7:0]  status_register,
  output logic [15:0] address_register,
  output logic [31:0] data_register
);

  // Internal registers for hardware components
  logic [7:0]  control_register;
  logic [15:0] base_address_register;
  logic [31:0] cache_data_register;
  logic [3:0]  interrupt_mask_register;

  // Initialization values - computed by void functions
  logic [7:0]  init_status_value;
  logic [15:0] init_address_value;
  logic [31:0] init_data_value;

  // Void function to initialize control registers values
  function void compute_control_register_init_values();
    $display("Computing control register initialization values...");
    init_status_value = 8'h80;          // Set ready status bit
    $display("Control register values computed successfully");
  endfunction

  // Void function to initialize memory address register values
  function void compute_memory_address_init_values();
    $display("Computing memory address initialization values...");
    init_address_value = 16'h0000;      // Clear current address
    $display("Memory address values computed successfully");
  endfunction

  // Void function to initialize data path register values
  function void compute_data_path_init_values();
    $display("Computing data path initialization values...");
    init_data_value = 32'h00000000;     // Clear data register
    $display("Data path values computed successfully");
  endfunction

  // Void function to perform complete hardware initialization setup
  function void prepare_complete_hardware_initialization();
    $display("=== Preparing Complete Hardware Initialization ===");
    compute_control_register_init_values();
    compute_memory_address_init_values();
    compute_data_path_init_values();
    $display("=== Hardware Initialization Preparation Complete ===");
    $display();
  endfunction

  // Additional void function to initialize internal component registers
  function void initialize_internal_component_registers();
    $display("Initializing internal component registers...");
    // These are internal only, not mixed with sequential assignments
    control_register = 8'h00;           // Clear control register
    base_address_register = 16'h1000;   // Set base address
    cache_data_register = 32'hDEADBEEF; // Set cache test pattern
    interrupt_mask_register = 4'hF;     // Enable all interrupts
    $display("Internal component registers initialized successfully");
  endfunction

  // Hardware reset and operation logic
  always_ff @(posedge clock_signal or posedge reset_signal) begin
    if (reset_signal) begin
      // Call void functions to prepare initialization values
      prepare_complete_hardware_initialization();
      initialize_internal_component_registers();
      
      // Apply computed initialization values to output registers
      status_register <= init_status_value;
      address_register <= init_address_value;
      data_register <= init_data_value;
    end
    else if (enable_signal) begin
      // Normal operation - set busy bit
      status_register <= status_register | 8'h01;  // Set busy bit
      address_register <= address_register + 1;    // Increment address
      data_register <= data_register + 32'h00000001; // Increment data
    end
  end

endmodule