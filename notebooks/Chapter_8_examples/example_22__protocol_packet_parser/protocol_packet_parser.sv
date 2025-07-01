// protocol_packet_parser.sv
module protocol_packet_parser;

  // Define packet types using enum
  typedef enum logic [1:0] {
    DATA_PACKET  = 2'b00,
    ACK_PACKET   = 2'b01,
    ERROR_PACKET = 2'b10,
    RESET_PACKET = 2'b11
  } packet_type_t;

  // Define structures for different packet data (all 24 bits)
  typedef struct packed {
    logic [7:0]  sequence_num;
    logic [15:0] data_payload;
  } data_packet_s;

  typedef struct packed {
    logic [7:0]  ack_num;
    logic        status;
    logic [14:0] reserved; // Padding to make 24 bits total
  } ack_packet_s;

  typedef struct packed {
    logic [7:0]  error_code;
    logic [15:0] reserved;   // Padding to make 24 bits total
  } error_packet_s;

  // Main packet structure
  typedef struct packed {
    packet_type_t packet_type;
    logic [23:0]  packet_data; // Union-like data field
  } protocol_packet_t;

  // Function to create a data packet
  function protocol_packet_t create_data_packet(logic [7:0] seq_num, 
                                                logic [15:0] data);
    protocol_packet_t packet;
    data_packet_s data_struct;
    
    data_struct.sequence_num = seq_num;
    data_struct.data_payload = data;
    packet.packet_type = DATA_PACKET;
    packet.packet_data = data_struct;
    return packet;
  endfunction

  // Function to create an ACK packet
  function protocol_packet_t create_ack_packet(logic [7:0] ack_num, 
                                               logic status);
    protocol_packet_t packet;
    ack_packet_s ack_struct;
    
    ack_struct.ack_num = ack_num;
    ack_struct.status = status;
    ack_struct.reserved = 15'b0;
    packet.packet_type = ACK_PACKET;
    packet.packet_data = ack_struct;
    return packet;
  endfunction

  // Function to create an error packet
  function protocol_packet_t create_error_packet(logic [7:0] error_code);
    protocol_packet_t packet;
    error_packet_s error_struct;
    
    error_struct.error_code = error_code;
    error_struct.reserved = 16'b0;
    packet.packet_type = ERROR_PACKET;
    packet.packet_data = error_struct;
    return packet;
  endfunction

  // Function to create a reset packet
  function protocol_packet_t create_reset_packet();
    protocol_packet_t packet;
    packet.packet_type = RESET_PACKET;
    packet.packet_data = 24'b0;
    return packet;
  endfunction

  // Function to parse and display packet information
  function void parse_packet(protocol_packet_t packet);
    case (packet.packet_type)
      DATA_PACKET: begin
        data_packet_s data_info;
        data_info = data_packet_s'(packet.packet_data[23:0]);
        $display("DATA PACKET:");
        $display("  Sequence Number: %0d", data_info.sequence_num);
        $display("  Data Payload: 0x%04h", data_info.data_payload);
      end
      
      ACK_PACKET: begin
        ack_packet_s ack_info;
        ack_info = ack_packet_s'(packet.packet_data[23:0]);
        $display("ACK PACKET:");
        $display("  ACK Number: %0d", ack_info.ack_num);
        $display("  Status: %s", ack_info.status ? "SUCCESS" : "FAIL");
      end
      
      ERROR_PACKET: begin
        logic [7:0] error_code;
        error_code = packet.packet_data[23:16];
        $display("ERROR PACKET:");
        $display("  Error Code: %0d", error_code);
      end
      
      RESET_PACKET: begin
        $display("RESET PACKET: System reset requested");
      end
      
      default: begin
        $display("UNKNOWN PACKET TYPE");
      end
    endcase
    $display("----------------------------------------");
  endfunction

  // Function to get packet type as string
  function string get_packet_type_string(protocol_packet_t packet);
    case (packet.packet_type)
      DATA_PACKET:  return "DATA";
      ACK_PACKET:   return "ACK";
      ERROR_PACKET: return "ERROR";
      RESET_PACKET: return "RESET";
      default:      return "UNKNOWN";
    endcase
  endfunction

  // Function to validate packet integrity
  function bit is_valid_packet(protocol_packet_t packet);
    case (packet.packet_type)
      DATA_PACKET, ACK_PACKET, ERROR_PACKET, RESET_PACKET: return 1'b1;
      default: return 1'b0;
    endcase
  endfunction

endmodule