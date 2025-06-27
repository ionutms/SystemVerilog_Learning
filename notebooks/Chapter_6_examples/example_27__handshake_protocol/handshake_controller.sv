// handshake_controller.sv
module handshake_data_transfer_controller (
  input  logic        clock_signal,
  input  logic        reset_active,
  
  // Sender interface
  input  logic [7:0]  sender_data_payload,
  input  logic        sender_data_valid,
  output logic        sender_ready_to_receive,
  
  // Receiver interface  
  output logic [7:0]  receiver_data_payload,
  output logic        receiver_data_valid,
  input  logic        receiver_ready_to_accept
);

  // Internal handshake control signals
  logic data_transfer_active;
  logic buffered_data_valid;
  logic [7:0] internal_data_buffer;
  
  // Ready/Valid handshake logic
  assign data_transfer_active = sender_data_valid && sender_ready_to_receive;
  assign sender_ready_to_receive = receiver_ready_to_accept || !buffered_data_valid;
  
  // Data buffering and forwarding
  always_ff @(posedge clock_signal or posedge reset_active) begin
    if (reset_active) begin
      internal_data_buffer <= 8'h00;
      buffered_data_valid <= 1'b0;
    end else begin
      if (data_transfer_active) begin
        internal_data_buffer <= sender_data_payload;
        buffered_data_valid <= 1'b1;
      end else if (receiver_ready_to_accept && buffered_data_valid) begin
        buffered_data_valid <= 1'b0;
      end
    end
  end
  
  // Output assignments
  assign receiver_data_payload = internal_data_buffer;
  assign receiver_data_valid = buffered_data_valid;
  
  // Display handshake activity
  always @(posedge clock_signal) begin
    if (data_transfer_active) begin
      $display("Handshake: Data 0x%02h transferred from sender to controller", sender_data_payload);
    end
    if (receiver_ready_to_accept && receiver_data_valid) begin
      $display("Handshake: Data 0x%02h delivered from controller to receiver", receiver_data_payload);
    end
  end

endmodule