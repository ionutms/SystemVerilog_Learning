// configurable_memory.sv - Corrected Version
module configurable_memory #(
    // Integer parameter - memory depth
    parameter int MEMORY_DEPTH = 1024,
    
    // Type parameter - data width
    parameter type DATA_TYPE = bit [7:0],
    
    // String parameter - memory identification
    parameter string MEMORY_NAME = "DEFAULT_MEM",
    
    // Real parameter - access delay in ns
    parameter real ACCESS_DELAY_NS = 2.5
)(
    input  logic clk,
    input  logic reset_n,
    input  logic write_enable,
    input  logic [$clog2(MEMORY_DEPTH)-1:0] address,
    input  DATA_TYPE write_data,
    output DATA_TYPE read_data
);

    // Memory array using parameterized type and depth
    DATA_TYPE memory_array [MEMORY_DEPTH];
    
    initial begin
        $display();
        $display("=== Memory Configuration ===");
        $display("Memory Name: %s", MEMORY_NAME);
        $display("Memory Depth: %0d words", MEMORY_DEPTH);
        $display("Data Width: %0d bits", $bits(DATA_TYPE));
        $display("Access Delay: %0.1f ns", ACCESS_DELAY_NS);
        $display("Address Width: %0d bits", $clog2(MEMORY_DEPTH));
        $display("=============================");
    end
    
    // Memory write operation
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Initialize memory to zero on reset
            for (int i = 0; i < MEMORY_DEPTH; i++) begin
                memory_array[i] <= '0;
            end
        end else if (write_enable) begin
            memory_array[address] <= write_data;
            $display("[%s] Write: Addr=0x%h, Data=0x%h", 
                    MEMORY_NAME, address, write_data);
        end
    end
    
    // Memory read operation - combinational read
    always_comb begin
        read_data = memory_array[address];
    end

endmodule