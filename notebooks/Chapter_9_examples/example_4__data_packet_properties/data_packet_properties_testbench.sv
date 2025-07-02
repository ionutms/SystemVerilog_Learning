// data_packet_properties_testbench.sv
module packet_testbench;
  
  // Create packet instances
  DataPacket data_pkt;
  DataPacket control_pkt;
  DataPacket broadcast_pkt;
  
  initial begin
    // Dump waves for simulation
    $dumpfile("packet_testbench.vcd");
    $dumpvars(0, packet_testbench);
    
    $display();
    
    // Test 1: Create and configure a standard data packet
    $display("--- Test 1: Standard Data Packet ---");
    data_pkt = new();
    data_pkt.make_data_packet();
    data_pkt.display_packet();
    $display();
    
    // Test 2: Create a control packet
    $display("--- Test 2: Control Packet ---");
    control_pkt = new();
    control_pkt.make_control_packet();
    control_pkt.display_packet();
    $display();
    
    // Test 3: Create a broadcast packet
    $display("--- Test 3: High Priority Broadcast Packet ---");
    broadcast_pkt = new();
    broadcast_pkt.make_broadcast_packet();
    broadcast_pkt.display_packet();
    $display();
    
    // Test 4: Demonstrate array property manipulation
    $display("--- Test 4: Array Property Manipulation ---");
    data_pkt.packet_type = "MODIFIED";
    
    // Manually modify some array elements
    data_pkt.header_fields[0] = 32'hCAFEBABE;
    data_pkt.header_fields[1] = 32'h12345678;
    
    // Modify payload with custom pattern
    data_pkt.set_payload_size(16);
    for (int i = 0; i < data_pkt.payload_data.size(); i++) begin
      data_pkt.payload_data[i] = 8'(8'hF0 + i);
    end
    data_pkt.packet_length = 16'd36; // 16 + 20 header
    
    data_pkt.display_packet();
    $display();
    
    // Test 5: Create multiple different packet types
    $display("--- Test 5: Multiple Packet Variations ---");
    for (int test_num = 1; test_num <= 3; test_num++) begin
      $display("Creating packet variation #%0d:", test_num);
      data_pkt.make_data_packet();
      $display(
        "  ID: 0x%02h, Length: %0d, Priority: %0d, Dest: 0x%02h",
        data_pkt.packet_id, data_pkt.packet_length, 
        data_pkt.priority_level, data_pkt.destination_addr);
    end
    $display();
    
    // Test 6: Demonstrate different packet sizes
    $display("--- Test 6: Different Packet Sizes ---");
    
    // Small packet
    data_pkt.packet_type = "SMALL";
    data_pkt.packet_length = 16'd64;
    data_pkt.set_payload_size(44);
    $display(
        "Small packet - Length: %0d, Payload: %0d bytes", 
        data_pkt.packet_length, data_pkt.payload_data.size());
    
    // Large packet
    data_pkt.packet_type = "LARGE";
    data_pkt.packet_length = 16'd1518;
    data_pkt.set_payload_size(1498);
    $display(
        "Large packet - Length: %0d, Payload: %0d bytes", 
        data_pkt.packet_length, data_pkt.payload_data.size());
    $display();
    
    $display("========================================");
    $display("Simulation completed successfully!");
    $display("All packet properties demonstrated:");
    $display("- Basic types (ID, length, type)");
    $display("- Arrays (fixed header, dynamic payload)");
    $display("- Property manipulation methods");
    $display("- Different packet configurations");
    $display("========================================");
    
    #10;  // Wait before finishing
    $finish;
  end
  
endmodule