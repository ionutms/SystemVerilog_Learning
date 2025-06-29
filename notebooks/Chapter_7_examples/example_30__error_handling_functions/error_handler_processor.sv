// error_handler_processor.sv

module arithmetic_error_handler();

  // Error codes as parameters for easy access
  localparam logic [2:0] ERROR_NONE        = 3'b000;
  localparam logic [2:0] ERROR_DIVIDE_ZERO = 3'b001;
  localparam logic [2:0] ERROR_OVERFLOW    = 3'b010;
  localparam logic [2:0] ERROR_UNDERFLOW   = 3'b011;
  localparam logic [2:0] ERROR_INVALID_OP  = 3'b100;

  // Function: Safe division with error detection
  function automatic logic [15:0] safe_divide_function(
    input logic [7:0] dividend_input,
    input logic [7:0] divisor_input,
    output logic [2:0] error_status_output
  );
    logic [15:0] result_value;
    
    // Check for division by zero
    if (divisor_input == 8'h00) begin
      error_status_output = ERROR_DIVIDE_ZERO;
      result_value = 16'hFFFF;  // Error indicator value
      $display("ERROR: Division by zero detected!");
    end
    else begin
      error_status_output = ERROR_NONE;
      result_value = {8'h00, dividend_input} / {8'h00, divisor_input};
      $display("Division successful: %0d / %0d = %0d", 
               dividend_input, divisor_input, result_value);
    end
    
    return result_value;
  endfunction

  // Function: Safe addition with overflow detection
  function automatic logic [8:0] safe_add_function(
    input logic [7:0] operand_a_input,
    input logic [7:0] operand_b_input,
    output logic [2:0] error_status_output
  );
    logic [8:0] extended_result;
    
    extended_result = operand_a_input + operand_b_input;
    
    // Check for 8-bit overflow
    if (extended_result > 9'h0FF) begin
      error_status_output = ERROR_OVERFLOW;
      $display("ERROR: Addition overflow detected! %0d + %0d = %0d", 
               operand_a_input, operand_b_input, extended_result);
    end
    else begin
      error_status_output = ERROR_NONE;
      $display("Addition successful: %0d + %0d = %0d", 
               operand_a_input, operand_b_input, extended_result[7:0]);
    end
    
    return extended_result;
  endfunction

  // Function: Input validation with error return
  function automatic logic validate_input_range_function(
    input logic [7:0] data_input,
    input logic [7:0] min_boundary,
    input logic [7:0] max_boundary,
    output logic [2:0] error_status_output
  );
    logic validation_result;
    
    if (data_input < min_boundary || data_input > max_boundary) begin
      error_status_output = ERROR_INVALID_OP;
      validation_result = 1'b0;
      $display("ERROR: Input %0d outside valid range [%0d:%0d]", 
               data_input, min_boundary, max_boundary);
    end
    else begin
      error_status_output = ERROR_NONE;
      validation_result = 1'b1;
      $display("Input validation passed: %0d within [%0d:%0d]", 
               data_input, min_boundary, max_boundary);
    end
    
    return validation_result;
  endfunction

  initial begin
    $display("=== Error Handling Functions Demonstration ===");
    $display();
  end

endmodule