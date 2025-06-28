// packet_parser_module.sv
module packet_parser_module ();
  
  // Packet header structure
  typedef struct packed {
    logic [7:0]  protocol_type;
    logic [15:0] source_port;
    logic [15:0] destination_port;
    logic [15:0] packet_length;
    logic [7:0]  checksum;
  } packet_header_t;
  
  // Function to parse network packet and extract header information
  function packet_header_t parse_network_packet(input [63:0] raw_packet_data);
    packet_header_t parsed_header;
    
    // Extract fields from raw packet data
    parsed_header.protocol_type    = raw_packet_data[63:56];
    parsed_header.source_port      = raw_packet_data[55:40];
    parsed_header.destination_port = raw_packet_data[39:24];
    parsed_header.packet_length    = raw_packet_data[23:8];
    parsed_header.checksum         = raw_packet_data[7:0];
    
    return parsed_header;
  endfunction
  
  initial begin
    logic [63:0] incoming_packet;
    packet_header_t extracted_header;
    
    $display("=== Network Packet Parser Function Demo ===");
    $display();
    
    // Simulate incoming network packet
    incoming_packet = 64'h06_1F90_0050_0400_A5;
    
    // Parse the packet using the function
    extracted_header = parse_network_packet(incoming_packet);
    
    // Display parsed results
    $display("Raw packet data:     0x%016h", incoming_packet);
    $display("Protocol type:       0x%02h", extracted_header.protocol_type);
    $display("Source port:         %0d", extracted_header.source_port);
    $display("Destination port:    %0d", extracted_header.destination_port);
    $display("Packet length:       %0d bytes", extracted_header.packet_length);
    $display("Checksum:            0x%02h", extracted_header.checksum);
    $display();
  end
  
endmodule