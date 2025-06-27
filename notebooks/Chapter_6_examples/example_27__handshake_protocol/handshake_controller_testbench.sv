// handshake_controller_testbench.sv
module handshake_testbench_module;
  
  // Clock and reset generation
  logic system_clock;
  logic system_reset;
  
  // Sender interface signals
  logic [7:0] sender_data_to_send;
  logic       sender_has_valid_data;
  logic       sender_can_send_data;
  
  // Receiver interface signals
  logic [7:0] receiver_data_received;
  logic       receiver_has_valid_data;
  logic       receiver_accepts_data;
  
  // Instantiate the handshake controller
  handshake_data_transfer_controller HANDSHAKE_CONTROLLER_INSTANCE (
    .clock_signal(system_clock),
    .reset_active(system_reset),
    .sender_data_payload(sender_data_to_send),
    .sender_data_valid(sender_has_valid_data),
    .sender_ready_to_receive(sender_can_send_data),
    .receiver_data_payload(receiver_data_received),
    .receiver_data_valid(receiver_has_valid_data),
    .receiver_ready_to_accept(receiver_accepts_data)
  );
  
  // Clock generation
  initial begin
    system_clock = 0;
    forever #5 system_clock = ~system_clock;
  end
  
  // Test stimulus
  initial begin
    // Setup waveform dumping
    $dumpfile("handshake_testbench_module.vcd");
    $dumpvars(0, handshake_testbench_module);
    
    // Initialize all signals
    system_reset = 1;
    sender_data_to_send = 8'h00;
    sender_has_valid_data = 0;
    receiver_accepts_data = 0;
    
    $display("=== Handshake Protocol Controller Test ===");
    $display();
    
    // Release reset
    #15 system_reset = 0;
    $display("System reset released - starting handshake test");
    
    // Test Case 1: Basic handshake with immediate receiver ready
    #10;
    $display("\n--- Test Case 1: Immediate handshake ---");
    sender_data_to_send = 8'hAB;
    sender_has_valid_data = 1;
    receiver_accepts_data = 1;
    
    #10;
    sender_has_valid_data = 0;
    
    // Test Case 2: Sender waits for receiver
    #20;
    $display("\n--- Test Case 2: Sender waits for receiver ---");
    receiver_accepts_data = 0;
    sender_data_to_send = 8'hCD;
    sender_has_valid_data = 1;
    
    #20;
    $display("Receiver becomes ready");
    receiver_accepts_data = 1;
    
    #10;
    sender_has_valid_data = 0;
    
    // Test Case 3: Multiple data transfers
    #20;
    $display("\n--- Test Case 3: Multiple transfers ---");
    sender_data_to_send = 8'h12;
    sender_has_valid_data = 1;
    
    #10;
    sender_data_to_send = 8'h34;
    
    #10;
    sender_data_to_send = 8'h56;
    
    #10;
    sender_has_valid_data = 0;
    receiver_accepts_data = 0;
    
    #30;
    $display();
    $display("=== Handshake Protocol Test Complete ===");
    $finish;
  end
  
  // Monitor handshake signals
  always @(posedge system_clock) begin
    if (!system_reset) begin
      if (sender_has_valid_data && !sender_can_send_data) begin
        $display("Sender waiting: data=0x%02h, waiting for ready signal", sender_data_to_send);
      end
      if (receiver_has_valid_data && !receiver_accepts_data) begin
        $display("Receiver backpressure: data=0x%02h available but not accepted", receiver_data_received);
      end
    end
  end

endmodule