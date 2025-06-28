// pattern_generator_design.sv
module pattern_generator_design (
  input  logic       clock_signal,
  input  logic       reset_signal,
  input  logic [1:0] pattern_select,
  output logic [7:0] test_pattern_output
);

  logic [7:0] counter_value;
  
  // Counter for pattern generation
  always_ff @(posedge clock_signal or posedge reset_signal) begin
    if (reset_signal) begin
      counter_value <= 8'h00;
    end else begin
      counter_value <= counter_value + 1;
    end
  end
  
  // Pattern generation task
  task automatic generate_test_patterns(
    input  logic [1:0] select_input,
    input  logic [7:0] count_input,
    output logic [7:0] pattern_output
  );
    case (select_input)
      2'b00: pattern_output = count_input;              // Incrementing
      2'b01: pattern_output = ~count_input;             // Inverted
      2'b10: pattern_output = {count_input[0], 
                               count_input[1], 
                               count_input[2], 
                               count_input[3],
                               count_input[4], 
                               count_input[5], 
                               count_input[6], 
                               count_input[7]};         // Bit-reversed
      2'b11: pattern_output = count_input ^ 8'hAA;     // XOR pattern
    endcase
  endtask
  
  // Apply pattern generation
  always_comb begin
    generate_test_patterns(pattern_select, counter_value, 
                          test_pattern_output);
  end

endmodule