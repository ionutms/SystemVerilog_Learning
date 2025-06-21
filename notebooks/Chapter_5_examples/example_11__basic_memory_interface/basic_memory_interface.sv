// basic_memory_interface.sv
// Simple memory interface declaration
interface memory_interface;
  logic [7:0] address;      // 8-bit address
  logic [7:0] write_data;   // 8-bit write data
  logic [7:0] read_data;    // 8-bit read data
  logic       write_enable; // Write enable signal
  logic       read_enable;  // Read enable signal
  logic       clock;        // Clock signal
  
  // Modport for memory controller (master)
  modport controller (
    output address,
    output write_data,
    input  read_data,
    output write_enable,
    output read_enable,
    input  clock
  );
  
  // Modport for memory device (slave)
  modport memory (
    input  address,
    input  write_data,
    output read_data,
    input  write_enable,
    input  read_enable,
    input  clock
  );
  
endinterface

// Simple memory controller module
module memory_controller (memory_interface.controller mem_if);
  
  initial begin
    $display("Memory Controller: Starting operations");
    
    // Initialize signals
    mem_if.address = 8'h00;
    mem_if.write_data = 8'h00;
    mem_if.write_enable = 1'b0;
    mem_if.read_enable = 1'b0;
    
    #10; // Wait
    
    // Write operation
    $display("Memory Controller: Writing data 0xAA to address 0x10");
    mem_if.address = 8'h10;
    mem_if.write_data = 8'hAA;
    mem_if.write_enable = 1'b1;
    mem_if.read_enable = 1'b0;
    
    #10; // Wait
    mem_if.write_enable = 1'b0; // End write
    
    #10; // Wait
    
    // Read operation
    $display("Memory Controller: Reading from address 0x10");
    mem_if.address = 8'h10;
    mem_if.read_enable = 1'b1;
    
    #10; // Wait for read data
    $display("Memory Controller: Read data 0x%02h from address 0x10", mem_if.read_data);
    
    mem_if.read_enable = 1'b0; // End read
    
    #10; // Wait
    
    $display("Memory Controller: Operations complete");
  end
  
endmodule

// Simple memory device module
module memory_device (memory_interface.memory mem_if);
  
  logic [7:0] memory_array [0:255]; // 256 bytes of memory
  
  always @(posedge mem_if.clock) begin
    if (mem_if.write_enable) begin
      memory_array[mem_if.address] <= mem_if.write_data;
      $display("Memory Device: Wrote 0x%02h to address 0x%02h", mem_if.write_data, mem_if.address);
    end
  end
  
  // Combinational read
  always_comb begin
    if (mem_if.read_enable) begin
      mem_if.read_data = memory_array[mem_if.address];
    end else begin
      mem_if.read_data = 8'h00;
    end
  end
  
  // Initialize memory with some test data
  initial begin
    for (int i = 0; i < 256; i++) begin
      memory_array[i] = i[7:0]; // Initialize with address value
    end
    $display("Memory Device: Initialized with test data");
  end
  
endmodule

// Design under test - connects controller and memory via interface
module basic_memory_interface ();
  
  // Clock generation
  logic clock;
  initial begin
    clock = 0;
    forever #5 clock = ~clock; // 10 time unit period
  end
  
  // Interface instance
  memory_interface mem_if();
  
  // Connect clock to interface
  assign mem_if.clock = clock;
  
  // Module instances
  memory_controller controller_inst(mem_if.controller);
  memory_device memory_inst(mem_if.memory);
  
  initial begin
    $display();
    $display("=== Basic Memory Interface Example ===");
    $display("Demonstrating interface declaration and usage");
    $display();
    
    // Let simulation run for a while
    #100;
    
    $display();
    $display("=== Simulation Complete ===");
    $finish;
  end
  
endmodule