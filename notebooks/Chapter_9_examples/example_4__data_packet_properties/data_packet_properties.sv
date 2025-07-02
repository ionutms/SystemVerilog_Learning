// data_packet_properties.sv
class DataPacket;
  // Basic properties
  bit [7:0]   packet_id;               // Packet identifier
  bit [15:0]  packet_length;           // Packet length
  string      packet_type;             // Packet type description
  
  // Array properties
  bit [7:0]   payload_data[];          // Dynamic array for payload
  bit [31:0]  header_fields[4];        // Fixed array for header fields
  
  // Additional properties
  bit [3:0]   priority_level;          // Packet priority (0-15)
  bit [7:0]   destination_addr;        // Destination address
  bit         valid_packet;            // Packet validity flag
  
  // Constructor
  function new();
    packet_type = "DATA";              // Default packet type
    valid_packet = 1'b1;               // Default to valid
    priority_level = 4'd3;             // Default priority
    destination_addr = 8'h42;          // Default destination
    packet_id = 8'h01;                 // Default ID
    packet_length = 16'd128;           // Default length
    
    // Initialize header fields
    foreach(header_fields[i]) begin
      header_fields[i] = 32'hDEADBEEF + i;
    end
    
    // Initialize payload with default size
    set_payload_size(108);             // 128 - 20 byte header
  endfunction
  
  // Method to set payload size and initialize with pattern
  function void set_payload_size(int size);
    payload_data = new[size];
    foreach(payload_data[i]) begin
      payload_data[i] = 8'(8'hA0 + (i % 16));
    end
  endfunction
  
  // Method to create a control packet
  function void make_control_packet();
    packet_type = "CONTROL";
    packet_length = 16'd64;
    priority_level = 4'd6;             // High priority
    packet_id = 8'($urandom() & 8'hFF);
    destination_addr = 8'h10;          // Control address
    set_payload_size(44);              // 64 - 20 byte header
  endfunction
  
  // Method to create a broadcast packet
  function void make_broadcast_packet();
    packet_type = "BROADCAST";
    packet_length = 16'd256;
    priority_level = 4'd7;             // Maximum priority
    packet_id = 8'($urandom() & 8'hFF);
    destination_addr = 8'hFE;          // Near-broadcast address
    set_payload_size(236);             // 256 - 20 byte header
  endfunction
  
  // Method to create a data packet with random properties
  function void make_data_packet();
    packet_type = "DATA";
    packet_length = 16'(64 + ($urandom() % 1455)); // 64-1518 range
    priority_level = 4'(1 + ($urandom() % 7));     // 1-7 range
    packet_id = 8'($urandom() & 8'hFF);
    destination_addr = 8'(1 + ($urandom() % 254)); // 1-254 range
    set_payload_size(int'(packet_length) - 20);
  endfunction
  
  // Method to display packet information
  function void display_packet();
    $display("=== Data Packet Information ===");
    $display("Packet ID: 0x%02h", packet_id);
    $display("Packet Type: %s", packet_type);
    $display("Packet Length: %0d bytes", packet_length);
    $display("Priority Level: %0d", priority_level);
    $display("Destination Address: 0x%02h", destination_addr);
    $display("Valid Packet: %s", valid_packet ? "YES" : "NO");
    $display("Payload Size: %0d bytes", payload_data.size());
    
    // Display header fields
    $display("Header Fields:");
    foreach(header_fields[i]) begin
      $display("  Field[%0d]: 0x%08h", i, header_fields[i]);
    end
    
    // Display first few payload bytes
    if (payload_data.size() > 0) begin
      $display("Payload Preview (first 8 bytes):");
      for (int i = 0; i < 8 && i < payload_data.size(); i++) begin
        $display("  payload_data[%0d]: 0x%02h", i, payload_data[i]);
      end
    end
    $display("===============================");
  endfunction
  
endclass