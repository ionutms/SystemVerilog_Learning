// protocol_packet_parser_testbench.sv
module packet_parser_testbench;

  // Instantiate the design under test
  protocol_packet_parser PARSER_INSTANCE();

  // Import types from the design (Verilator-compatible approach)
  typedef enum logic [1:0] {
    DATA_PACKET  = 2'b00,
    ACK_PACKET   = 2'b01,
    ERROR_PACKET = 2'b10,
    RESET_PACKET = 2'b11
  } packet_type_t;

  typedef struct packed {
    packet_type_t packet_type;
    logic [23:0]  packet_data;
  } protocol_packet_t;

  // Test variables
  protocol_packet_t test_packet;

  initial begin
    // Dump waves
    $dumpfile("packet_parser_testbench.vcd");
    $dumpvars(0, packet_parser_testbench);

    $display("=== Protocol Packet Parser Test ===");
    $display();

    // Test 1: Data packet
    $display("Test 1: Creating and parsing DATA packet");
    test_packet = PARSER_INSTANCE.create_data_packet(8'd42, 16'hABCD);
    PARSER_INSTANCE.parse_packet(test_packet);
    $display("Packet type: %s", 
             PARSER_INSTANCE.get_packet_type_string(test_packet));
    $display("Valid packet: %s", 
             PARSER_INSTANCE.is_valid_packet(test_packet) ? "YES" : "NO");
    $display();

    // Test 2: ACK packet with success status
    $display("Test 2: Creating and parsing ACK packet (SUCCESS)");
    test_packet = PARSER_INSTANCE.create_ack_packet(8'd42, 1'b1);
    PARSER_INSTANCE.parse_packet(test_packet);
    $display("Packet type: %s", 
             PARSER_INSTANCE.get_packet_type_string(test_packet));
    $display("Valid packet: %s", 
             PARSER_INSTANCE.is_valid_packet(test_packet) ? "YES" : "NO");
    $display();

    // Test 3: ACK packet with fail status
    $display("Test 3: Creating and parsing ACK packet (FAIL)");
    test_packet = PARSER_INSTANCE.create_ack_packet(8'd15, 1'b0);
    PARSER_INSTANCE.parse_packet(test_packet);
    $display("Packet type: %s", 
             PARSER_INSTANCE.get_packet_type_string(test_packet));
    $display("Valid packet: %s", 
             PARSER_INSTANCE.is_valid_packet(test_packet) ? "YES" : "NO");
    $display();

    // Test 4: Error packet
    $display("Test 4: Creating and parsing ERROR packet");
    test_packet = PARSER_INSTANCE.create_error_packet(8'd255);
    PARSER_INSTANCE.parse_packet(test_packet);
    $display("Packet type: %s", 
             PARSER_INSTANCE.get_packet_type_string(test_packet));
    $display("Valid packet: %s", 
             PARSER_INSTANCE.is_valid_packet(test_packet) ? "YES" : "NO");
    $display();

    // Test 5: Reset packet
    $display("Test 5: Creating and parsing RESET packet");
    test_packet = PARSER_INSTANCE.create_reset_packet();
    PARSER_INSTANCE.parse_packet(test_packet);
    $display("Packet type: %s", 
             PARSER_INSTANCE.get_packet_type_string(test_packet));
    $display("Valid packet: %s", 
             PARSER_INSTANCE.is_valid_packet(test_packet) ? "YES" : "NO");
    $display();

    // Test 6: Demonstrate packet type checking
    $display("Test 6: Packet type verification");
    test_packet = PARSER_INSTANCE.create_data_packet(8'd10, 16'h1234);
    
    if (test_packet.packet_type == DATA_PACKET)
      $display("Correctly identified as DATA packet");
    else
      $display("Failed to identify DATA packet");

    if (test_packet.packet_type == ACK_PACKET)
      $display("Incorrectly identified as ACK packet");
    else
      $display("Correctly rejected as ACK packet");

    // Test 7: Manual packet creation (testing direct assignment)
    $display();
    $display("Test 7: Testing manual packet creation");
    test_packet.packet_type = RESET_PACKET; // Use enum value
    test_packet.packet_data = 24'hDEADBE;
    $display("Manual packet type: %s", 
             PARSER_INSTANCE.get_packet_type_string(test_packet));
    $display("Valid packet: %s", 
             PARSER_INSTANCE.is_valid_packet(test_packet) ? "YES" : "NO");
    PARSER_INSTANCE.parse_packet(test_packet);

    $display();
    $display("=== All tests completed ===");
    
    #10 $finish;
  end

endmodule