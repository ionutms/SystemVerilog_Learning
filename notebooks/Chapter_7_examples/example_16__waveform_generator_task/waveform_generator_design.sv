// waveform_generator_design.sv
module waveform_generator_module (
  input  logic       clock_signal,
  input  logic       reset_signal,
  input  logic [1:0] waveform_type_select,
  output logic       generated_waveform_output
);

  logic [3:0] internal_counter;
  
  // Counter for waveform generation
  always_ff @(posedge clock_signal or posedge reset_signal) begin
    if (reset_signal) begin
      internal_counter <= 4'h0;
    end else begin
      internal_counter <= internal_counter + 1'b1;
    end
  end
  
  // Waveform generation based on type selection
  always_comb begin
    case (waveform_type_select)
      2'b00: // Square wave (50% duty cycle)
        generated_waveform_output = internal_counter[3];
      2'b01: // Triangle wave approximation (using counter bits)
        generated_waveform_output = internal_counter[2] ^ internal_counter[3];
      2'b10: // Sawtooth wave (using MSB)
        generated_waveform_output = internal_counter[3];
      2'b11: // Pulse wave (25% duty cycle)
        generated_waveform_output = (internal_counter < 4'h4);
      default:
        generated_waveform_output = 1'b0;
    endcase
  end

endmodule