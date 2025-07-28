// circular_reference_detector.sv
package circular_ref_pkg;
  
  // Simple node class that can reference other nodes
  class Node;
    string name;
    Node next_node;
    bit visited;
    bit in_stack;
    
    function new(string node_name);
      this.name = node_name;
      this.next_node = null;
      this.visited = 0;
      this.in_stack = 0;
    endfunction
    
    function void set_next(Node next);
      this.next_node = next;
    endfunction
    
    function void reset_flags();
      this.visited = 0;
      this.in_stack = 0;
    endfunction
  endclass
  
  // Circular reference detector class
  class CircularRefDetector;
    Node node_list[$];
    
    function void add_node(Node node);
      node_list.push_back(node);
    endfunction
    
    function void reset_all_flags();
      foreach(node_list[i]) begin
        node_list[i].reset_flags();
      end
    endfunction
    
    // Depth-first search to detect circular references
    function bit detect_cycle_from_node(Node current);
      if (current == null) return 0;
      
      if (current.in_stack) begin
        $display("Circular reference detected involving node: %s", 
                 current.name);
        return 1;
      end
      
      if (current.visited) return 0;
      
      current.visited = 1;
      current.in_stack = 1;
      
      if (detect_cycle_from_node(current.next_node)) begin
        return 1;
      end
      
      current.in_stack = 0;
      return 0;
    endfunction
    
    function bit has_circular_reference();
      bit cycle_found = 0;
      
      reset_all_flags();
      
      foreach(node_list[i]) begin
        if (!node_list[i].visited) begin
          if (detect_cycle_from_node(node_list[i])) begin
            cycle_found = 1;
          end
        end
      end
      
      return cycle_found;
    endfunction
    
    function void display_structure();
      $display("Node structure:");
      foreach(node_list[i]) begin
        if (node_list[i].next_node != null) begin
          $display("  %s -> %s", node_list[i].name, 
                   node_list[i].next_node.name);
        end else begin
          $display("  %s -> null", node_list[i].name);
        end
      end
    endfunction
  endclass
  
endpackage

module circular_reference_detector_module();
  import circular_ref_pkg::*;
  
  CircularRefDetector detector;
  Node nodeA, nodeB, nodeC, nodeD;
  
  initial begin
    $display();
    $display("=== Circular Reference Detection Example ===");
    
    // Create detector instance
    detector = new();
    
    // Test Case 1: No circular reference
    $display();
    $display("Test Case 1: Linear chain (no cycle)");
    nodeA = new("NodeA");
    nodeB = new("NodeB");
    nodeC = new("NodeC");
    
    nodeA.set_next(nodeB);
    nodeB.set_next(nodeC);
    // nodeC.next_node remains null
    
    detector.add_node(nodeA);
    detector.add_node(nodeB);
    detector.add_node(nodeC);
    
    detector.display_structure();
    
    if (detector.has_circular_reference()) begin
      $display("Result: Circular reference found!");
    end else begin
      $display("Result: No circular reference detected.");
    end
    
    // Test Case 2: Create circular reference
    $display();
    $display("Test Case 2: Creating circular reference");
    nodeC.set_next(nodeA);  // Create cycle: A->B->C->A
    
    detector.display_structure();
    
    if (detector.has_circular_reference()) begin
      $display("Result: Circular reference found!");
    end else begin
      $display("Result: No circular reference detected.");
    end
    
    // Test Case 3: Self-reference
    $display();
    $display("Test Case 3: Self-reference");
    detector = new();  // Reset detector
    nodeD = new("NodeD");
    nodeD.set_next(nodeD);  // Self-reference
    
    detector.add_node(nodeD);
    detector.display_structure();
    
    if (detector.has_circular_reference()) begin
      $display("Result: Circular reference found!");
    end else begin
      $display("Result: No circular reference detected.");
    end
    
    $display();
  end
  
endmodule