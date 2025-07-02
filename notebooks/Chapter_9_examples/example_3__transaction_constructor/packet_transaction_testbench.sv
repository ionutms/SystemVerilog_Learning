// packet_transaction_testbench.sv
module packet_constructor_testbench;
  
  // Transaction handles
  packet_transaction default_packet;
  packet_transaction custom_packet;
  packet_transaction invalid_packet;
  packet_transaction partial_packet;
  
  initial begin
    // Dump waves for visualization
    $dumpfile("packet_constructor_testbench.vcd");
    $dumpvars(0, packet_constructor_testbench);
    
    $display();
    
    // Test 1: Create packet with default constructor parameters
    $display("Test 1: Creating packet with default parameters");
    $display("--------------------------------------------------------");
    default_packet = new();  // Uses all default values
    default_packet.display_transaction();
    
    // Test 2: Create packet with custom parameters
    $display("Test 2: Creating packet with custom parameters");
    $display("--------------------------------------------------------");
    custom_packet = new(8'hA0, 8'hB5, 16'd256, 2'b11);
    custom_packet.display_transaction();
    
    // Test 3: Create invalid packet (same src/dst) to test validation
    $display("Test 3: Creating invalid packet (same source/destination)");
    $display("--------------------------------------------------------");
    invalid_packet = new(8'hCC, 8'hCC, 16'd128, 2'b10);  // Same src/dst
    invalid_packet.display_transaction();
    
    // Test 4: Demonstrate partial parameter usage
    $display("Test 4: Creating packet with partial custom parameters");
    $display("--------------------------------------------------------");
    partial_packet = new(8'h11, 8'hFF, 16'd512, 2'b01);  // Custom src & size
    partial_packet.display_transaction();
    
    $display("=== Constructor Demo Completed ===");
    $display();
    
    #10;  // Small delay before ending
    $finish;
  end
  
endmodule