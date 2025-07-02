// simple_packet_class_testbench.sv
module packet_testbench;
  // Instantiate the packet processor design
  packet_processor PACKET_PROC_INSTANCE();
  
  // Local packet instances for testing
  NetworkPacket test_packet_1;
  NetworkPacket test_packet_2;
  NetworkPacket test_packet_3;
  
  initial begin
    // Setup for waveform dumping
    $dumpfile("packet_testbench.vcd");
    $dumpvars(0, packet_testbench);
    
    $display();
    $display("Testbench starting...");
    $display();
    
    // Wait for design module to complete
    #1;
    
    // Test 1: Create small packet
    $display("=== Test 1: Small Packet ===");
    test_packet_1 = new(16, 32);  // Small packet: 16-byte header, 32-byte payload
    test_packet_1.display_packet_info();
    test_packet_1.display_payload_sample(6);
    $display("Is valid: %s", test_packet_1.is_valid_packet() ? "YES" : "NO");
    $display();
    
    // Test 2: Create large packet
    $display("=== Test 2: Large Packet ===");
    test_packet_2 = new(40, 1024); // Large packet: 40-byte header, 1KB payload
    test_packet_2.display_packet_info();
    test_packet_2.display_payload_sample(10);
    $display("Is valid: %s", test_packet_2.is_valid_packet() ? "YES" : "NO");
    $display();
    
    // Test 3: Create standard packet and randomize
    $display("=== Test 3: Randomized Packet ===");
    test_packet_3 = new();  // Use default constructor
    // Re-randomize only packet_id and packet_type
    test_packet_3.packet_id = $urandom();
    test_packet_3.packet_type = 8'($urandom_range(0, 255));
    test_packet_3.display_packet_info();
    test_packet_3.display_payload_sample(8);
    $display("Is valid: %s", test_packet_3.is_valid_packet() ? "YES" : "NO");
    $display();
    
    // Test 4: Compare packet sizes
    $display("=== Test 4: Packet Size Comparison ===");
    $display("Packet 1 total size: %0d bytes", test_packet_1.get_total_size());
    $display("Packet 2 total size: %0d bytes", test_packet_2.get_total_size());
    $display("Packet 3 total size: %0d bytes", test_packet_3.get_total_size());
    
    if(test_packet_2.get_total_size() > test_packet_1.get_total_size()) begin
      $display("Packet 2 is larger than Packet 1 (as expected)");
    end
    $display();
    
    // Final summary
    $display("=== Testbench Summary ===");
    $display("Created and tested 3 different packet instances");
    $display("Demonstrated class instantiation and method calls");
    $display("Verified packet validation and size calculation");
    $display("Showed dynamic array usage in payload");
    $display();
    
    $display("Hello from packet class testbench!");
    $display();
    
    // Finish simulation
    $finish;
  end
  
endmodule : packet_testbench