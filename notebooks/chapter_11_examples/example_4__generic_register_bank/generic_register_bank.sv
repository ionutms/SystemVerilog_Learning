// generic_register_bank.sv
module generic_register_bank #(
  parameter int unsigned NUM_REGISTERS = 16,
  parameter int unsigned DATA_WIDTH = 32,
  parameter int unsigned ADDR_WIDTH = $clog2(NUM_REGISTERS)
) (
  input  logic                    clk,
  input  logic                    rst_n,
  input  logic                    write_enable,
  input  logic [ADDR_WIDTH-1:0]   address,
  input  logic [DATA_WIDTH-1:0]   write_data,
  output logic [DATA_WIDTH-1:0]   read_data,
  output logic                    valid_address
);

  // Register bank storage
  logic [DATA_WIDTH-1:0] registers [NUM_REGISTERS-1:0];
  
  // Address validation - compare with proper width extension
  assign valid_address = ({{32-ADDR_WIDTH{1'b0}}, address} < NUM_REGISTERS);
  
  // Read operation (combinatorial)
  always_comb begin
    if (valid_address) begin
      read_data = registers[address];
    end else begin
      read_data = '0;  // Return zero for invalid addresses
    end
  end
  
  // Write operation (synchronous)
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset all registers to zero
      for (int i = 0; i < NUM_REGISTERS; i++) begin
        registers[i] <= '0;
      end
    end else if (write_enable && valid_address) begin
      registers[address] <= write_data;
    end
  end
  
  // Display register contents (for debugging)
  initial begin
    $display("Generic Register Bank instantiated:");
    $display("  NUM_REGISTERS = %0d", NUM_REGISTERS);
    $display("  DATA_WIDTH = %0d", DATA_WIDTH);
    $display("  ADDR_WIDTH = %0d", ADDR_WIDTH);
  end

endmodule