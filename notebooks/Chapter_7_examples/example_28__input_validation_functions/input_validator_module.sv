// input_validator_module.sv
module input_validator_module ();

  // Function to validate range with multiple return points
  function automatic logic validate_range(input logic [7:0] data_value,
                                          input logic [7:0] min_limit,
                                          input logic [7:0] max_limit);
    // Check if minimum is greater than maximum (invalid range)
    if (min_limit > max_limit) begin
      $display("ERROR: Invalid range - min (%0d) > max (%0d)", 
               min_limit, max_limit);
      return 1'b0;  // Return failure immediately
    end
    
    // Check if value is below minimum
    if (data_value < min_limit) begin
      $display("WARNING: Value %0d below minimum %0d", 
               data_value, min_limit);
      return 1'b0;  // Return failure immediately
    end
    
    // Check if value is above maximum
    if (data_value > max_limit) begin
      $display("WARNING: Value %0d above maximum %0d", 
               data_value, max_limit);
      return 1'b0;  // Return failure immediately
    end
    
    // Value is within valid range
    $display("SUCCESS: Value %0d is within range [%0d:%0d]", 
             data_value, min_limit, max_limit);
    return 1'b1;  // Return success
  endfunction

  // Function to validate password strength with multiple criteria
  function automatic logic [1:0] check_password_strength(
                                   input logic [31:0] password_length,
                                   input logic has_uppercase_char,
                                   input logic has_number_digit,
                                   input logic has_special_symbol);
    
    // Check minimum length requirement first
    if (password_length < 8) begin
      $display("WEAK: Password too short (%0d chars)", password_length);
      return 2'b00;  // Return weak immediately
    end
    
    // Check for uppercase requirement
    if (!has_uppercase_char) begin
      $display("WEAK: Missing uppercase character");
      return 2'b00;  // Return weak immediately
    end
    
    // Determine strength based on remaining criteria
    if (has_number_digit && has_special_symbol) begin
      $display("STRONG: All criteria met (len=%0d)", password_length);
      return 2'b10;  // Return strong
    end else if (has_number_digit || has_special_symbol) begin
      $display("MEDIUM: Some criteria met (len=%0d)", password_length);
      return 2'b01;  // Return medium
    end else begin
      $display("WEAK: Missing numbers and symbols");
      return 2'b00;  // Return weak
    end
  endfunction

  initial begin
    logic        validation_result;
    logic [1:0]  strength_rating;
    
    $display("=== Input Validation Functions Demo ===");
    $display();
    
    // Test range validation function
    $display("--- Range Validation Tests ---");
    validation_result = validate_range(50, 10, 100);
    validation_result = validate_range(5, 10, 100);
    validation_result = validate_range(150, 10, 100);
    validation_result = validate_range(75, 100, 50);  // Invalid range
    $display();
    
    // Test password strength function
    $display("--- Password Strength Tests ---");
    strength_rating = check_password_strength(12, 1'b1, 1'b1, 1'b1);
    strength_rating = check_password_strength(10, 1'b1, 1'b1, 1'b0);
    strength_rating = check_password_strength(8, 1'b1, 1'b0, 1'b0);
    strength_rating = check_password_strength(6, 1'b0, 1'b1, 1'b1);
    strength_rating = check_password_strength(8, 1'b0, 1'b0, 1'b0);
    $display();
  end

endmodule