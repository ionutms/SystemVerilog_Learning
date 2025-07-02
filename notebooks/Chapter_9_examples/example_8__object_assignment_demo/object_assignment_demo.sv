// object_assignment_demo.sv
class data_packet;
  int packet_id;
  string payload;
  int priority_level;
  
  function new(int id = 0, string data = "default", int prio = 1);
    packet_id = id;
    payload = data;
    priority_level = prio;
  endfunction
  
  // Deep copy method
  function data_packet deep_copy();
    data_packet copied_packet = new();
    copied_packet.packet_id = this.packet_id;
    copied_packet.payload = this.payload;
    copied_packet.priority_level = this.priority_level;
    return copied_packet;
  endfunction
  
  // Display packet contents
  function void display_packet(string prefix = "");
    $display("%sPacket ID: %0d, Payload: %s, Priority: %0d", 
             prefix, packet_id, payload, priority_level);
  endfunction
endclass

module object_assignment_demo();
  initial begin
    $display("=== Object Assignment Demo ===");
    $display();
  end
endmodule