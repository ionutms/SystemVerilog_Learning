// stack_processor.sv
module stack_processor;                    // Stack implementation module

  // Stack parameters
  parameter int STACK_DEPTH = 8;
  parameter int DATA_WIDTH = 16;
  
  // Stack storage and pointer
  logic [DATA_WIDTH-1:0] memory_stack [STACK_DEPTH-1:0];
  int stack_pointer;
  
  // Initialize stack
  initial begin
    stack_pointer = 0;
    $display("Stack Processor: Initialized with depth=%0d, width=%0d",
             STACK_DEPTH, DATA_WIDTH);
  end

  // Automatic function to push data onto stack
  function automatic logic push_data_onto_stack(
    input logic [DATA_WIDTH-1:0] push_value
  );
    // Local variables with automatic scope
    logic operation_success;
    int current_depth;
    
    current_depth = stack_pointer;  // Capture current state
    
    if (current_depth < STACK_DEPTH) begin
      memory_stack[current_depth] = push_value;
      stack_pointer++;
      operation_success = 1'b1;
      $display("  PUSH: 0x%04h at position %0d (depth now %0d)",
               push_value, current_depth, stack_pointer);
    end else begin
      operation_success = 1'b0;
      $display("  PUSH FAILED: Stack overflow! Depth=%0d", current_depth);
    end
    
    return operation_success;
  endfunction

  // Automatic function to pop data from stack
  function automatic logic [DATA_WIDTH-1:0] pop_data_from_stack(
    output logic pop_success
  );
    // Local variables with automatic scope
    logic [DATA_WIDTH-1:0] popped_value;
    int current_depth;
    
    current_depth = stack_pointer;  // Capture current state
    
    if (current_depth > 0) begin
      stack_pointer--;
      popped_value = memory_stack[stack_pointer];
      pop_success = 1'b1;
      $display("  POP:  0x%04h from position %0d (depth now %0d)",
               popped_value, stack_pointer, stack_pointer);
    end else begin
      popped_value = '0;
      pop_success = 1'b0;
      $display("  POP FAILED: Stack underflow! Depth=%0d", current_depth);
    end
    
    return popped_value;
  endfunction

  // Automatic function to peek at top of stack
  function automatic logic [DATA_WIDTH-1:0] peek_stack_top(
    output logic peek_valid
  );
    // Local variables with automatic scope
    logic [DATA_WIDTH-1:0] top_value;
    int current_depth;
    
    current_depth = stack_pointer;  // Capture current state
    
    if (current_depth > 0) begin
      top_value = memory_stack[current_depth - 1];
      peek_valid = 1'b1;
      $display("  PEEK: 0x%04h at top (position %0d)",
               top_value, current_depth - 1);
    end else begin
      top_value = '0;
      peek_valid = 1'b0;
      $display("  PEEK FAILED: Stack empty! Depth=%0d", current_depth);
    end
    
    return top_value;
  endfunction

  // Function to display current stack status
  function automatic void display_stack_status();
    // Local variables with automatic scope
    string status_message;
    int items_count;
    
    items_count = stack_pointer;
    
    if (items_count == 0) begin
      status_message = "EMPTY";
    end else if (items_count == STACK_DEPTH) begin
      status_message = "FULL";
    end else begin
      status_message = $sformatf("%0d/%0d", items_count, STACK_DEPTH);
    end
    
    $display("Stack Status: %s (pointer=%0d)", status_message, items_count);
  endfunction

endmodule