// error_handler_processor_testbench.sv
module error_handler_testbench;

  // Error codes as parameters matching the design
  localparam logic [2:0] ERROR_NONE        = 3'b000;
  localparam logic [2:0] ERROR_DIVIDE_ZERO = 3'b001;
  localparam logic [2:0] ERROR_OVERFLOW    = 3'b010;
  localparam logic [2:0] ERROR_UNDERFLOW   = 3'b011;
  localparam logic [2:0] ERROR_INVALID_OP  = 3'b100;

  // Instantiate design under test
  arithmetic_error_handler ERROR_HANDLER_INSTANCE();

  // Test variables
  logic [15:0] division_result;
  logic [8:0] addition_result;
  logic validation_result;
  logic [2:0] error_status;

  // Function to convert error code to string for display
  function automatic string error_code_to_string(input logic [2:0] code);
    case (code)
      ERROR_NONE:        return "ERROR_NONE";
      ERROR_DIVIDE_ZERO: return "ERROR_DIVIDE_ZERO";
      ERROR_OVERFLOW:    return "ERROR_OVERFLOW";
      ERROR_UNDERFLOW:   return "ERROR_UNDERFLOW";
      ERROR_INVALID_OP:  return "ERROR_INVALID_OP";
      default:           return "UNKNOWN_ERROR";
    endcase
  endfunction

  initial begin
    // Dump waves
    $dumpfile("error_handler_testbench.vcd");
    $dumpvars(0, error_handler_testbench);

    $display("=== Testing Error Handling Functions ===");
    $display();

    // Test 1: Safe division - normal operation
    $display("Test 1: Normal Division");
    division_result = ERROR_HANDLER_INSTANCE.safe_divide_function(
      8'd20, 8'd4, error_status);
    $display("Result: %0d, Error: %s", division_result, 
             error_code_to_string(error_status));
    $display();

    // Test 2: Safe division - divide by zero error
    $display("Test 2: Division by Zero Error");
    division_result = ERROR_HANDLER_INSTANCE.safe_divide_function(
      8'd15, 8'd0, error_status);
    $display("Result: 0x%04X, Error: %s", division_result, 
             error_code_to_string(error_status));
    $display();

    // Test 3: Safe addition - normal operation
    $display("Test 3: Normal Addition");
    addition_result = ERROR_HANDLER_INSTANCE.safe_add_function(
      8'd100, 8'd50, error_status);
    $display("Result: %0d, Error: %s", addition_result[7:0], 
             error_code_to_string(error_status));
    $display();

    // Test 4: Safe addition - overflow error
    $display("Test 4: Addition Overflow Error");
    addition_result = ERROR_HANDLER_INSTANCE.safe_add_function(
      8'd200, 8'd100, error_status);
    $display("Result: %0d (truncated to 8-bit), Error: %s", 
             addition_result[7:0], error_code_to_string(error_status));
    $display();

    // Test 5: Input validation - valid range
    $display("Test 5: Input Validation - Valid Range");
    validation_result = ERROR_HANDLER_INSTANCE.validate_input_range_function(
      8'd75, 8'd10, 8'd100, error_status);
    $display("Valid: %b, Error: %s", validation_result, 
             error_code_to_string(error_status));
    $display();

    // Test 6: Input validation - invalid range (too low)
    $display("Test 6: Input Validation - Below Range");
    validation_result = ERROR_HANDLER_INSTANCE.validate_input_range_function(
      8'd5, 8'd10, 8'd100, error_status);
    $display("Valid: %b, Error: %s", validation_result, 
             error_code_to_string(error_status));
    $display();

    // Test 7: Input validation - invalid range (too high)
    $display("Test 7: Input Validation - Above Range");
    validation_result = ERROR_HANDLER_INSTANCE.validate_input_range_function(
      8'd150, 8'd10, 8'd100, error_status);
    $display("Valid: %b, Error: %s", validation_result, 
             error_code_to_string(error_status));
    $display();

    $display("=== Error Handling Functions Test Complete ===");
    #1;  // Wait for a time unit
    $finish;
  end

endmodule