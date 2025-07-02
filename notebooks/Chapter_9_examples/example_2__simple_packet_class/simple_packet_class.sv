// simple_packet_class.sv
class NetworkPacket;
  // Class properties
  rand bit [15:0] header_length;    // Header length in bytes
  rand bit [31:0] packet_id;        // Unique packet identifier
  rand bit [7:0]  packet_type;      // Type of packet (TCP, UDP, etc.)
  rand bit [15:0] payload_size;     // Payload size in bytes
  rand bit [7:0]  payload_data[];   // Dynamic array for payload
  
  // Constructor
  function new(bit [15:0] hdr_len = 20, bit [15:0] payload_sz = 64);
    // Set fixed values first
    this.header_length = hdr_len;
    this.payload_size = payload_sz;
    
    // Create payload array with correct size
    this.payload_data = new[int'(payload_sz)];
    
    // Set random values for ID and type
    this.packet_id = $urandom();
    this.packet_type = 8'($urandom_range(0, 255));
    
    // Fill payload with pattern
    foreach(payload_data[i]) begin
      payload_data[i] = 8'(i % 256);
    end
  endfunction
  
  // Method to display packet information
  function void display_packet_info();
    $display("=== Network Packet Information ===");
    $display("Header Length: %0d bytes", header_length);
    $display("Packet ID:     0x%08h", packet_id);
    $display("Packet Type:   0x%02h", packet_type);
    $display("Payload Size:  %0d bytes", payload_size);
    $display("Total Size:    %0d bytes", header_length + payload_size);
  endfunction
  
  // Method to display first few bytes of payload
  function void display_payload_sample(int num_bytes = 8);
    $display("--- Payload Sample (first %0d bytes) ---", num_bytes);
    $write("Payload: ");
    for(int i = 0; i < num_bytes && i < payload_data.size(); i++) begin
      $write("0x%02h ", payload_data[i]);
    end
    $display();
  endfunction
  
  // Method to calculate total packet size
  function int get_total_size();
    return int'(header_length) + int'(payload_size);
  endfunction
  
  // Method to check if packet is valid
  function bit is_valid_packet();
    return (header_length > 0) && (payload_size > 0) && 
           (int'(payload_data.size()) == int'(payload_size));
  endfunction
  
endclass : NetworkPacket

// Design module that demonstrates packet usage
module packet_processor;
  NetworkPacket pkt;
  
  initial begin
    $display();
    $display("=== Packet Processor Module ===");
    
    // Create a packet instance
    pkt = new(24, 128);  // 24-byte header, 128-byte payload
    
    // Display packet information
    pkt.display_packet_info();
    pkt.display_payload_sample(12);
    
    // Validate packet
    if(pkt.is_valid_packet()) begin
      $display("Packet validation: PASSED");
    end else begin
      $display("Packet validation: FAILED");
    end
    
    $display("Total packet size: %0d bytes", pkt.get_total_size());
    $display();
  end
  
endmodule : packet_processor