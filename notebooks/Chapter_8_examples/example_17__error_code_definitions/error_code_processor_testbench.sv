// error_code_processor_testbench.sv
module error_code_processor_testbench;

  // Clock and reset
  logic        clk;
  logic        reset_n;
  
  // DUT signals
  logic [2:0]  operation;
  logic [7:0]  data_a;
  logic [7:0]  data_b;
  logic [7:0]  result;
  logic [3:0]  error_code;

  // Error code names for display
  string error_name;
  
  // Instantiate design under test
  error_code_processor DUT (
    .clk(clk),
    .reset_n(reset_n),
    .operation(operation),
    .data_a(data_a),
    .data_b(data_b),
    .result(result),
    .error_code(error_code)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Function to convert error code to readable name
  function string get_error_name(logic [3:0] code);
    case (code)
      4'h0: return "ERR_NONE";
      4'h1: return "ERR_DIVIDE_ZERO";
      4'h2: return "ERR_OVERFLOW";
      4'h3: return "ERR_UNDERFLOW";
      4'h4: return "ERR_INVALID_OP";
      4'h5: return "ERR_OUT_OF_RANGE";
      4'h6: return "ERR_TIMEOUT";
      4'hF: return "ERR_UNKNOWN";
      default: return "UNDEFINED";
    endcase
  endfunction

  // Test stimulus
  initial begin
    // Dump waves
    $dumpfile("error_code_processor_testbench.vcd");
    $dumpvars(0, error_code_processor_testbench);
    
    $display();
    $display("=== Error Code Definitions Test ===");
    $display();
    
    // Initialize
    reset_n = 0;
    operation = 3'b000;
    data_a = 8'h00;
    data_b = 8'h00;
    
    // Reset
    #10 reset_n = 1;
    #10;
    
    // Test 1: Normal addition (no error)
    operation = 3'b000;  // ADD
    data_a = 8'h10;
    data_b = 8'h05;
    #10;
    error_name = get_error_name(error_code);
    $display("Test 1 - ADD: %0d + %0d = %0d, Error: %s", 
             data_a, data_b, result, error_name);
    
    // Test 2: Addition overflow
    operation = 3'b000;  // ADD
    data_a = 8'hFF;
    data_b = 8'h01;
    #10;
    error_name = get_error_name(error_code);
    $display("Test 2 - ADD Overflow: %0d + %0d = %0d, Error: %s", 
             data_a, data_b, result, error_name);
    
    // Test 3: Subtraction underflow
    operation = 3'b001;  // SUB
    data_a = 8'h05;
    data_b = 8'h10;
    #10;
    error_name = get_error_name(error_code);
    $display("Test 3 - SUB Underflow: %0d - %0d = %0d, Error: %s", 
             data_a, data_b, result, error_name);
    
    // Test 4: Division by zero
    operation = 3'b011;  // DIV
    data_a = 8'h20;
    data_b = 8'h00;
    #10;
    error_name = get_error_name(error_code);
    $display("Test 4 - DIV by Zero: %0d / %0d = %0d, Error: %s", 
             data_a, data_b, result, error_name);
    
    // Test 5: Multiplication overflow
    operation = 3'b010;  // MUL
    data_a = 8'h20;
    data_b = 8'h10;
    #10;
    error_name = get_error_name(error_code);
    $display("Test 5 - MUL Overflow: %0d * %0d = %0d, Error: %s", 
             data_a, data_b, result, error_name);
    
    // Test 6: Invalid operation
    operation = 3'b111;  // Invalid
    data_a = 8'h10;
    data_b = 8'h05;
    #10;
    error_name = get_error_name(error_code);
    $display("Test 6 - Invalid Op: op=%b, Error: %s", 
             operation, error_name);
    
    // Test 7: Out of range (SQRT)
    operation = 3'b101;  // SQRT
    data_a = 8'hFF;      // Too large for sqrt
    data_b = 8'h00;
    #10;
    error_name = get_error_name(error_code);
    $display("Test 7 - Out of Range: sqrt(%0d), Error: %s", 
             data_a, error_name);
    
    $display();
    $display("=== Error Code Test Complete ===");
    $display();
    
    #20 $finish;
  end

endmodule