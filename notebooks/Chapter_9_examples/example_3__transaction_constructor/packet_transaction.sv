// packet_transaction.sv
class packet_transaction;
  // Transaction properties
  rand bit [7:0]  src_addr;
  rand bit [7:0]  dst_addr; 
  rand bit [15:0] payload_size;
  rand bit [1:0]  pkt_priority;
  bit             valid;
  
  // Constructor with default parameters and validation
  function new(bit [7:0] src = 8'h00, 
               bit [7:0] dst = 8'hFF,
               bit [15:0] size = 16'd64,
               bit [1:0] prio = 2'b01);
    
    $display("Creating new packet transaction...");
    
    // Assign parameters to class properties
    src_addr = src;
    dst_addr = dst;
    payload_size = size;
    pkt_priority = prio;
    
    // Basic validation
    if (validate_transaction()) begin
      valid = 1'b1;
      $display("Transaction validation: PASSED");
    end else begin
      valid = 1'b0;
      $display("Transaction validation: FAILED");
    end
    
    $display("Constructor completed");
    $display();
  endfunction
  
  // Validation function
  function bit validate_transaction();
    bit validation_result = 1'b1;
    
    // Check if source and destination are different
    if (src_addr == dst_addr) begin
      $display("ERROR: Source and destination addresses are the same!");
      validation_result = 1'b0;
    end
    
    // Check payload size limits (minimum 1, maximum 1024)
    if (payload_size == 0 || payload_size > 1024) begin
      $display("ERROR: Invalid payload size: %0d", payload_size);
      validation_result = 1'b0;
    end
    
    return validation_result;
  endfunction
  
  // Display transaction details
  function void display_transaction();
    $display("=== Packet Transaction Details ===");
    $display("Source Address:  0x%02h", src_addr);
    $display("Dest Address:    0x%02h", dst_addr);
    $display("Payload Size:    %0d bytes", payload_size);
    $display("Priority:        %0d", pkt_priority);
    $display("Valid:           %0s", valid ? "YES" : "NO");
    $display("===================================");
    $display();
  endfunction
  
endclass