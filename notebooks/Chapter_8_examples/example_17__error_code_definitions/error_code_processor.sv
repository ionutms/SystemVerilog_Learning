// error_code_processor.sv
module error_code_processor (
  input  logic        clk,
  input  logic        reset_n,
  input  logic [2:0]  operation,
  input  logic [7:0]  data_a,
  input  logic [7:0]  data_b,
  output logic [7:0]  result,
  output logic [3:0]  error_code
);

  // Error code enumeration with meaningful names
  typedef enum logic [3:0] {
    ERR_NONE         = 4'h0,  // No error
    ERR_DIVIDE_ZERO  = 4'h1,  // Division by zero
    ERR_OVERFLOW     = 4'h2,  // Arithmetic overflow
    ERR_UNDERFLOW    = 4'h3,  // Arithmetic underflow
    ERR_INVALID_OP   = 4'h4,  // Invalid operation
    ERR_OUT_OF_RANGE = 4'h5,  // Input out of range
    ERR_TIMEOUT      = 4'h6,  // Operation timeout
    ERR_UNKNOWN      = 4'hF   // Unknown error
  } error_code_t;

  // Operation codes
  typedef enum logic [2:0] {
    OP_ADD     = 3'b000,
    OP_SUB     = 3'b001,
    OP_MUL     = 3'b010,
    OP_DIV     = 3'b011,
    OP_MOD     = 3'b100,
    OP_SQRT    = 3'b101
  } operation_t;

  error_code_t current_error;
  logic [15:0] temp_result;

  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      result        <= 8'h00;
      current_error <= ERR_NONE;
    end else begin
      current_error <= ERR_NONE;  // Default to no error
      
      case (operation)
        OP_ADD: begin
          temp_result = {8'h00, data_a} + {8'h00, data_b};
          if (temp_result > 255) begin
            current_error <= ERR_OVERFLOW;
            result <= 8'hFF;  // Saturate to max value
          end else begin
            result <= temp_result[7:0];
          end
        end
        
        OP_SUB: begin
          if (data_a < data_b) begin
            current_error <= ERR_UNDERFLOW;
            result <= 8'h00;  // Saturate to min value
          end else begin
            result <= data_a - data_b;
          end
        end
        
        OP_MUL: begin
          temp_result = {8'h00, data_a} * {8'h00, data_b};
          if (temp_result > 255) begin
            current_error <= ERR_OVERFLOW;
            result <= 8'hFF;  // Saturate to max value
          end else begin
            result <= temp_result[7:0];
          end
        end
        
        OP_DIV: begin
          if (data_b == 0) begin
            current_error <= ERR_DIVIDE_ZERO;
            result <= 8'h00;  // Return 0 for divide by zero
          end else begin
            result <= data_a / data_b;
          end
        end
        
        OP_MOD: begin
          if (data_b == 0) begin
            current_error <= ERR_DIVIDE_ZERO;
            result <= 8'h00;  // Return 0 for divide by zero
          end else begin
            result <= data_a % data_b;
          end
        end
        
        OP_SQRT: begin
          if (data_a > 225) begin // sqrt(225) = 15, max for 8-bit result
            current_error <= ERR_OUT_OF_RANGE;
            result <= 8'h00;  // Return 0 for out of range
          end else begin
            result <= 8'h00;  // Simplified, just return 0
          end
        end
        
        default: begin
          current_error <= ERR_INVALID_OP;
          result <= 8'h00;
        end
      endcase
    end
  end

  assign error_code = current_error;

endmodule