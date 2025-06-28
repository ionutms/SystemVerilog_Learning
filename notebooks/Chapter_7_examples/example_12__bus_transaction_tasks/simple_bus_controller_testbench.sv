// simple_bus_controller_testbench.sv
module bus_transaction_testbench;

  // Clock and reset signals
  logic        system_clock;
  logic        system_reset_n;
  
  // Bus interface signals
  logic        bus_enable;
  logic        write_enable;
  logic [7:0]  address_bus;
  logic [31:0] write_data_bus;
  logic [31:0] read_data_bus;
  logic        bus_ready;
  
  // Test variables
  logic [31:0] read_result;

  // Instantiate design under test
  simple_bus_controller BUS_CONTROLLER_INSTANCE (
    .clock(system_clock),
    .reset_n(system_reset_n),
    .bus_enable(bus_enable),
    .write_enable(write_enable),
    .address_bus(address_bus),
    .write_data_bus(write_data_bus),
    .read_data_bus(read_data_bus),
    .bus_ready(bus_ready)
  );

  // Clock generation
  initial begin
    system_clock = 0;
    forever #5 system_clock = ~system_clock;
  end

  // Bus Write Transaction Task
  task automatic perform_bus_write_transaction(
    input logic [7:0]  write_address,
    input logic [31:0] write_data
  );
    begin
      $display("\n=== Starting Bus Write Transaction ===");
      $display("Target Address: 0x%02h, Write Data: 0x%08h", 
               write_address, write_data);
      
      // Wait for bus ready
      wait(bus_ready == 1'b1);
      
      // Setup write transaction
      @(posedge system_clock);
      address_bus     = write_address;
      write_data_bus  = write_data;
      write_enable    = 1'b1;
      bus_enable      = 1'b1;
      
      // Wait for operation to complete
      @(posedge system_clock);
      bus_enable      = 1'b0;
      write_enable    = 1'b0;
      
      wait(bus_ready == 1'b1);
      $display("=== Bus Write Transaction Complete ===\n");
    end
  endtask

  // Bus Read Transaction Task
  task automatic perform_bus_read_transaction(
    input  logic [7:0]  read_address,
    output logic [31:0] read_data
  );
    begin
      $display("\n=== Starting Bus Read Transaction ===");
      $display("Target Address: 0x%02h", read_address);
      
      // Wait for bus ready
      wait(bus_ready == 1'b1);
      
      // Setup read transaction
      @(posedge system_clock);
      address_bus     = read_address;
      write_enable    = 1'b0;
      bus_enable      = 1'b1;
      
      // Wait for operation to complete
      @(posedge system_clock);
      bus_enable      = 1'b0;
      
      wait(bus_ready == 1'b1);
      @(posedge system_clock);
      read_data = read_data_bus;
      
      $display("Read Data: 0x%08h", read_data);
      $display("=== Bus Read Transaction Complete ===\n");
    end
  endtask

  // Bus Read-Modify-Write Transaction Task
  task automatic perform_bus_read_modify_write_transaction(
    input logic [7:0]  target_address,
    input logic [31:0] modify_mask,
    input logic [31:0] modify_value
  );
    logic [31:0] current_data;
    logic [31:0] modified_data;
    begin
      $display("\n=== Starting Read-Modify-Write Transaction ===");
      $display("Address: 0x%02h, Mask: 0x%08h, Value: 0x%08h", 
               target_address, modify_mask, modify_value);
      
      // Read current value
      perform_bus_read_transaction(target_address, current_data);
      
      // Modify data
      modified_data = (current_data & ~modify_mask) | 
                      (modify_value & modify_mask);
      $display("Original: 0x%08h -> Modified: 0x%08h", 
               current_data, modified_data);
      
      // Write modified value back
      perform_bus_write_transaction(target_address, modified_data);
      
      $display("=== Read-Modify-Write Transaction Complete ===\n");
    end
  endtask

  // Test stimulus
  initial begin
    // Dump waves for analysis
    $dumpfile("bus_transaction_testbench.vcd");
    $dumpvars(0, bus_transaction_testbench);
    
    // Initialize signals
    system_reset_n  = 0;
    bus_enable      = 0;
    write_enable    = 0;
    address_bus     = 8'h00;
    write_data_bus  = 32'h0000_0000;
    
    $display("\n=== Bus Transaction Tasks Example ===");
    $display("Testing various bus operations using tasks\n");
    
    // Release reset
    #20;
    system_reset_n = 1;
    #10;
    
    // Test 1: Simple write operations
    $display("TEST 1: Simple Write Operations");
    perform_bus_write_transaction(8'h10, 32'hCAFE_BABE);
    perform_bus_write_transaction(8'h20, 32'h1234_5678);
    perform_bus_write_transaction(8'h30, 32'hFEED_FACE);
    
    // Test 2: Read back written data
    $display("TEST 2: Read Back Written Data");
    perform_bus_read_transaction(8'h10, read_result);
    perform_bus_read_transaction(8'h20, read_result);
    perform_bus_read_transaction(8'h30, read_result);
    
    // Test 3: Read-modify-write operations
    $display("TEST 3: Read-Modify-Write Operations");
    perform_bus_read_modify_write_transaction(8'h10, 32'h0000_FFFF, 
                                              32'h0000_DEAD);
    perform_bus_read_modify_write_transaction(8'h20, 32'hFFFF_0000, 
                                              32'hBEEF_0000);
    
    // Test 4: Verify final results
    $display("TEST 4: Final Verification");
    perform_bus_read_transaction(8'h10, read_result);
    perform_bus_read_transaction(8'h20, read_result);
    
    $display("\n=== All Bus Transaction Tests Complete ===");
    #50;
    $finish;
  end

endmodule