// generic_stack_testbench.sv
module generic_stack_test_bench;
  import stack_pkg::*;
  
  // Instantiate design under test
  generic_stack_design DESIGN_INSTANCE();
  
  // Test variables
  generic_stack #(.DEPTH(4), .DATA_WIDTH(8)) test_stack;
  logic [7:0] popped_data;
  bit success;
  
  initial begin
    // Setup wave dumping
    $dumpfile("generic_stack_test_bench.vcd");
    $dumpvars(0, generic_stack_test_bench);
    
    $display("=== Generic Stack Testbench ===");
    $display();
    
    // Create test stack
    test_stack = new();
    $display();
    
    // Test 1: Push operations
    $display("--- Test 1: Push Operations ---");
    success = test_stack.push(8'hAA);
    success = test_stack.push(8'hBB);
    success = test_stack.push(8'hCC);
    test_stack.display();
    $display();
    
    // Test 2: Pop operations
    $display("--- Test 2: Pop Operations ---");
    success = test_stack.pop(popped_data);
    success = test_stack.pop(popped_data);
    test_stack.display();
    $display();
    
    // Test 3: Stack overflow
    $display("--- Test 3: Stack Overflow Test ---");
    success = test_stack.push(8'h11);
    success = test_stack.push(8'h22);
    success = test_stack.push(8'h33);
    success = test_stack.push(8'h44);  // This should cause overflow
    test_stack.display();
    $display();
    
    // Test 4: Stack underflow
    $display("--- Test 4: Stack Underflow Test ---");
    // Empty the stack first
    while (!test_stack.is_empty()) begin
      success = test_stack.pop(popped_data);
    end
    // Try to pop from empty stack
    success = test_stack.pop(popped_data);  // This should cause underflow
    test_stack.display();
    $display();
    
    // Test 5: Different stack sizes
    $display("--- Test 5: Different Stack Configurations ---");
    begin
      generic_stack #(.DEPTH(2), .DATA_WIDTH(16)) small_stack;
      generic_stack #(.DEPTH(8), .DATA_WIDTH(32)) large_stack;
      
      small_stack = new();
      large_stack = new();
      
      // Test small stack
      success = small_stack.push(16'h1234);
      success = small_stack.push(16'h5678);
      small_stack.display();
      
      // Test large stack
      success = large_stack.push(32'hDEADBEEF);
      success = large_stack.push(32'hCAFEBABE);
      large_stack.display();
    end
    $display();
    
    // Test 6: Status functions
    $display("--- Test 6: Status Functions ---");
    $display("Stack size: %0d", test_stack.size());
    $display("Is empty: %0b", test_stack.is_empty());
    $display("Is full: %0b", test_stack.is_full());
    
    success = test_stack.push(8'hFF);
    $display("After push - size: %0d, empty: %0b, full: %0b", 
             test_stack.size(), test_stack.is_empty(), 
             test_stack.is_full());
    
    $display();
    $display("=== Testbench Complete ===");
    
    #10;  // Wait a bit for wave dump
    $finish;
  end
  
endmodule