// memory_array_design.sv
module simple_memory_array_module (
  input  logic        clock_signal,
  input  logic        reset_signal,
  input  logic        write_enable_signal,
  input  logic [7:0]  address_bus,
  input  logic [15:0] write_data_bus,
  output logic [15:0] read_data_bus
);

  // Memory array - 256 words of 16 bits each
  logic [15:0] memory_storage_array [0:255];
  
  always_ff @(posedge clock_signal or posedge reset_signal) begin
    if (reset_signal) begin
      read_data_bus <= 16'h0000;
    end else begin
      if (write_enable_signal) begin
        memory_storage_array[address_bus] <= write_data_bus;
        $display("WRITE: Addr[%02h] = %04h", address_bus, write_data_bus);
      end
      read_data_bus <= memory_storage_array[address_bus];
    end
  end

endmodule