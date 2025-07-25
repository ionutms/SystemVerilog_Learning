// null_handle_safety_design_testbench.sv
// Testbench for Chapter 11 Example 28: Null Handle Safety

module null_handle_safety_testbench;
  import safe_packet_pkg::*;
  
  SafePacketManager test_manager;
  SafePacket packets[$];
  SafePacket retrieved_pkt;
  string result_data;
  
  // Instantiate design under test
  null_handle_safety_design DESIGN_INSTANCE();
  
  initial begin
    // Dump waves for debugging
    $dumpfile("null_handle_safety_testbench.vcd");
    $dumpvars(0, null_handle_safety_testbench);
    
    #1; // Wait for design to complete
    
    $display();
    $display("=== Testbench: Advanced Null Handle Safety Tests ===");
    $display();
    
    // Create test manager
    test_manager = new();
    
    // Test scenario 1: Multiple null operations
    $display("Scenario 1: Multiple null operations");
    test_manager.add_packet(null);
    test_manager.add_packet(null);
    $display("Queue size after null adds: %0d", 
             test_manager.get_queue_size());
    $display();
    
    // Test scenario 2: Mixed valid and null packets
    $display("Scenario 2: Mixed valid and null packets");
    retrieved_pkt = new(1, "First");
    packets.push_back(retrieved_pkt);
    packets.push_back(null);  // null in middle
    retrieved_pkt = new(3, "Third");
    packets.push_back(retrieved_pkt);
    
    foreach(packets[i]) begin
      $display("Adding packet index %0d:", i);
      test_manager.add_packet(packets[i]);
    end
    $display("Queue size: %0d", test_manager.get_queue_size());
    $display();
    
    // Test scenario 3: Safe retrieval and processing
    $display("Scenario 3: Safe retrieval and processing");
    while (test_manager.get_queue_size() > 0) begin
      retrieved_pkt = test_manager.get_packet();
      test_manager.process_packet(retrieved_pkt);
    end
    $display();
    
    // Test scenario 4: Chain of null-safe operations
    $display("Scenario 4: Chain of null-safe operations");
    retrieved_pkt = test_manager.get_packet();  // Should be null
    result_data = test_manager.safe_get_packet_data(retrieved_pkt);
    $display("Result from null chain: '%s'", result_data);
    $display();
    
    // Test scenario 5: Verify safety after null operations
    $display("Scenario 5: Recovery after null operations");
    retrieved_pkt = new(100, "Recovery packet");
    test_manager.add_packet(retrieved_pkt);
    retrieved_pkt = test_manager.get_packet();
    if (retrieved_pkt != null) begin
      $display("Successfully recovered with valid packet:");
      test_manager.process_packet(retrieved_pkt);
    end
    $display();
    
    $display("=== All Null Handle Safety Tests Complete ===");
    $display();
    
    #10;
    $finish;
  end

endmodule