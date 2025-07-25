// handle_comparison_demo.sv
package handle_comparison_pkg;

  // Simple class to demonstrate handle vs content comparison
  class data_packet_class;
    int packet_id;
    string payload;
    
    function new(int id = 0, string data = "");
      this.packet_id = id;
      this.payload = data;
    endfunction
    
    // Method to compare object content (not handles)
    function bit content_equals(data_packet_class other);
      if (other == null) return 0;
      return (this.packet_id == other.packet_id && 
              this.payload == other.payload);
    endfunction
    
    function void display(string name = "packet");
      $display("  %s: ID=%0d, payload='%s'", name, packet_id, payload);
    endfunction
  endclass

endpackage

module handle_comparison_demo;
  import handle_comparison_pkg::*;
  
  data_packet_class packet1, packet2, packet3, packet4;
  
  initial begin
    $display("=== Handle Comparison Demo ===");
    $display();
    
    // Create first packet
    packet1 = new(100, "Hello");
    $display("Created packet1:");
    packet1.display("packet1");
    $display();
    
    // Create second packet with same content
    packet2 = new(100, "Hello");
    $display("Created packet2 with same content:");
    packet2.display("packet2");
    $display();
    
    // Handle comparison (==) - compares object handles/references
    $display("Handle comparison (packet1 == packet2): %0d", 
             (packet1 == packet2));
    $display("  -> Different objects, so handles are different");
    $display();
    
    // Content comparison using custom method
    $display("Content comparison (packet1.content_equals(packet2)): %0d",
             packet1.content_equals(packet2));
    $display("  -> Same content, so content comparison returns true");
    $display();
    
    // Assign handle - now both variables point to same object
    packet3 = packet1;
    $display("Assigned packet3 = packet1 (same handle):");
    packet3.display("packet3");
    $display();
    
    $display("Handle comparison (packet1 == packet3): %0d",
             (packet1 == packet3));
    $display("  -> Same object handle, so comparison returns true");
    $display();
    
    // Null handle comparison
    packet4 = null;
    $display("Set packet4 = null");
    $display("Handle comparison (packet1 == packet4): %0d",
             (packet1 == packet4));
    $display("Handle comparison (packet4 == null): %0d",
             (packet4 == null));
    $display();
    
    // Modify through one handle affects the other
    $display("Modifying packet1.packet_id to 200...");
    packet1.packet_id = 200;
    $display("packet1 after modification:");
    packet1.display("packet1");
    $display("packet3 after packet1 modification (same handle):");
    packet3.display("packet3");
    $display("  -> Both show ID=200 because they point to same object");
    
  end
  
endmodule