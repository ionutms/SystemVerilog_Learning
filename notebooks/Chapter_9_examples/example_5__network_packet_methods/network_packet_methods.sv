// network_packet_methods.sv
// Chapter 9 Example 5: Network Packet Methods
// Demonstrates constructor, function, task, virtual, and static methods

class network_packet_base;
  // Packet properties
  rand bit [7:0]  packet_id;
  rand bit [15:0] packet_size;
  rand bit [31:0] source_addr;
  rand bit [31:0] dest_addr;
  static int      packet_count = 0;  // Static counter for all packets
  
  // Constructor method
  function new(bit [31:0] src = 32'h0, bit [31:0] dst = 32'hFFFFFFFF);
    source_addr = src;
    dest_addr = dst;
    packet_count++;  // Increment static counter
    $display("Packet created: ID=%0d, Count=%0d", packet_id, packet_count);
  endfunction
  
  // Function method - returns checksum (pure function)
  function bit [15:0] calculate_checksum();
    return {8'h0, packet_id} + {8'h0, packet_size[7:0]} + {8'h0, packet_size[15:8]};
  endfunction
  
  // Task method - displays packet info (can consume time)
  virtual task display_packet_info();
    #1ns;  // Simulate time delay
    $display("=== Packet Info ===");
    $display("ID: 0x%02h, Size: %0d bytes", packet_id, packet_size);
    $display("From: 0x%08h To: 0x%08h", source_addr, dest_addr);
    $display("Checksum: 0x%04h", calculate_checksum());
  endtask
  
  // Virtual function - can be overridden in derived classes
  virtual function string get_packet_type();
    return "BASE";
  endfunction
  
  // Static method - operates on class level, not instance level
  static function int get_total_packet_count();
    return packet_count;
  endfunction
  
endclass

// Derived class demonstrating virtual method override
class tcp_packet extends network_packet_base;
  rand bit [15:0] tcp_port_src;
  rand bit [15:0] tcp_port_dst;
  
  // Constructor calls parent constructor
  function new(bit [31:0] src = 32'h0, bit [31:0] dst = 32'hFFFFFFFF);
    super.new(src, dst);
    tcp_port_src = 80;   // Default HTTP port
    tcp_port_dst = 8080; // Default alt HTTP port
  endfunction
  
  // Override virtual function
  virtual function string get_packet_type();
    return "TCP";
  endfunction
  
  // Override virtual task
  virtual task display_packet_info();
    super.display_packet_info();  // Call parent method
    $display("TCP Ports: %0d -> %0d", tcp_port_src, tcp_port_dst);
  endtask
  
endclass

module network_packet_methods_demo;
  
  initial begin
    network_packet_base base_pkt;
    tcp_packet         tcp_pkt;
    
    $display("=== Network Packet Methods Demo ===\n");
    
    // Create base packet using constructor
    base_pkt = new(32'hC0A80001, 32'hC0A80002);  // 192.168.0.1 -> 192.168.0.2
    base_pkt.randomize();
    
    // Create TCP packet using constructor
    tcp_pkt = new(32'h08080808, 32'h08080404);   // 8.8.8.8 -> 8.8.4.4
    tcp_pkt.randomize();
    
    $display("\n--- Function Method Demo ---");
    $display("Base packet checksum: 0x%04h", base_pkt.calculate_checksum());
    $display("TCP packet checksum:  0x%04h", tcp_pkt.calculate_checksum());
    
    $display("\n--- Virtual Function Demo ---");
    $display("Base packet type: %s", base_pkt.get_packet_type());
    $display("TCP packet type:  %s", tcp_pkt.get_packet_type());
    
    $display("\n--- Static Method Demo ---");
    $display("Total packets created: %0d", 
             network_packet_base::get_total_packet_count());
    
    $display("\n--- Task Method Demo ---");
    base_pkt.display_packet_info();
    $display("");
    tcp_pkt.display_packet_info();
    
    $display("\n=== Demo Complete ===");
  end
  
endmodule