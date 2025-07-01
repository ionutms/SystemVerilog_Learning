// network_message_processor.sv
module network_message_processor;

  // Fixed header structure
  typedef struct {
    bit [7:0]  version;
    bit [7:0]  msg_type;
    bit [15:0] payload_length;
    bit [31:0] sequence_id;
  } message_header_t;

  // Complete message structure with header and payload queue
  typedef struct {
    message_header_t header;
    bit [7:0] payload_queue[$];
  } network_message_t;

  // Message processing queues
  network_message_t incoming_messages[$];
  network_message_t processed_messages[$];

  // Task to create a network message
  task create_message(input bit [7:0]  version,
                     input bit [7:0]  msg_type,
                     input bit [31:0] seq_id,
                     input bit [7:0]  payload_data[]);
    network_message_t new_msg;
    
    // Setup fixed header fields
    new_msg.header.version = version;
    new_msg.header.msg_type = msg_type;
    new_msg.header.sequence_id = seq_id;
    
    // Add variable-length payload to queue
    new_msg.payload_queue = {};
    foreach (payload_data[i]) begin
      new_msg.payload_queue.push_back(payload_data[i]);
    end
    new_msg.header.payload_length = new_msg.payload_queue.size()[15:0];
    
    // Add to incoming message queue
    incoming_messages.push_back(new_msg);
    
    $display("Created message: Type=%0d, Seq=%0d, PayloadLen=%0d",
             new_msg.header.msg_type,
             new_msg.header.sequence_id,
             new_msg.header.payload_length);
  endtask

  // Task to process incoming messages
  task process_messages();
    network_message_t current_msg;
    
    while (incoming_messages.size() > 0) begin
      current_msg = incoming_messages.pop_front();
      
      $display("Processing message:");
      $display("  Header - Ver:%0d Type:%0d Seq:%0d PayloadLen:%0d",
               current_msg.header.version,
               current_msg.header.msg_type,
               current_msg.header.sequence_id,
               current_msg.header.payload_length);
      
      $write("  Payload: ");
      foreach (current_msg.payload_queue[i]) begin
        $write("%02h ", current_msg.payload_queue[i]);
      end
      $display();
      
      // Move to processed queue
      processed_messages.push_back(current_msg);
    end
  endtask

  initial begin
    bit [7:0] test_payload1[] = '{8'hAA, 8'hBB, 8'hCC};
    bit [7:0] test_payload2[] = '{8'h11, 8'h22, 8'h33, 8'h44, 8'h55};
    bit [7:0] test_payload3[] = '{8'hFF};
    
    $display("=== Network Message Processor Demo ===");
    $display();
    
    // Create various messages with different payload lengths
    create_message(8'h01, 8'h10, 32'h1001, test_payload1);
    create_message(8'h01, 8'h20, 32'h1002, test_payload2);
    create_message(8'h01, 8'h30, 32'h1003, test_payload3);
    
    $display();
    $display("Messages in queue: %0d", incoming_messages.size());
    $display();
    
    // Process all messages
    process_messages();
    
    $display();
    $display("Processed messages: %0d", processed_messages.size());
    $display("Remaining incoming: %0d", incoming_messages.size());
  end

endmodule