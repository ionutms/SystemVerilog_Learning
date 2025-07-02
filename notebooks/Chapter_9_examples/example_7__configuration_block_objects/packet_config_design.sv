// packet_config_design.sv
class packet_config;
  // Configuration parameters
  int packet_size;
  int num_packets;
  string packet_type;
  bit enable_crc;
  
  // Constructor with default parameters
  function new(int size = 64, 
               int count = 10, 
               string p_type = "DATA", 
               bit crc = 1'b1);
    packet_size = size;
    num_packets = count;
    packet_type = p_type;
    enable_crc = crc;
    $display("Config created: Size=%0d, Count=%0d, Type=%s, CRC=%b",
             packet_size, num_packets, packet_type, enable_crc);
  endfunction
  
  // Display configuration
  function void display_config();
    $display("--- Packet Configuration ---");
    $display("Packet Size: %0d bytes", packet_size);
    $display("Number of Packets: %0d", num_packets);
    $display("Packet Type: %s", packet_type);
    $display("CRC Enabled: %s", enable_crc ? "YES" : "NO");
    $display("---------------------------");
  endfunction
endclass

module packet_config_module;
  packet_config cfg1, cfg2, cfg3, cfg4;
  
  initial begin
    $display("=== Configuration Block Objects Example ===");
    $display();
    
    // Create different configuration objects
    $display("Creating default configuration...");
    cfg1 = new();  // Use all defaults
    cfg1.display_config();
    $display();
    
    $display("Creating small packet configuration...");
    cfg2 = new(.size(32), .count(5));  // Small packets, few count
    cfg2.display_config();
    $display();
    
    $display("Creating control packet configuration...");
    cfg3 = new(.size(16), .count(3), .p_type("CTRL"), .crc(1'b0));
    cfg3.display_config();
    $display();
    
    $display("Creating large data configuration...");
    cfg4 = new(.size(1024), .count(100), .p_type("BULK_DATA"));
    cfg4.display_config();
    $display();
    
    $display("=== All configurations created successfully ===");
  end
endmodule