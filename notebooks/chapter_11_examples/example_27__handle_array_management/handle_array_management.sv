// handle_array_management.sv
package data_packet_pkg;
  
  class data_packet_class;
    int packet_id;
    string data_payload;
    
    function new(int id = 0, string payload = "empty");
      this.packet_id = id;
      this.data_payload = payload;
    endfunction
    
    function void display_packet_info();
      $display("Packet ID: %0d, Payload: %s", packet_id, data_payload);
    endfunction
    
    function void update_payload(string new_payload);
      data_payload = new_payload;
      $display("Updated packet %0d with new payload: %s", 
               packet_id, data_payload);
    endfunction
    
  endclass
  
endpackage

module design_module_name ();
  import data_packet_pkg::*;
  
  // Array of handles to demonstrate multiple references
  data_packet_class packet_handle_array[4];
  data_packet_class shared_packet_refs[3];
  data_packet_class temp_handle;
  
  initial begin
    $display();
    $display("=== Handle Array Management Demo ===");
    
    // Create packet objects
    packet_handle_array[0] = new(100, "sensor_data");
    packet_handle_array[1] = new(200, "control_cmd");
    packet_handle_array[2] = new(300, "status_msg");
    packet_handle_array[3] = new(400, "error_log");
    
    $display("\n--- Original Packets ---");
    foreach(packet_handle_array[i]) begin
      packet_handle_array[i].display_packet_info();
    end
    
    // Create multiple handles referencing same objects
    shared_packet_refs[0] = packet_handle_array[1]; // Reference to packet 200
    shared_packet_refs[1] = packet_handle_array[1]; // Same reference
    shared_packet_refs[2] = packet_handle_array[3]; // Reference to packet 400
    
    $display("\n--- Shared References Created ---");
    $display("shared_packet_refs[0] and [1] both point to packet 200");
    $display("shared_packet_refs[2] points to packet 400");
    
    // Modify through one handle, see changes in all references
    $display("\n--- Modifying Through First Reference ---");
    shared_packet_refs[0].update_payload("updated_control_cmd");
    
    $display("\n--- Checking All References ---");
    $display("Original array[1]:");
    packet_handle_array[1].display_packet_info();
    $display("shared_packet_refs[0]:");
    shared_packet_refs[0].display_packet_info();
    $display("shared_packet_refs[1]:");
    shared_packet_refs[1].display_packet_info();
    
    // Demonstrate handle assignment vs object copy
    $display("\n--- Handle Assignment Effects ---");
    temp_handle = packet_handle_array[2]; // Handle assignment
    temp_handle.update_payload("modified_status");
    
    $display("After modifying through temp_handle:");
    packet_handle_array[2].display_packet_info();
    
    $display();
  end
  
endmodule