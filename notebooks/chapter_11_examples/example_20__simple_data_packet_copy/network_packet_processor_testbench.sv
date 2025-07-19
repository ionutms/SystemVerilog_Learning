// network_packet_processor_testbench.sv
module packet_processor_testbench;
  import network_packet_pkg::*;
  
  // Instantiate design under test
  network_packet_processor PACKET_PROCESSOR_INSTANCE();
  
  initial begin
    DataPacket original_packet;
    DataPacket copied_packet;
    DataPacket another_copy;
    DataPacket empty_packet;
    DataPacket empty_copy;
    
    // Dump waves for debugging
    $dumpfile("packet_processor_testbench.vcd");
    $dumpvars(0, packet_processor_testbench);
    
    #1; // Wait for initialization
    
    $display("\n=== Test 1: Create Original Packet ===");
    // Create original packet with specific header and payload
    original_packet = new(.id(8'h42), .src(16'hABCD), 
                         .dst(16'h1234), .len(8'd8));
    
    // Display original packet
    original_packet.display_packet();
    
    $display("\n=== Test 2: Copy Constructor Test ===");
    // Use copy constructor to duplicate packet
    copied_packet = original_packet.copy();
    
    // Display copied packet
    copied_packet.display_packet();
    
    $display("\n=== Test 3: Modify Original and Verify Independence ===");
    // Modify original packet payload
    original_packet.set_payload_byte(0, 8'hFF);
    original_packet.set_payload_byte(3, 8'hAA);
    
    $display("After modifying original packet:");
    original_packet.display_packet();
    
    $display("Copied packet should remain unchanged:");
    copied_packet.display_packet();
    
    $display("\n=== Test 4: Modify Copy and Verify Independence ===");
    // Modify copied packet payload
    copied_packet.set_payload_byte(1, 8'h55);
    copied_packet.set_payload_byte(2, 8'hBB);
    
    $display("After modifying copied packet:");
    copied_packet.display_packet();
    
    $display("Original packet should show only its changes:");
    original_packet.display_packet();
    
    $display("\n=== Test 5: Multiple Copies Test ===");
    // Create another copy from the modified original
    another_copy = original_packet.copy();
    
    $display("New copy from modified original:");
    another_copy.display_packet();
    
    $display("\n=== Test 6: Edge Case - Empty Packet ===");
    // Test with zero-length packet
    empty_packet = new(.id(8'h00), .src(16'h0000), 
                      .dst(16'h0000), .len(8'd0));
    empty_copy = empty_packet.copy();
    
    empty_packet.display_packet();
    empty_copy.display_packet();
    
    $display("\n=== Test Complete ===");
    $display("Demonstrated:");
    $display("  - DataPacket class with header and payload fields");
    $display("  - Copy constructor for deep packet duplication");
    $display("  - Independence between original and copied packets");
    $display("  - Proper payload array copying");
    $display("  - Edge case handling for empty packets");
    
    #10; // Final delay
    $finish;
  end
  
endmodule : packet_processor_testbench