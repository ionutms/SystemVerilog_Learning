// parameterized_memory_model.sv
// Simple parameterized memory model with configurable width

package memory_model_pkg;

  // Parameterized memory model class
  class ParameterizedMemory #(
    parameter int ADDR_WIDTH = 8,
    parameter int DATA_WIDTH = 32
  );
    
    // Memory array - associative array for sparse memory
    local bit [DATA_WIDTH-1:0] memory_array[bit [ADDR_WIDTH-1:0]];
    
    // Statistics
    local int read_count;
    local int write_count;
    
    // Constructor
    function new();
      read_count = 0;
      write_count = 0;
      $display("Memory model created - ADDR_WIDTH: %0d, DATA_WIDTH: %0d", 
               ADDR_WIDTH, DATA_WIDTH);
    endfunction
    
    // Write operation
    function void write(bit [ADDR_WIDTH-1:0] addr, 
                       bit [DATA_WIDTH-1:0] data);
      memory_array[addr] = data;
      write_count++;
      $display("WRITE: addr=0x%0h, data=0x%0h", addr, data);
    endfunction
    
    // Read operation
    function bit [DATA_WIDTH-1:0] read(bit [ADDR_WIDTH-1:0] addr);
      bit [DATA_WIDTH-1:0] data;
      
      /* verilator lint_off WIDTHTRUNC */
      if (memory_array.exists(addr)) begin
      /* verilator lint_on WIDTHTRUNC */
        data = memory_array[addr];
      end else begin
        data = {DATA_WIDTH{1'bx}};  // Return X for uninitialized
        $display("WARNING: Reading uninitialized address 0x%0h", addr);
      end
      
      read_count++;
      $display("READ:  addr=0x%0h, data=0x%0h", addr, data);
      return data;
    endfunction
    
    // Clear memory
    function void clear();
      memory_array.delete();
      $display("Memory cleared");
    endfunction
    
    // Get statistics
    function void print_stats();
      $display("Memory Statistics:");
      $display("  Read operations:  %0d", read_count);
      $display("  Write operations: %0d", write_count);
      $display("  Memory entries:   %0d", memory_array.size());
    endfunction
    
    // Memory dump (for debugging)
    function void dump_memory();
      bit [ADDR_WIDTH-1:0] addr;
      
      $display("Memory Dump:");
      if (memory_array.size() == 0) begin
        $display("  Memory is empty");
      end else begin
        /* verilator lint_off WIDTHTRUNC */
        if (memory_array.first(addr)) begin
          do begin
            $display("  [0x%0h] = 0x%0h", addr, memory_array[addr]);
          end while (memory_array.next(addr));
        end
        /* verilator lint_on WIDTHTRUNC */
      end
    endfunction
    
  endclass

endpackage

// Simple module wrapper for Verilator compatibility
module parameterized_memory_model;
  import memory_model_pkg::*;
  
  initial begin
    $display("Parameterized Memory Model - Design Module");
    $display("This module contains the memory model package");
  end
  
endmodule