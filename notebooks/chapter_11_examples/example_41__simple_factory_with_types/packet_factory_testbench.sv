// packet_factory_testbench.sv
module packet_factory_testbench;
  import packet_types_pkg::*;
  
  packet_factory_design DESIGN_INSTANCE();
  
  base_packet pkt;
  base_packet pkt0, pkt1, pkt2;
  string packet_types[] = {"tcp", "UDP", "icmp", "invalid"};
  packet_type_e enum_types[] = {TCP_PACKET, UDP_PACKET, ICMP_PACKET};
  
  initial begin
    
    // Dump waves
    $dumpfile("packet_factory_testbench.vcd");
    $dumpvars(0, packet_factory_testbench);
    
    $display("=== Simple Factory with Types Test ===");
    $display();
    
    // Test factory with string parameters
    $display("--- Testing Factory with String Parameters ---");
    foreach (packet_types[i]) begin
      $display("Creating packet with string: '%s'", packet_types[i]);
      pkt = packet_factory::create_packet_by_string(packet_types[i]);
      if (pkt != null) begin
        pkt.display();
        $display("Packet type returned: %s", pkt.get_type());
      end else begin
        $display("Factory returned null for invalid type");
      end
      $display();
    end
    
    // Test factory with enum parameters
    $display("--- Testing Factory with Enum Parameters ---");
    foreach (enum_types[i]) begin
      $display("Creating packet with enum: %s", enum_types[i].name());
      pkt = packet_factory::create_packet_by_enum(enum_types[i]);
      if (pkt != null) begin
        pkt.display();
        $display("Packet type returned: %s", pkt.get_type());
      end
      $display();
    end
    
    // Demonstrate polymorphism
    $display("--- Demonstrating Polymorphism ---");
    
    pkt0 = packet_factory::create_packet_by_enum(TCP_PACKET);
    pkt1 = packet_factory::create_packet_by_string("UDP");
    pkt2 = packet_factory::create_packet_by_enum(ICMP_PACKET);
    
    $display("Processing packets polymorphically:");
    if (pkt0 != null) begin
      $display("Packet 0:");
      pkt0.display();
    end
    if (pkt1 != null) begin
      $display("Packet 1:");
      pkt1.display();
    end
    if (pkt2 != null) begin
      $display("Packet 2:");
      pkt2.display();
    end
    
    $display();
    $display("=== Factory Test Complete ===");
    
    #1;
    $finish;
  end
  
endmodule