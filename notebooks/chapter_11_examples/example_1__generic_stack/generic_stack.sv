// generic_stack.sv
package stack_pkg;

  // Generic stack class with parameterized depth and data width
  class generic_stack #(
    parameter int DEPTH = 8,
    parameter int DATA_WIDTH = 32
  );
    
    // Stack storage array
    logic [DATA_WIDTH-1:0] stack_data[DEPTH];
    
    // Stack pointer (points to next free location)
    int stack_pointer;
    
    // Constructor
    function new();
      stack_pointer = 0;
      $display("Stack created: depth=%0d, data_width=%0d", 
               DEPTH, DATA_WIDTH);
    endfunction
    
    // Push data onto stack
    function bit push(logic [DATA_WIDTH-1:0] data);
      if (stack_pointer >= DEPTH) begin
        $display("ERROR: Stack overflow! Cannot push 0x%0h", data);
        return 0;
      end
      
      stack_data[stack_pointer] = data;
      stack_pointer++;
      $display("Pushed: 0x%0h (stack size: %0d)", data, stack_pointer);
      return 1;
    endfunction
    
    // Pop data from stack
    function bit pop(output logic [DATA_WIDTH-1:0] data);
      if (stack_pointer == 0) begin
        $display("ERROR: Stack underflow! Cannot pop from empty stack");
        return 0;
      end
      
      stack_pointer--;
      data = stack_data[stack_pointer];
      $display("Popped: 0x%0h (stack size: %0d)", data, stack_pointer);
      return 1;
    endfunction
    
    // Get current stack size
    function int size();
      return stack_pointer;
    endfunction
    
    // Check if stack is empty
    function bit is_empty();
      return (stack_pointer == 0);
    endfunction
    
    // Check if stack is full
    function bit is_full();
      return (stack_pointer >= DEPTH);
    endfunction
    
    // Display stack contents
    function void display();
      $display("Stack contents (size: %0d/%0d):", stack_pointer, DEPTH);
      if (stack_pointer == 0) begin
        $display("  [empty]");
      end else begin
        for (int i = stack_pointer - 1; i >= 0; i--) begin
          $display("  [%0d]: 0x%0h", i, stack_data[i]);
        end
      end
    endfunction
    
  endclass

endpackage

// Top-level module for design under test
module generic_stack_design();
  import stack_pkg::*;
  
  // Create different stack instances
  generic_stack #(.DEPTH(4), .DATA_WIDTH(8))  byte_stack;
  generic_stack #(.DEPTH(8), .DATA_WIDTH(16)) word_stack;
  generic_stack #(.DEPTH(16), .DATA_WIDTH(32)) dword_stack;
  
  initial begin
    $display("=== Generic Stack Design Demo ===");
    $display();
    
    // Create stack instances
    byte_stack = new();
    word_stack = new();
    dword_stack = new();
    
    $display();
    $display("Stack instances created successfully");
  end
  
endmodule