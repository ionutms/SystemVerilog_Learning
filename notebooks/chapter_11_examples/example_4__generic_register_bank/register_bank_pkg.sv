// register_bank_pkg.sv
package register_bank_pkg;

  // Register bank configuration class
  class register_bank_config;
    int unsigned num_registers;
    int unsigned data_width;
    int unsigned addr_width;
    
    function new(int unsigned num_regs = 16, int unsigned width = 32);
      this.num_registers = num_regs;
      this.data_width = width;
      this.addr_width = $clog2(num_regs);
    endfunction
    
    function void display_config();
      $display("Register Bank Configuration:");
      $display("  Number of registers: %0d", num_registers);
      $display("  Data width: %0d bits", data_width);
      $display("  Address width: %0d bits", addr_width);
    endfunction
  endclass

  // Register bank transaction class
  class register_transaction;
    rand bit write_enable;
    rand bit [15:0] address;    // Maximum 16-bit address
    rand bit [31:0] write_data; // Maximum 32-bit data
    bit [31:0] read_data;
    
    constraint valid_operation {
      address inside {[0:15]};  // Default constraint, override in testbench
    }
    
    function void display_transaction();
      if (write_enable) begin
        $display("WRITE: addr=0x%02X, data=0x%08X", address, write_data);
      end else begin
        $display("READ:  addr=0x%02X, data=0x%08X", address, read_data);
      end
    endfunction
  endclass

endpackage