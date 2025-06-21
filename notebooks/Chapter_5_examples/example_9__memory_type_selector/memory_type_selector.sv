// memory_type_selector.sv
module memory_type_selector #(
  parameter string MEMORY_TYPE = "SRAM",    // "SRAM", "DRAM", or "ROM"
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 4
)(
  input  logic clk,
  input  logic reset,
  input  logic [ADDR_WIDTH-1:0] addr,
  input  logic [DATA_WIDTH-1:0] data_in,
  input  logic write_en,
  output logic [DATA_WIDTH-1:0] data_out
);

  localparam DEPTH = 1 << ADDR_WIDTH;

  // Generate different memory types based on parameter
  generate
    if (MEMORY_TYPE == "SRAM") begin : sram_memory
      // SRAM - Simple synchronous memory
      logic [DATA_WIDTH-1:0] mem [DEPTH-1:0];
      
      always_ff @(posedge clk) begin
        if (write_en)
          mem[addr] <= data_in;
        data_out <= mem[addr];
      end
      
      initial begin
        $display("Generated SRAM memory type");
        $display("  - Synchronous read/write");
        $display("  - %0d x %0d bits", DEPTH, DATA_WIDTH);
      end
      
    end else if (MEMORY_TYPE == "DRAM") begin : dram_memory
      // DRAM - With refresh requirement (simplified simulation)
      logic [DATA_WIDTH-1:0] mem [DEPTH-1:0];
      logic [7:0] refresh_counter;
      
      always_ff @(posedge clk) begin
        if (reset) begin
          refresh_counter <= 0;
          data_out <= '0;
        end else begin
          // Refresh counter
          refresh_counter <= refresh_counter + 1;
          
          // Memory access
          if (write_en)
            mem[addr] <= data_in;
          else
            data_out <= mem[addr];
        end
      end
      
      initial begin
        $display("Generated DRAM memory type");
        $display("  - Requires refresh simulation");
        $display("  - %0d x %0d bits", DEPTH, DATA_WIDTH);
      end
      
    end else if (MEMORY_TYPE == "ROM") begin : rom_memory
      // ROM - Read-only memory with initialization
      logic [DATA_WIDTH-1:0] mem [DEPTH-1:0];
      
      // Initialize ROM with pattern
      initial begin
        for (int i = 0; i < DEPTH; i++) begin
          mem[i] = DATA_WIDTH'(i * 3);  // Properly sized pattern
        end
      end
      
      always_ff @(posedge clk) begin
        data_out <= mem[addr];
        // Ignore write_en for ROM
      end
      
      initial begin
        $display("Generated ROM memory type");
        $display("  - Read-only, pre-initialized");
        $display("  - %0d x %0d bits", DEPTH, DATA_WIDTH);
        $display("  - Pattern: data[i] = i * 3");
      end
      
    end else begin : invalid_memory
      // Default case for invalid memory type
      assign data_out = '0;
      
      initial begin
        $display("ERROR: Invalid memory type '%s'", MEMORY_TYPE);
        $display("Valid types: SRAM, DRAM, ROM");
      end
    end
  endgenerate

  initial begin
    $display();
    $display("=== Memory Type Selector ===");
    $display("Selected memory type: %s", MEMORY_TYPE);
    $display("Address width: %0d bits", ADDR_WIDTH);
    $display("Data width: %0d bits", DATA_WIDTH);
    $display();
  end

endmodule