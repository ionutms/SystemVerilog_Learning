// array_type_shortcuts_design.sv - Array Type Shortcuts Example
module memory_controller_design ();

  // Define reusable array type shortcuts to avoid repetition
  typedef logic [7:0] byte_data_type;              // 8-bit data type
  typedef byte_data_type memory_word_array_type [0:15]; // 16-byte array
  typedef logic [31:0] address_bus_type [0:7];     // 8-word address array
  typedef struct packed {
    logic valid;
    logic [2:0] priority_level;
    logic [3:0] channel_id;
  } control_packet_type;
  typedef control_packet_type packet_buffer_type [0:3]; // 4-packet buffer

  // Declare variables using the type shortcuts
  memory_word_array_type cache_line_buffer;        // Cache line storage
  memory_word_array_type write_data_buffer;        // Write data buffer
  address_bus_type memory_address_queue;           // Address queue
  address_bus_type pending_address_list;           // Pending addresses
  packet_buffer_type input_packet_fifo;            // Input packet FIFO
  packet_buffer_type output_packet_fifo;           // Output packet FIFO

  initial begin
    $display("Array Type Shortcuts Demonstration");
    $display("=====================================");
    
    // Initialize arrays using the type shortcuts
    for (int i = 0; i < 16; i++) begin
      cache_line_buffer[i] = 8'(i * 16);            // Fill cache buffer
      write_data_buffer[i] = 8'(i + 128);           // Fill write buffer
    end
    
    for (int j = 0; j < 8; j++) begin
      memory_address_queue[j] = 32'h1000 + (j * 4); // Address sequence
      pending_address_list[j] = 32'h2000 + (j * 8); // Pending list
    end
    
    for (int k = 0; k < 4; k++) begin
      input_packet_fifo[k].valid = 1;           // Mark packets valid
      input_packet_fifo[k].priority_level = 3'(k); // Set priority level
      input_packet_fifo[k].channel_id = 4'(k + 1); // Set channel ID
      
      output_packet_fifo[k].valid = 0;          // Mark output empty
      output_packet_fifo[k].priority_level = 3'b0; // Clear priority level
      output_packet_fifo[k].channel_id = 4'b0;     // Clear channel
    end
    
    $display("Cache buffer[0:3]: %h %h %h %h", 
             cache_line_buffer[0], cache_line_buffer[1],
             cache_line_buffer[2], cache_line_buffer[3]);
    $display("Address queue[0:3]: %h %h %h %h",
             memory_address_queue[0], memory_address_queue[1],
             memory_address_queue[2], memory_address_queue[3]);
    $display("Packet FIFO[0] - Valid:%b Priority:%d Channel:%d",
             input_packet_fifo[0].valid, input_packet_fifo[0].priority_level,
             input_packet_fifo[0].channel_id);
  end

endmodule