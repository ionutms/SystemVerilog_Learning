// crc_calculator_design.sv
module crc_calculator_design_module (
  input  logic        clock_signal,
  input  logic        reset_active_low,
  input  logic        data_valid_input,
  input  logic [7:0]  data_byte_input,
  output logic [7:0]  crc_checksum_output,
  output logic        crc_calculation_complete
);

  // CRC-8 polynomial: x^8 + x^2 + x^1 + 1 (0x07)
  parameter logic [7:0] CRC_POLYNOMIAL_CONSTANT = 8'h07;
  
  // Internal registers for CRC calculation
  logic [7:0] crc_register_current;
  logic [7:0] crc_register_next;
  logic       calculation_in_progress;

  // CRC calculation logic
  always_comb begin
    crc_register_next = crc_register_current;
    
    if (data_valid_input) begin
      // XOR input data with current CRC
      crc_register_next = crc_register_current ^ data_byte_input;
      
      // Process each bit through the polynomial
      for (int bit_position = 0; bit_position < 8; bit_position++) begin
        if (crc_register_next[7]) begin
          crc_register_next = (crc_register_next << 1) ^ CRC_POLYNOMIAL_CONSTANT;
        end else begin
          crc_register_next = crc_register_next << 1;
        end
      end
    end
  end

  // Sequential logic for state updates
  always_ff @(posedge clock_signal or negedge reset_active_low) begin
    if (!reset_active_low) begin
      crc_register_current     <= 8'h00;
      calculation_in_progress  <= 1'b0;
      crc_calculation_complete <= 1'b0;
    end else begin
      crc_register_current <= crc_register_next;
      
      if (data_valid_input) begin
        calculation_in_progress  <= 1'b1;
        crc_calculation_complete <= 1'b0;
      end else if (calculation_in_progress) begin
        calculation_in_progress  <= 1'b0;
        crc_calculation_complete <= 1'b1;
      end else begin
        crc_calculation_complete <= 1'b0;
      end
    end
  end

  // Output assignment
  assign crc_checksum_output = crc_register_current;

  // Display messages for debugging
  initial $display("CRC Calculator Design Module Initialized");
  
  always @(posedge crc_calculation_complete) begin
    $display("CRC calculation complete! Checksum: 0x%02h", 
             crc_checksum_output);
  end

endmodule