// packet_factory.sv
package packet_types_pkg;
  
  // Enum for packet types
  typedef enum {
    TCP_PACKET,
    UDP_PACKET,
    ICMP_PACKET
  } packet_type_e;
  
  // Base packet class
  virtual class base_packet;
    string packet_name;
    int packet_size;
    
    pure virtual function void display();
    pure virtual function string get_type();
  endclass
  
  // TCP packet class
  class tcp_packet extends base_packet;
    int sequence_number;
    
    function new();
      packet_name = "TCP";
      packet_size = 1500;
      sequence_number = $urandom_range(1000, 9999);
    endfunction
    
    virtual function void display();
      $display("TCP Packet: %s, Size: %0d, Seq: %0d", 
               packet_name, packet_size, sequence_number);
    endfunction
    
    virtual function string get_type();
      return "TCP";
    endfunction
  endclass
  
  // UDP packet class
  class udp_packet extends base_packet;
    int port_number;
    
    function new();
      packet_name = "UDP";
      packet_size = 1024;
      port_number = $urandom_range(1024, 65535);
    endfunction
    
    virtual function void display();
      $display("UDP Packet: %s, Size: %0d, Port: %0d", 
               packet_name, packet_size, port_number);
    endfunction
    
    virtual function string get_type();
      return "UDP";
    endfunction
  endclass
  
  // ICMP packet class
  class icmp_packet extends base_packet;
    int echo_id;
    
    function new();
      packet_name = "ICMP";
      packet_size = 64;
      echo_id = $urandom_range(100, 999);
    endfunction
    
    virtual function void display();
      $display("ICMP Packet: %s, Size: %0d, Echo ID: %0d", 
               packet_name, packet_size, echo_id);
    endfunction
    
    virtual function string get_type();
      return "ICMP";
    endfunction
  endclass
  
  // Factory class
  class packet_factory;
    
    // Create packet by enum type
    static function base_packet create_packet_by_enum(packet_type_e pkt_type);
      tcp_packet tcp_pkt;
      udp_packet udp_pkt;
      icmp_packet icmp_pkt;
      
      case (pkt_type)
        TCP_PACKET: begin
          tcp_pkt = new();
          return tcp_pkt;
        end
        UDP_PACKET: begin
          udp_pkt = new();
          return udp_pkt;
        end
        ICMP_PACKET: begin
          icmp_pkt = new();
          return icmp_pkt;
        end
        default: begin
          $display("ERROR: Unknown packet type enum: %s", pkt_type.name());
          return null;
        end
      endcase
    endfunction
    
    // Create packet by string type
    static function base_packet create_packet_by_string(string pkt_type);
      tcp_packet tcp_pkt;
      udp_packet udp_pkt;
      icmp_packet icmp_pkt;
      
      case (pkt_type.toupper())
        "TCP": begin
          tcp_pkt = new();
          return tcp_pkt;
        end
        "UDP": begin
          udp_pkt = new();
          return udp_pkt;
        end
        "ICMP": begin
          icmp_pkt = new();
          return icmp_pkt;
        end
        default: begin
          $display("ERROR: Unknown packet type string: %s", pkt_type);
          return null;
        end
      endcase
    endfunction
    
  endclass

endpackage

module packet_factory_design;
  import packet_types_pkg::*;
  
  initial begin
    $display("Packet Factory Design Module Loaded");
  end
  
endmodule