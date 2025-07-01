// memory_access_controller.sv
module memory_access_controller #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 16
)(
  input  logic                    clk,
  input  logic                    reset_n,
  input  logic [ADDR_WIDTH-1:0]   address,
  input  logic [DATA_WIDTH-1:0]   write_data,
  input  logic [2:0]              access_type,
  input  logic                    access_enable,
  output logic [DATA_WIDTH-1:0]   read_data,
  output logic                    access_valid,
  output logic                    access_error
);

  // Memory access type constants with specific bit encodings
  localparam logic [2:0] MEM_READ    = 3'b001;  // Read operation    - bit 0 set
  localparam logic [2:0] MEM_WRITE   = 3'b010;  // Write operation   - bit 1 set
  localparam logic [2:0] MEM_EXECUTE = 3'b100;  // Execute operation - bit 2 set

  // Internal memory array for simulation
  logic [DATA_WIDTH-1:0] memory_array [0:2**ADDR_WIDTH-1];
  
  // Access control logic
  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      read_data    <= '0;
      access_valid <= 1'b0;
      access_error <= 1'b0;
    end else begin
      access_valid <= 1'b0;
      access_error <= 1'b0;
      
      if (access_enable) begin
        case (access_type)
          MEM_READ: begin
            read_data    <= memory_array[address];
            access_valid <= 1'b1;
            $display("Time: %0t - READ from addr 0x%04h, data: 0x%08h", 
                     $time, address, memory_array[address]);
          end
          
          MEM_WRITE: begin
            memory_array[address] <= write_data;
            access_valid         <= 1'b1;
            $display("Time: %0t - WRITE to addr 0x%04h, data: 0x%08h", 
                     $time, address, write_data);
          end
          
          MEM_EXECUTE: begin
            read_data    <= memory_array[address];
            access_valid <= 1'b1;
            $display("Time: %0t - EXECUTE from addr 0x%04h, instr: 0x%08h", 
                     $time, address, memory_array[address]);
          end
          
          default: begin
            access_error <= 1'b1;
            $display("Time: %0t - ERROR: Invalid access type: %b", 
                     $time, access_type);
          end
        endcase
      end
    end
  end

  // Initialize memory with some test data
  initial begin
    memory_array[16'h0000] = 32'hDEADBEEF;  // Test data
    memory_array[16'h0001] = 32'hCAFEBABE;  // Test data
    memory_array[16'h0002] = 32'h12345678;  // Test instruction
    memory_array[16'h0003] = 32'h9ABCDEF0;  // Test instruction
  end

endmodule