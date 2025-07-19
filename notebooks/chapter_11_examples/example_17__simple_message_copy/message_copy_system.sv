// message_copy_system.sv
// Simple message class demonstrating copy constructor for duplicating
// messages with timestamps and content

package message_copy_pkg;

  // Simple message class with copy constructor
  class simple_message_class;
    // Properties
    local string message_content;
    local longint message_timestamp;  // Use longint for $time compatibility
    local int     message_id;
    
    static int next_id = 1;

    // Constructor
    function new(string content = "Default message");
      this.message_content = content;
      this.message_timestamp = $time;
      this.message_id = next_id++;
      $display("[TIME:%0d] Created message ID:%0d - Content: '%s'", 
               this.message_timestamp, this.message_id, this.message_content);
    endfunction

    // Copy constructor
    function simple_message_class copy();
      simple_message_class copied_message;
      copied_message = new(this.message_content);
      copied_message.message_timestamp = this.message_timestamp;
      $display("[TIME:%0d] Copied message ID:%0d from original ID:%0d", 
               $time, copied_message.message_id, this.message_id);
      return copied_message;
    endfunction

    // Deep copy constructor (creates new timestamp)
    function simple_message_class deep_copy();
      simple_message_class deep_copied_message;
      string deep_copy_content;
      
      /* verilator lint_off WIDTHTRUNC */
      deep_copy_content = {this.message_content, " (deep copy)"};
      /* verilator lint_on WIDTHTRUNC */
      
      deep_copied_message = new(deep_copy_content);
      $display("[TIME:%0d] Deep copied message ID:%0d from original ID:%0d", 
               $time, deep_copied_message.message_id, this.message_id);
      return deep_copied_message;
    endfunction

    // Display message information
    function void display_message();
      $display("  Message ID: %0d", this.message_id);
      $display("  Timestamp:  %0d", this.message_timestamp);
      $display("  Content:    '%s'", this.message_content);
      $display("");
    endfunction

    // Get message content
    function string get_content();
      return this.message_content;
    endfunction

    // Update message content
    function void update_content(string new_content);
      this.message_content = new_content;
      $display("[TIME:%0d] Updated message ID:%0d content to: '%s'", 
               $time, this.message_id, this.message_content);
    endfunction

    // Get message ID
    function int get_id();
      return this.message_id;
    endfunction

    // Get timestamp
    function longint get_timestamp();
      return this.message_timestamp;
    endfunction

  endclass

endpackage

// Top-level module for the message copy system
module message_copy_system;
  import message_copy_pkg::*;

  simple_message_class original_msg;
  simple_message_class copied_msg;
  simple_message_class deep_copied_msg;

  initial begin
    $display("\n=== Simple Message Copy System Demo ===\n");
    
    // Create original message
    $display("1. Creating original message:");
    original_msg = new("Hello SystemVerilog World!");
    original_msg.display_message();

    #10; // Wait some time

    // Create shallow copy
    $display("2. Creating shallow copy:");
    copied_msg = original_msg.copy();
    copied_msg.display_message();

    #5; // Wait some time

    // Create deep copy
    $display("3. Creating deep copy:");
    deep_copied_msg = original_msg.deep_copy();
    deep_copied_msg.display_message();

    // Modify original message
    $display("4. Modifying original message:");
    original_msg.update_content("Modified original message");
    
    $display("5. Displaying all messages after modification:");
    $display("Original message:");
    original_msg.display_message();
    
    $display("Copied message (shallow copy):");
    copied_msg.display_message();
    
    $display("Deep copied message:");
    deep_copied_msg.display_message();

    $display("=== Message Copy Demo Complete ===\n");
  end

endmodule