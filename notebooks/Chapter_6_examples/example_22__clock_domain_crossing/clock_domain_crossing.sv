// clock_domain_crossing.sv
// Demonstrates safe clock domain crossing using synchronizer circuits

module clock_domain_crossing (
  // Clock Domain A (source)
  input  logic clk_a,
  input  logic rst_a_n,
  input  logic data_a,
  
  // Clock Domain B (destination)
  input  logic clk_b,
  input  logic rst_b_n,
  output logic data_b_sync,
  
  // Unsafe direct crossing (for comparison)
  output logic data_b_unsafe
);

  // Unsafe direct crossing - DO NOT USE IN REAL DESIGNS!
  // This creates metastability issues
  assign data_b_unsafe = data_a;

  // Safe 2-FF synchronizer chain for clock domain crossing
  logic sync_ff1, sync_ff2;
  
  always_ff @(posedge clk_b or negedge rst_b_n) begin
    if (!rst_b_n) begin
      sync_ff1 <= 1'b0;
      sync_ff2 <= 1'b0;
    end else begin
      // Two-stage synchronizer to minimize metastability
      sync_ff1 <= data_a;        // First FF may go metastable
      sync_ff2 <= sync_ff1;      // Second FF resolves metastability
    end
  end
  
  assign data_b_sync = sync_ff2;

  // Metastability detection (simplified)
  logic metastable_detected;
  
  always_ff @(posedge clk_b) begin
    // Simple metastability indicator
    // In real hardware, this would be more sophisticated
    if (sync_ff1 !== 1'b0 && sync_ff1 !== 1'b1) begin
      metastable_detected <= 1'b1;
      $display("WARNING: Metastability detected at time %0t", $time);
    end else begin
      metastable_detected <= 1'b0;
    end
  end

endmodule


// Additional module: Enhanced CDC with handshake protocol
module cdc_handshake (
  // Clock Domain A
  input  logic clk_a,
  input  logic rst_a_n,
  input  logic send_req,
  input  logic [7:0] data_in,
  output logic ready,
  
  // Clock Domain B  
  input  logic clk_b,
  input  logic rst_b_n,
  output logic data_valid,
  output logic [7:0] data_out
);

  // Handshake signals
  logic req_sync, ack_sync;
  logic req_toggle, ack_toggle;
  
  // Clock Domain A: Request side
  always_ff @(posedge clk_a or negedge rst_a_n) begin
    if (!rst_a_n) begin
      req_toggle <= 1'b0;
      data_out <= 8'h00;
      ready <= 1'b1;
    end else begin
      if (send_req && ready) begin
        req_toggle <= ~req_toggle;  // Toggle to signal new data
        data_out <= data_in;        // Capture data
        ready <= 1'b0;
      end else if (req_sync == ack_sync) begin
        ready <= 1'b1;  // Acknowledge received
      end
    end
  end
  
  // Synchronize request toggle to clock domain B
  logic req_ff1, req_ff2;
  always_ff @(posedge clk_b or negedge rst_b_n) begin
    if (!rst_b_n) begin
      req_ff1 <= 1'b0;
      req_ff2 <= 1'b0;
    end else begin
      req_ff1 <= req_toggle;
      req_ff2 <= req_ff1;
    end
  end
  assign req_sync = req_ff2;
  
  // Clock Domain B: Detect new data
  logic req_sync_prev;
  always_ff @(posedge clk_b or negedge rst_b_n) begin
    if (!rst_b_n) begin
      req_sync_prev <= 1'b0;
      data_valid <= 1'b0;
      ack_toggle <= 1'b0;
    end else begin
      req_sync_prev <= req_sync;
      data_valid <= (req_sync != req_sync_prev);
      if (req_sync != req_sync_prev) begin
        ack_toggle <= req_sync;  // Echo back the request
      end
    end
  end
  
  // Synchronize acknowledge back to clock domain A
  logic ack_ff1, ack_ff2;
  always_ff @(posedge clk_a or negedge rst_a_n) begin
    if (!rst_a_n) begin
      ack_ff1 <= 1'b0;
      ack_ff2 <= 1'b0;
    end else begin
      ack_ff1 <= ack_toggle;
      ack_ff2 <= ack_ff1;
    end
  end
  assign ack_sync = ack_ff2;

endmodule