// simple_bus_transaction.sv
// Simple transaction structure for basic bus operations

// Transaction class containing address, data, and control signals
class simple_bus_transaction;
  rand bit [31:0] address;        // 32-bit address field
  rand bit [31:0] data;           // 32-bit data field  
  rand bit        write_enable;   // Control signal: 1=write, 0=read
  rand bit        valid;          // Transaction valid signal
  
  // Constructor
  function new();
    address = 0;
    data = 0;
    write_enable = 0;
    valid = 0;
  endfunction
  
  // Display transaction contents
  function void display(string prefix = "");
    $display("%s Transaction:", prefix);
    $display("  Address: 0x%08h", address);
    $display("  Data:    0x%08h", data);
    $display("  Write:   %b", write_enable);
    $display("  Valid:   %b", valid);
    $display();
  endfunction
  
  // Copy transaction
  function simple_bus_transaction copy();
    simple_bus_transaction copied_trans = new();
    copied_trans.address = this.address;
    copied_trans.data = this.data;
    copied_trans.write_enable = this.write_enable;
    copied_trans.valid = this.valid;
    return copied_trans;
  endfunction
  
  // Compare two transactions
  function bit compare(simple_bus_transaction other);
    return (this.address == other.address && 
            this.data == other.data &&
            this.write_enable == other.write_enable &&
            this.valid == other.valid);
  endfunction
  
endclass

// Simple bus interface for demonstration
interface simple_bus_interface;
  logic [31:0] address;
  logic [31:0] data;
  logic        write_enable;
  logic        valid;
  logic        ready;
  
  // Modport for master (drives transactions)
  modport master (
    output address, data, write_enable, valid,
    input  ready
  );
  
  // Modport for slave (receives transactions)
  modport slave (
    input  address, data, write_enable, valid,
    output ready
  );
  
endinterface

// Simple bus master module
module simple_bus_master (
  input  logic clk,
  input  logic reset_n,
  simple_bus_interface.master bus_if
);
  
  // Simple state machine for demonstration
  typedef enum logic [1:0] {
    IDLE,
    SEND_TRANS,
    WAIT_READY
  } state_t;
  
  state_t current_state, next_state;
  
  // State register
  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n)
      current_state <= IDLE;
    else
      current_state <= next_state;
  end
  
  // Next state logic (simplified for example)
  always_comb begin
    next_state = current_state;
    case (current_state)
      IDLE: next_state = SEND_TRANS;
      SEND_TRANS: next_state = WAIT_READY;
      WAIT_READY: if (bus_if.ready) next_state = IDLE;
      default: next_state = IDLE;  // Handle unassigned states
    endcase
  end
  
  // Output logic
  always_comb begin
    bus_if.address = 32'h0;
    bus_if.data = 32'h0;
    bus_if.write_enable = 1'b0;
    bus_if.valid = 1'b0;
    
    case (current_state)
      SEND_TRANS, WAIT_READY: begin
        bus_if.address = 32'hDEADBEEF;
        bus_if.data = 32'hCAFEBABE;
        bus_if.write_enable = 1'b1;
        bus_if.valid = 1'b1;
      end
      default: begin
        // Default case: all signals remain at reset values
        bus_if.address = 32'h0;
        bus_if.data = 32'h0;
        bus_if.write_enable = 1'b0;
        bus_if.valid = 1'b0;
      end
    endcase
  end
  
endmodule