// hardware_config_registers.sv
module hardware_config_registers (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        write_enable,
  input  logic [31:0] config_data_in,
  output logic [31:0] config_data_out,
  output logic        interrupt_enable,
  output logic [2:0]  priority_level,
  output logic [7:0]  device_id
);

  // Packed structure for configuration register
  typedef struct packed {
    logic [7:0]  reserved;        // Bits [31:24] - Reserved for future use
    logic [7:0]  device_id;       // Bits [23:16] - Device identification
    logic [4:0]  unused;          // Bits [15:11] - Unused bits
    logic [2:0]  priority_level;  // Bits [10:8]  - Interrupt priority
    logic [6:0]  feature_flags;   // Bits [7:1]   - Various feature enables
    logic        interrupt_enable; // Bit [0]     - Global interrupt enable
  } config_register_t;

  // Configuration register instance
  config_register_t config_reg;

  // Register update logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset to default configuration
      config_reg.reserved        <= 8'h00;
      config_reg.device_id       <= 8'hA5;  // Default device ID
      config_reg.unused          <= 5'b00000;
      config_reg.priority_level  <= 3'b010; // Medium priority
      config_reg.feature_flags   <= 7'b0000001; // Basic features
      config_reg.interrupt_enable <= 1'b0;  // Interrupts disabled
    end else if (write_enable) begin
      // Write new configuration
      config_reg <= config_data_in;
    end
  end

  // Output assignments from packed structure fields
  assign config_data_out   = config_reg;
  assign interrupt_enable  = config_reg.interrupt_enable;
  assign priority_level    = config_reg.priority_level;
  assign device_id         = config_reg.device_id;

  // Display configuration changes
  always @(posedge clk) begin
    if (write_enable && rst_n) begin
      $display("Config Update: Device=0x%02X, Priority=%0d, IntEn=%b",
               config_reg.device_id, config_reg.priority_level,
               config_reg.interrupt_enable);
    end
  end

endmodule