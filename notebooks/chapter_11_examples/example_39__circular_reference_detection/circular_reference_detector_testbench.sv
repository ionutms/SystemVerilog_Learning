// circular_reference_detector_testbench.sv
module circular_reference_detector_testbench;
  import circular_ref_pkg::*;
  
  // Instantiate design under test
  circular_reference_detector_module DUT();
  
  // Additional test scenarios
  CircularRefDetector advanced_detector;
  Node test_nodes[5];
  
  initial begin
    // Dump waves
    $dumpfile("circular_reference_detector_testbench.vcd");
    $dumpvars(0, circular_reference_detector_testbench);
    
    #1; // Wait for DUT to complete
    
    $display("=== Advanced Testbench Scenarios ===");
    
    // Test Case 4: Complex network with multiple paths
    $display();
    $display("Test Case 4: Complex network");
    advanced_detector = new();
    
    // Create nodes
    for (int i = 0; i < 5; i++) begin
      test_nodes[i] = new($sformatf("Node%0d", i));
      advanced_detector.add_node(test_nodes[i]);
    end
    
    // Create complex structure: 0->1->2->3->4 and 2->0 (cycle)
    test_nodes[0].set_next(test_nodes[1]);
    test_nodes[1].set_next(test_nodes[2]);
    test_nodes[2].set_next(test_nodes[3]);
    test_nodes[3].set_next(test_nodes[4]);
    // Initially no cycle
    
    advanced_detector.display_structure();
    
    if (advanced_detector.has_circular_reference()) begin
      $display("Result: Circular reference found!");
    end else begin
      $display("Result: No circular reference detected.");
    end
    
    // Add cycle
    $display();
    $display("Adding cycle: Node2 -> Node0");
    test_nodes[2].set_next(test_nodes[0]);
    
    advanced_detector.display_structure();
    
    if (advanced_detector.has_circular_reference()) begin
      $display("Result: Circular reference found!");
    end else begin
      $display("Result: No circular reference detected.");
    end
    
    // Test Case 5: Breaking the cycle
    $display();
    $display("Test Case 5: Breaking cycle by setting Node2 -> null");
    test_nodes[2].set_next(null);
    
    advanced_detector.display_structure();
    
    if (advanced_detector.has_circular_reference()) begin
      $display("Result: Circular reference found!");
    end else begin
      $display("Result: No circular reference detected.");
    end
    
    // Test verification messages
    $display();
    $display("=== Testbench Verification ===");
    $display("Linear chain test completed");
    $display("Circular reference creation test completed");
    $display("Self-reference test completed");
    $display("Complex network test completed");
    $display("Cycle breaking test completed");
    
    $display();
    $display("Hello from testbench!");
    $display("All circular reference detection tests completed!");
    $display();
    
    $finish;
  end
  
endmodule