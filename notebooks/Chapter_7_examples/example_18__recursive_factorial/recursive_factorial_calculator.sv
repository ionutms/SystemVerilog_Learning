// recursive_factorial_calculator.sv
module recursive_factorial_calculator_module;

  // Automatic function for recursive factorial calculation
  function automatic int unsigned calculate_factorial(int unsigned input_number);
    if (input_number <= 1) begin
      return 1;  // Base case: factorial of 0 or 1 is 1
    end else begin
      // Recursive case: n! = n * (n-1)!
      return input_number * calculate_factorial(input_number - 1);
    end
  endfunction

  // Function to demonstrate tree-like traversal depth
  function automatic int unsigned calculate_tree_depth(int unsigned tree_nodes);
    if (tree_nodes <= 1) begin
      return 0;  // Base case: single node has depth 0
    end else begin
      // Recursive case: depth increases with each level
      return 1 + calculate_tree_depth(tree_nodes / 2);
    end
  endfunction

  initial begin
    int unsigned factorial_result;
    int unsigned tree_depth_result;
    
    $display("=== Recursive Factorial Calculator ===");
    $display();
    
    // Test factorial calculations
    for (int i = 0; i <= 6; i++) begin
      factorial_result = calculate_factorial(i);
      $display("Factorial of %0d = %0d", i, factorial_result);
    end
    
    $display();
    $display("=== Tree Depth Calculator ===");
    
    // Test tree depth calculations
    for (int nodes = 1; nodes <= 16; nodes *= 2) begin
      tree_depth_result = calculate_tree_depth(nodes);
      $display("Tree with %0d nodes has depth %0d", nodes, tree_depth_result);
    end
    
    $display();
  end

endmodule