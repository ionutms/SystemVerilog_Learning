// sparse_memory_controller.sv
module sparse_memory_controller ();

  // Sparse memory using associative array - only stores written addresses
  logic [31:0] sparse_memory_data [logic [31:0]];
  
  // Memory interface signals
  logic [31:0] memory_address;
  logic [31:0] write_data;
  logic [31:0] read_data;
  logic        write_enable;
  logic        read_enable;
  logic        data_valid;

  // Keep track of written addresses using a separate array
  logic written_addresses [logic [31:0]];

  // Memory write operation - triggered by write_enable
  always @(posedge write_enable) begin
    if (write_enable) begin
      sparse_memory_data[memory_address] = write_data;
      written_addresses[memory_address] = 1'b1;
      $display("WRITE: Address 0x%08h = 0x%08h", 
               memory_address, write_data);
    end
  end

  // Memory read operation - combinational read
  always_comb begin
    read_data = 32'hzzzz_zzzz;
    data_valid = 1'b0;
    
    if (read_enable) begin
      if (written_addresses[memory_address] == 1'b1) begin
        read_data = sparse_memory_data[memory_address];
        data_valid = 1'b1;
      end else begin
        read_data = 32'h0000_0000;  // Default value for unwritten addresses
        data_valid = 1'b0;
      end
    end
  end

  // Display memory statistics
  task automatic display_memory_statistics();
    int used_addresses;
    
    used_addresses = 0;
    
    // Count used addresses
    foreach (written_addresses[addr]) begin
      if (written_addresses[addr] == 1'b1) begin
        used_addresses++;
      end
    end
    
    $display("Memory Statistics: %0d addresses in use", used_addresses);
    
    // Show all stored addresses
    if (used_addresses > 0) begin
      $display("Stored addresses:");
      foreach (written_addresses[addr]) begin
        if (written_addresses[addr] == 1'b1) begin
          $display("  0x%08h: 0x%08h", addr, sparse_memory_data[addr]);
        end
      end
    end
  endtask

endmodule