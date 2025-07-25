// null_handle_safety_design.sv
// Chapter 11 Example 28: Null Handle Safety

package safe_packet_pkg;
  
  // Simple packet class for demonstration
  class SafePacket;
    protected int packet_id;
    protected string packet_data;
    
    function new(int id = 0, string data = "");
      this.packet_id = id;
      this.packet_data = data;
    endfunction
    
    function void display_packet();
      $display("Packet ID: %0d, Data: %s", packet_id, packet_data);
    endfunction
    
    function string get_data();
      return packet_data;
    endfunction
    
    function int get_id();
      return packet_id;
    endfunction
  endclass
  
  // Manager class that handles packet objects safely
  class SafePacketManager;
    protected SafePacket packet_queue[$];
    
    // Safe method to add packet with null checking
    function void add_packet(SafePacket pkt);
      if (pkt == null) begin
        $display("ERROR: Cannot add null packet to queue");
        return;
      end
      packet_queue.push_back(pkt);
      $display("Successfully added packet ID: %0d", pkt.get_id());
    endfunction
    
    // Safe method to get packet with null checking
    function SafePacket get_packet();
      SafePacket retrieved_pkt;
      
      if (packet_queue.size() == 0) begin
        $display("WARNING: Queue is empty, returning null");
        return null;
      end
      
      retrieved_pkt = packet_queue.pop_front();
      if (retrieved_pkt == null) begin
        $display("ERROR: Retrieved null packet from queue");
        return null;
      end
      
      return retrieved_pkt;
    endfunction
    
    // Safe method to process packet with comprehensive null checking
    function void process_packet(SafePacket pkt);
      if (pkt == null) begin
        $display("ERROR: Cannot process null packet");
        return;
      end
      
      $display("Processing packet safely:");
      pkt.display_packet();
    endfunction
    
    // Safe method to copy packet data with null checking
    function string safe_get_packet_data(SafePacket pkt);
      if (pkt == null) begin
        $display("WARNING: Null packet handle, returning empty string");
        return "";
      end
      return pkt.get_data();
    endfunction
    
    function int get_queue_size();
      return packet_queue.size();
    endfunction
  endclass

endpackage

module null_handle_safety_design;
  import safe_packet_pkg::*;
  
  SafePacketManager manager;
  SafePacket test_packet;
  SafePacket null_packet;
  
  initial begin
    $display("=== Null Handle Safety Demonstration ===");
    $display();
    
    // Create manager instance
    manager = new();
    
    // Test 1: Try to add null packet
    $display("Test 1: Adding null packet");
    manager.add_packet(null_packet);  // null_packet is null
    $display();
    
    // Test 2: Create valid packet and add it
    $display("Test 2: Adding valid packet");
    test_packet = new(42, "Hello World");
    manager.add_packet(test_packet);
    $display();
    
    // Test 3: Try to get packet from empty queue (after adding one)
    $display("Test 3: Getting packet from queue");
    test_packet = manager.get_packet();
    if (test_packet != null) begin
      $display("Successfully retrieved packet");
      manager.process_packet(test_packet);
    end
    $display();
    
    // Test 4: Try to get packet from empty queue
    $display("Test 4: Getting packet from empty queue");
    test_packet = manager.get_packet();
    manager.process_packet(test_packet);  // Should handle null safely
    $display();
    
    // Test 5: Safe data access with null checking
    $display("Test 5: Safe data access");
    $display("Data from null packet: '%s'", 
             manager.safe_get_packet_data(null_packet));
    
    test_packet = new(99, "Test Data");
    $display("Data from valid packet: '%s'", 
             manager.safe_get_packet_data(test_packet));
    $display();
    
    $display("=== Null Handle Safety Demo Complete ===");
  end

endmodule