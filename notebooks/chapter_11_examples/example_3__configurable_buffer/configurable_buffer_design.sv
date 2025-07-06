// configurable_buffer_design.sv
package buffer_pkg;

  // Generic configurable buffer class
  class configurable_buffer #(
    parameter int BUFFER_SIZE = 8,
    parameter type DATA_TYPE = logic [7:0]
  );
    
    // Buffer storage array
    protected DATA_TYPE buffer_memory[];
    protected int write_pointer;
    protected int read_pointer;
    protected int item_count;
    
    // Constructor
    function new();
      buffer_memory = new[BUFFER_SIZE];
      write_pointer = 0;
      read_pointer = 0;
      item_count = 0;
      $display("Buffer created: size=%0d, data_width=%0d bits", 
               BUFFER_SIZE, $bits(DATA_TYPE));
    endfunction
    
    // Write data to buffer
    function bit write_data(DATA_TYPE data);
      if (is_full()) begin
        $display("ERROR: Buffer full! Cannot write 0x%0h", data);
        return 0;
      end
      
      buffer_memory[write_pointer] = data;
      write_pointer = (write_pointer + 1) % BUFFER_SIZE;
      item_count++;
      $display("Written: 0x%0h at position %0d (count=%0d)", 
               data, write_pointer-1, item_count);
      return 1;
    endfunction
    
    // Read data from buffer
    function bit read_data(ref DATA_TYPE data);
      if (is_empty()) begin
        $display("ERROR: Buffer empty! Cannot read");
        return 0;
      end
      
      data = buffer_memory[read_pointer];
      read_pointer = (read_pointer + 1) % BUFFER_SIZE;
      item_count--;
      $display("Read: 0x%0h from position %0d (count=%0d)", 
               data, read_pointer-1, item_count);
      return 1;
    endfunction
    
    // Check if buffer is full
    function bit is_full();
      return (item_count == BUFFER_SIZE);
    endfunction
    
    // Check if buffer is empty
    function bit is_empty();
      return (item_count == 0);
    endfunction
    
    // Get current item count
    function int get_count();
      return item_count;
    endfunction
    
    // Display buffer status
    function void display_status();
      $display("Buffer Status: %0d/%0d items, WP=%0d, RP=%0d", 
               item_count, BUFFER_SIZE, write_pointer, read_pointer);
    endfunction
    
    // Reset buffer
    function void reset();
      write_pointer = 0;
      read_pointer = 0;
      item_count = 0;
      $display("Buffer reset");
    endfunction
    
  endclass

endpackage

// Top-level design module
module configurable_buffer_design;
  import buffer_pkg::*;
  
  // No actual hardware - just a placeholder for the package
  initial begin
    $display("Configurable Buffer Design Module Loaded");
  end
  
endmodule