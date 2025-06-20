// memory_type_selector.sv
module memory_type_selector ();
  
  // Parameter to select memory type
  parameter [39:0] MEMORY_TYPE = "SRAM"; // Options: "SRAM", "DRAM", "FLASH"
  
  // Local parameters for comparison (5 characters * 8 bits = 40 bits)
  localparam [39:0] SRAM_TYPE  = "SRAM";
  localparam [39:0] DRAM_TYPE  = "DRAM";
  localparam [39:0] FLASH_TYPE = "FLASH";
  
  // Generate different memory implementations based on parameter
  generate
    if (MEMORY_TYPE == SRAM_TYPE) begin : sram_memory
      initial begin
        $display("SRAM Memory Selected");
        $display("- Fast access time");
        $display("- Low power consumption");
        $display("- Volatile storage");
      end
    end
    else if (MEMORY_TYPE == DRAM_TYPE) begin : dram_memory
      initial begin
        $display("DRAM Memory Selected");
        $display("- High density");
        $display("- Requires refresh");
        $display("- Moderate access time");
      end
    end
    else if (MEMORY_TYPE == FLASH_TYPE) begin : flash_memory
      initial begin
        $display("FLASH Memory Selected");
        $display("- Non-volatile storage");
        $display("- Slower write/erase");
        $display("- High density");
      end
    end
    else begin : unknown_memory
      initial begin
        $display("ERROR: Unknown memory type '%s'", MEMORY_TYPE);
        $display("Valid options: SRAM, DRAM, FLASH");
      end
    end
  endgenerate
  
  initial $display("=== Memory Type Selector Example ===");
  
endmodule