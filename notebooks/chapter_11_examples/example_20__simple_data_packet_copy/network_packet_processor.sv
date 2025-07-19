// network_packet_processor.sv
package network_packet_pkg;

  // Simple data packet class with copy constructor
  class DataPacket;
    // Packet header fields
    bit [7:0]  packet_id;
    bit [15:0] source_addr;
    bit [15:0] dest_addr;
    bit [7:0]  packet_length;
    
    // Packet payload
    bit [7:0]  payload[];
    
    // Constructor - creates new packet
    function new(bit [7:0] id = 0, bit [15:0] src = 0, 
                 bit [15:0] dst = 0, bit [7:0] len = 0);
      this.packet_id     = id;
      this.source_addr   = src;
      this.dest_addr     = dst;
      this.packet_length = len;
      
      // Allocate payload based on length
      if (len > 0) begin
        this.payload = new[int'(len)];
        // Initialize with default pattern
        for (int i = 0; i < int'(len); i++) begin
          this.payload[i] = i[7:0];
        end
      end
      
      $display("Created new packet ID=%0d, Src=0x%04x, Dst=0x%04x, Len=%0d", 
               id, src, dst, len);
    endfunction
    
    // Copy constructor - duplicates existing packet
    function DataPacket copy();
      DataPacket copied_packet;
      
      // Create new instance with same header values
      copied_packet = new(this.packet_id, this.source_addr, 
                         this.dest_addr, this.packet_length);
      
      // Deep copy the payload array
      if (this.payload.size() > 0) begin
        copied_packet.payload = new[this.payload.size()];
        for (int i = 0; i < this.payload.size(); i++) begin
          copied_packet.payload[i] = this.payload[i];
        end
      end
      
      $display("Copied packet ID=%0d (payload size: %0d bytes)", 
               copied_packet.packet_id, copied_packet.payload.size());
      
      return copied_packet;
    endfunction
    
    // Method to modify payload data
    function void set_payload_byte(int index, bit [7:0] data);
      if (index >= 0 && index < this.payload.size()) begin
        this.payload[index] = data;
        $display("Set payload[%0d] = 0x%02x in packet ID=%0d", 
                 index, data, this.packet_id);
      end else begin
        $display("ERROR: Invalid payload index %0d for packet ID=%0d", 
                 index, this.packet_id);
      end
    endfunction
    
    // Method to display packet contents
    function void display_packet();
      $display("=== Packet ID=%0d ===", this.packet_id);
      $display("  Source: 0x%04x, Dest: 0x%04x, Length: %0d", 
               this.source_addr, this.dest_addr, this.packet_length);
      $display("  Payload: [%p]", this.payload);
      $display("================");
    endfunction
    
  endclass : DataPacket

endpackage : network_packet_pkg

module network_packet_processor;
  import network_packet_pkg::*;
  
  initial begin
    $display("Network Packet Processor - Simple Data Packet Copy Example");
    $display("=========================================================");
  end
  
endmodule : network_packet_processor