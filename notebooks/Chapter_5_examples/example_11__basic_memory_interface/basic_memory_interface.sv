// basic_memory_interface.sv

// Simple memory interface declaration
interface memory_interface;
  logic        clk;         // Clock signal
  logic        reset_n;     // Active low reset
  logic [7:0]  address;     // 8-bit address
  logic [31:0] data_in;     // 32-bit data input
  logic [31:0] data_out;    // 32-bit data output
  logic        write_en;    // Write enable
  logic        read_en;     // Read enable
  logic        ready;       // Memory ready signal
  
  // Modport for memory controller (master)
  modport controller (
    output clk, reset_n, address, data_in, write_en, read_en,
    input  data_out, ready
  );
  
  // Modport for memory module (slave)
  modport memory (
    input  clk, reset_n, address, data_in, write_en, read_en,
    output data_out, ready
  );
  
endinterface

// Memory controller module using the interface
module memory_controller (memory_interface.controller mem_if);
  
  initial begin
    $display("=== Memory Controller Module ===");
    $display("Connected via memory_interface.controller modport");
    $display("Can drive: clk, reset_n, address, data_in, write_en, read_en");
    $display("Can read: data_out, ready");
  end
  
endmodule

// Memory module using the interface
module memory_module (memory_interface.memory mem_if);
  
  initial begin
    $display("=== Memory Module ===");
    $display("Connected via memory_interface.memory modport");
    $display("Can read: clk, reset_n, address, data_in, write_en, read_en");
    $display("Can drive: data_out, ready");
  end
  
endmodule

// Top-level design module
module basic_memory_interface ();
  
  // Instantiate the interface
  memory_interface mem_if();
  
  // Instantiate modules and connect them via interface
  memory_controller CONTROLLER(.mem_if(mem_if.controller));
  memory_module     MEMORY(.mem_if(mem_if.memory));
  
  initial begin
    $display("=== Basic Memory Interface Example ===");
    $display("Demonstrates simple interface declaration and usage");
    $display("Interface connects memory controller and memory module");
  end
  
endmodule