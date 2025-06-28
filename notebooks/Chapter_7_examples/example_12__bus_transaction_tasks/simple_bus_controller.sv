// simple_bus_controller.sv
module simple_bus_controller (
  input  logic        clock,
  input  logic        reset_n,
  input  logic        bus_enable,
  input  logic        write_enable,
  input  logic [7:0]  address_bus,
  input  logic [31:0] write_data_bus,
  output logic [31:0] read_data_bus,
  output logic        bus_ready
);

  // Simple memory array for demonstration
  logic [31:0] memory_array [0:255];
  logic        operation_active;

  // Bus operation state machine
  always_ff @(posedge clock or negedge reset_n) begin
    if (!reset_n) begin
      read_data_bus    <= 32'h0;
      bus_ready        <= 1'b1;
      operation_active <= 1'b0;
      // Initialize memory with test pattern
      for (int i = 0; i < 256; i++) begin
        memory_array[i] <= 32'hDEAD_0000 + i;
      end
    end else begin
      if (bus_enable && bus_ready) begin
        operation_active <= 1'b1;
        bus_ready        <= 1'b0;
        
        if (write_enable) begin
          // Write operation
          memory_array[address_bus] <= write_data_bus;
          $display("BUS WRITE: addr=0x%02h, data=0x%08h", 
                   address_bus, write_data_bus);
        end else begin
          // Read operation  
          read_data_bus <= memory_array[address_bus];
          $display("BUS READ:  addr=0x%02h, data=0x%08h",
                   address_bus, memory_array[address_bus]);
        end
      end else if (operation_active) begin
        // Complete operation after one cycle
        operation_active <= 1'b0;
        bus_ready        <= 1'b1;
      end
    end
  end

endmodule