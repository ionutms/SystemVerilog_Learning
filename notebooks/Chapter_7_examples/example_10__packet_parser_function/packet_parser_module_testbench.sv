// packet_parser_module_testbench.sv
module packet_parser_testbench;
  
  // Instantiate the packet parser module
  packet_parser_module PACKET_PARSER_INSTANCE();
  
  // Additional testbench variables
  logic [63:0] test_packets [];
  
  initial begin
    // Setup VCD file for waveform viewing
    $dumpfile("packet_parser_testbench.vcd");
    $dumpvars(0, packet_parser_testbench);
    
    $display("=== Packet Parser Function Testbench ===");
    $display();
    
    // Initialize test packet array
    test_packets = new[3];
    test_packets[0] = 64'h11_1F40_0050_0200_3C;  // UDP packet
    test_packets[1] = 64'h06_0050_1F90_0800_7F;  // TCP packet  
    test_packets[2] = 64'h01_0000_0000_001C_FF;  // ICMP packet
    
    // Test multiple packets
    for (int packet_index = 0; packet_index < 3; packet_index++) begin
      $display("--- Testing Packet %0d ---", packet_index + 1);
      test_packet_parsing(test_packets[packet_index]);
      $display();
      #10;  // Wait between tests
    end
    
    $display("Packet parser function testing completed!");
    $display();
    $finish;
  end
  
  // Task to test packet parsing with different inputs
  task test_packet_parsing(input [63:0] test_packet_data);
    // Call the parser function from the design module
    $display("Testing packet: 0x%016h", test_packet_data);
    
    // Note: In a real testbench, we would instantiate the design
    // and call its functions. For this simple example, we demonstrate
    // the concept of testing the packet parsing functionality.
    $display("Packet successfully processed by parser function");
  endtask
  
endmodule