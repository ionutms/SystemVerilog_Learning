// address_latch.sv
module address_latch (
    input  logic        clk,
    input  logic        rst_n,
    
    // Input address from CPU/Controller
    input  logic [15:0] addr_in,           // Input address
    input  logic        addr_valid,        // Address valid signal
    
    // Memory access control
    input  logic        mem_cycle_start,   // Start of memory cycle
    input  logic        mem_cycle_end,     // End of memory cycle
    
    // Latched address output
    output logic [15:0] addr_out,          // Latched address output
    output logic        addr_latched       // Address is currently latched
);

    // Internal latch enable signal
    logic latch_enable;
    logic cycle_active;
    
    // Memory cycle tracking
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cycle_active <= 1'b0;
        end else begin
            if (mem_cycle_start) begin
                cycle_active <= 1'b1;
            end else if (mem_cycle_end) begin
                cycle_active <= 1'b0;
            end
        end
    end
    
    // Latch enable logic: transparent when not in memory cycle and address is valid
    assign latch_enable = !cycle_active && addr_valid;
    
    // Transparent latch behavior
    always_latch begin
        if (latch_enable) begin
            addr_out = addr_in;
        end
    end
    
    // Address latched status
    assign addr_latched = cycle_active;
    
    // Display messages for debugging
    always @(posedge mem_cycle_start) begin
        $display("Time %0t: Address latch - Memory cycle started, address 0x%04h latched", 
                 $time, addr_out);
    end
    
    always @(posedge mem_cycle_end) begin
        $display("Time %0t: Address latch - Memory cycle ended, latch now transparent", 
                 $time);
    end
    
    initial $display("Address Latch initialized - Transparent latch for memory access");

endmodule