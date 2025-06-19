// configurable_memory.sv
module configurable_memory #(
    // Type parameters - define custom data types
    parameter type DATA_TYPE = logic [31:0],        // Data bus type
    parameter type ADDR_TYPE = logic [9:0],         // Address bus type
    parameter type CTRL_TYPE = logic [3:0],         // Control signal type
    
    // Value parameters - integer configuration
    parameter int DATA_WIDTH = 32,                  // Data width in bits
    parameter int ADDR_WIDTH = 10,                  // Address width in bits
    parameter int INIT_VALUE = 0,                   // Memory initialization value
    parameter int ACCESS_DELAY = 1,                 // Access delay in clock cycles
    parameter bit ENABLE_ECC = 1'b0,                // Enable error correction
    parameter bit BYTE_ENABLE = 1'b1,               // Enable byte-wise access
    
    // String parameters - configuration modes
    parameter string MEMORY_TYPE = "BLOCK",         // "BLOCK", "DISTRIBUTED", "ULTRA"
    parameter string INIT_FILE = "",                // Initialization file path
    parameter string WRITE_MODE = "READ_FIRST",     // "READ_FIRST", "WRITE_FIRST", "NO_CHANGE"
    
    // Real parameters - timing and performance
    parameter real SETUP_TIME = 2.5,               // Setup time in ns
    parameter real HOLD_TIME = 1.0,                // Hold time in ns
    parameter real ACCESS_TIME = 5.0,              // Access time in ns
    parameter real POWER_FACTOR = 1.0               // Power consumption factor
) (
    // Clock and reset
    input  logic                    clk,
    input  logic                    reset_n,
    
    // Memory interface using parameterized types
    input  logic                    enable,
    input  logic                    write_enable,
    input  ADDR_TYPE                address,
    input  DATA_TYPE                write_data,
    input  CTRL_TYPE                byte_enables,
    output DATA_TYPE                read_data,
    
    // Status outputs
    output logic                    ready,
    output logic                    error,
    output logic [31:0]             access_count
);

    // Localparams derived from parameters
    localparam int DEPTH = 2**ADDR_WIDTH;
    localparam int BYTES_PER_WORD = DATA_WIDTH / 8;
    localparam int DELAY_CYCLES = (ACCESS_DELAY > 0) ? ACCESS_DELAY : 1;
    localparam int DELAY_BITS = (DELAY_CYCLES > 1) ? $clog2(DELAY_CYCLES) : 1;
    localparam real EFFECTIVE_ACCESS_TIME = ACCESS_TIME * POWER_FACTOR;
    
    // Memory array
    DATA_TYPE memory_array [0:DEPTH-1];
    
    // Internal registers
    logic [31:0] access_counter;
    logic [DELAY_BITS-1:0] delay_counter;
    logic access_pending;
    DATA_TYPE read_data_reg;
    logic error_reg;
    
    // String parameter validation and display
    initial begin
        $display("=== Configurable Memory Module Parameters ===");
        $display("Type Parameters:");
        $display("  DATA_TYPE width: %0d bits", $bits(DATA_TYPE));
        $display("  ADDR_TYPE width: %0d bits", $bits(ADDR_TYPE));
        $display("  CTRL_TYPE width: %0d bits", $bits(CTRL_TYPE));
        
        $display("Value Parameters:");
        $display("  DATA_WIDTH = %0d", DATA_WIDTH);
        $display("  ADDR_WIDTH = %0d", ADDR_WIDTH);
        $display("  DEPTH = %0d words", DEPTH);
        $display("  BYTES_PER_WORD = %0d", BYTES_PER_WORD);
        $display("  INIT_VALUE = 0x%h", INIT_VALUE);
        $display("  ACCESS_DELAY = %0d cycles", ACCESS_DELAY);
        $display("  ENABLE_ECC = %b", ENABLE_ECC);
        $display("  BYTE_ENABLE = %b", BYTE_ENABLE);
        
        $display("String Parameters:");
        $display("  MEMORY_TYPE = \"%s\"", MEMORY_TYPE);
        $display("  INIT_FILE = \"%s\"", INIT_FILE);
        $display("  WRITE_MODE = \"%s\"", WRITE_MODE);
        
        $display("Real Parameters:");
        $display("  SETUP_TIME = %0.2f ns", SETUP_TIME);
        $display("  HOLD_TIME = %0.2f ns", HOLD_TIME);
        $display("  ACCESS_TIME = %0.2f ns", ACCESS_TIME);
        $display("  POWER_FACTOR = %0.2f", POWER_FACTOR);
        $display("  EFFECTIVE_ACCESS_TIME = %0.2f ns", EFFECTIVE_ACCESS_TIME);
        $display("===============================================");
        
        // Parameter validation
        assert (DATA_WIDTH > 0) else $error("DATA_WIDTH must be > 0");
        assert (ADDR_WIDTH > 0) else $error("ADDR_WIDTH must be > 0");
        assert ($bits(DATA_TYPE) == DATA_WIDTH) else 
            $warning("DATA_TYPE width (%0d) doesn't match DATA_WIDTH (%0d)", 
                    $bits(DATA_TYPE), DATA_WIDTH);
        assert ($bits(ADDR_TYPE) == ADDR_WIDTH) else 
            $warning("ADDR_TYPE width (%0d) doesn't match ADDR_WIDTH (%0d)", 
                    $bits(ADDR_TYPE), ADDR_WIDTH);
        
        // String parameter validation
        if (MEMORY_TYPE != "BLOCK" && MEMORY_TYPE != "DISTRIBUTED" && MEMORY_TYPE != "ULTRA") begin
            $warning("Unknown MEMORY_TYPE: %s", MEMORY_TYPE);
        end
        
        if (WRITE_MODE != "READ_FIRST" && WRITE_MODE != "WRITE_FIRST" && WRITE_MODE != "NO_CHANGE") begin
            $warning("Unknown WRITE_MODE: %s", WRITE_MODE);
        end
        
        // Real parameter validation
        assert (SETUP_TIME >= 0.0) else $error("SETUP_TIME must be >= 0.0");
        assert (HOLD_TIME >= 0.0) else $error("HOLD_TIME must be >= 0.0");
        assert (ACCESS_TIME > 0.0) else $error("ACCESS_TIME must be > 0.0");
        assert (POWER_FACTOR > 0.0) else $error("POWER_FACTOR must be > 0.0");
    end
    
    // Memory initialization
    initial begin
        if (INIT_FILE != "") begin
            $display("Loading memory from file: %s", INIT_FILE);
            $readmemh(INIT_FILE, memory_array);
        end else begin
            // Initialize with INIT_VALUE
            for (int i = 0; i < DEPTH; i++) begin
                memory_array[i] = DATA_TYPE'(INIT_VALUE);
            end
            $display("Memory initialized with value: 0x%h", INIT_VALUE);
        end
    end
    
    // Main memory logic with access delay
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            access_counter <= 0;
            delay_counter <= 0;
            access_pending <= 1'b0;
            read_data_reg <= DATA_TYPE'(0);
            error_reg <= 1'b0;
        end else begin
            error_reg <= 1'b0;
            
            if (enable) begin
                access_counter <= access_counter + 1;
                
                if (!access_pending) begin
                    // Start new access
                    access_pending <= 1'b1;
                    delay_counter <= DELAY_BITS'(DELAY_CYCLES - 1);
                    
                    // Immediate write operation (configurable based on WRITE_MODE)
                    if (write_enable) begin
                        if (int'(address) < DEPTH) begin
                            if (BYTE_ENABLE && CTRL_TYPE'(byte_enables) != '0) begin
                                // Byte-wise writing (simplified for demonstration)
                                memory_array[address] <= write_data;
                            end else if (!BYTE_ENABLE) begin
                                memory_array[address] <= write_data;
                            end
                        end else begin
                            error_reg <= 1'b1;
                        end
                    end
                    
                    // Handle different write modes for read data
                    if (WRITE_MODE == "READ_FIRST") begin
                        read_data_reg <= (int'(address) < DEPTH) ? memory_array[address] : DATA_TYPE'(0);
                    end else if (WRITE_MODE == "WRITE_FIRST" && write_enable) begin
                        read_data_reg <= write_data;
                    end else if (WRITE_MODE == "NO_CHANGE" && write_enable) begin
                        // Keep previous read data
                    end else begin
                        read_data_reg <= (int'(address) < DEPTH) ? memory_array[address] : DATA_TYPE'(0);
                    end
                    
                end else begin
                    // Handle access delay
                    if (delay_counter > 0) begin
                        delay_counter <= delay_counter - 1;
                    end else begin
                        access_pending <= 1'b0;
                    end
                end
            end
        end
    end
    
    // Internal error signal
    logic internal_error;
    
    // Output assignments
    assign read_data = read_data_reg;
    assign ready = !access_pending;
    assign error = internal_error;
    assign access_count = access_counter;
    
    // ECC logic (placeholder - would be more complex in real implementation)
    generate
        if (ENABLE_ECC) begin : ecc_block
            logic ecc_error;
            
            always_ff @(posedge clk) begin
                if (reset_n && enable && !write_enable) begin
                    // Simple parity check as ECC example
                    ecc_error <= ^read_data_reg; // XOR of all bits
                end else begin
                    ecc_error <= 1'b0;
                end
            end
            
            // Combine errors when ECC is enabled
            assign internal_error = error_reg || ecc_error;
        end else begin : no_ecc_block
            // No ECC - just use basic error
            assign internal_error = error_reg;
        end
    endgenerate

endmodule