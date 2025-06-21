// interface_with_tasks.sv
// Interface with embedded tasks and functions
interface bus_interface;
  logic [7:0] write_data;
  logic [7:0] read_data;
  logic [3:0] address;
  logic       valid;
  logic       ready;
  logic       write_enable;
  logic       clock;
  
  // Embedded function to check if transaction is complete
  function bit is_transaction_complete();
    return (valid && ready);
  endfunction
  
  // Embedded function to calculate parity
  function bit calculate_parity(logic [7:0] data_in);
    return ^data_in; // XOR reduction for odd parity
  endfunction
  
  // Embedded task to perform a write transaction
  task automatic write_transaction(input [3:0] addr, input [7:0] data_in);
    @(posedge clock);
    address = addr;
    write_data = data_in;
    write_enable = 1'b1;
    valid = 1'b1;
    
    // Wait for ready signal
    while (!ready) @(posedge clock);
    
    $display("Interface Task: Write complete - Addr:0x%01h Data:0x%02h Parity:%b", 
             addr, data_in, calculate_parity(data_in));
    
    @(posedge clock);
    valid = 1'b0;
    write_enable = 1'b0;
  endtask
  
  // Embedded task to perform a read transaction
  task automatic read_transaction(input [3:0] addr, output [7:0] data_out);
    @(posedge clock);
    address = addr;
    write_enable = 1'b0;
    valid = 1'b1;
    
    // Wait for ready signal
    while (!ready) @(posedge clock);
    
    // Wait one more clock for data to be available
    @(posedge clock);
    data_out = read_data;
    $display("Interface Task: Read complete - Addr:0x%01h Data:0x%02h Parity:%b", 
             addr, data_out, calculate_parity(data_out));
    
    @(posedge clock);
    valid = 1'b0;
  endtask
  
  // Modport for master (uses tasks and functions)
  modport master (
    output address, write_data, valid, write_enable,
    input  read_data, ready, clock,
    import write_transaction,
    import read_transaction,
    import is_transaction_complete,
    import calculate_parity
  );
  
  // Modport for slave
  modport slave (
    input  address, write_data, valid, write_enable, clock,
    output read_data, ready,
    import is_transaction_complete,
    import calculate_parity
  );
  
endinterface

// Bus master module using interface tasks
module bus_master (bus_interface.master bus_if);
  
  logic [7:0] read_data;
  
  initial begin
    $display("Bus Master: Starting operations");
    
    // Initialize
    bus_if.address = 4'h0;
    bus_if.write_data = 8'h00;
    bus_if.valid = 1'b0;
    bus_if.write_enable = 1'b0;
    
    #20; // Wait for slave to be ready
    
    // Use interface task for write
    $display("Bus Master: Performing write using interface task");
    bus_if.write_transaction(4'hA, 8'h55);
    
    #10;
    
    // Use interface task for read
    $display("Bus Master: Performing read using interface task");
    bus_if.read_transaction(4'hA, read_data);
    
    #10;
    
    // Use interface function
    if (bus_if.is_transaction_complete()) begin
      $display("Bus Master: Transaction check passed");
    end
    
    #10;
    
    // Test parity function directly
    $display("Bus Master: Parity of 0xFF is %b (should be 0 - even parity)", 
             bus_if.calculate_parity(8'hFF));
    $display("Bus Master: Parity of 0x0F is %b (should be 0 - even parity)", 
             bus_if.calculate_parity(8'h0F));
    $display("Bus Master: Parity of 0x07 is %b (should be 1 - odd parity)", 
             bus_if.calculate_parity(8'h07));
    
    $display("Bus Master: All operations complete");
  end
  
endmodule

// Bus slave module
module bus_slave (bus_interface.slave bus_if);
  
  logic [7:0] memory [0:15]; // 16 locations
  logic ready_internal;
  
  assign bus_if.ready = ready_internal;
  
  always @(posedge bus_if.clock) begin
    if (bus_if.valid && ready_internal) begin
      if (bus_if.write_enable) begin
        // Write operation
        memory[bus_if.address] <= bus_if.write_data;
        $display("Bus Slave: Stored 0x%02h at address 0x%01h", 
                 bus_if.write_data, bus_if.address);
      end else begin
        // Read operation - drive read_data
        bus_if.read_data <= memory[bus_if.address];
        $display("Bus Slave: Retrieved 0x%02h from address 0x%01h", 
                 memory[bus_if.address], bus_if.address);
      end
    end
  end
  
  // Simple ready generation
  always @(posedge bus_if.clock) begin
    if (bus_if.valid) begin
      ready_internal <= 1'b1;
    end else begin
      ready_internal <= 1'b0;
    end
  end
  
  // Initialize memory
  initial begin
    for (int i = 0; i < 16; i++) begin
      memory[i] = i[7:0]; // Use only lower 8 bits of i
    end
    ready_internal = 1'b0;
    $display("Bus Slave: Memory initialized");
  end
  
endmodule

// Design under test
module interface_with_tasks ();
  
  // Clock generation
  logic clock;
  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end
  
  // Interface instance
  bus_interface bus_if();
  assign bus_if.clock = clock;
  
  // Module instances
  bus_master master_inst(bus_if.master);
  bus_slave slave_inst(bus_if.slave);
  
  initial begin
    $display();
    $display("=== Interface with Tasks and Functions Example ===");
    $display("Demonstrating embedded tasks and functions in interfaces");
    $display();
    
    #200; // Let simulation run
    
    $display();
    $display("=== Simulation Complete ===");
    $finish;
  end
  
endmodule