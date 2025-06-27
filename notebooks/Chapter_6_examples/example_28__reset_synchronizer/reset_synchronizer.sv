// reset_synchronizer.sv
module reset_synchronizer (
    input  logic clock_domain,          // Clock signal for this domain
    input  logic async_reset_in,        // Asynchronous reset input (active low)
    output logic sync_reset_out         // Synchronized reset output (active low)
);

    // Two-stage synchronizer flip-flops
    logic sync_ff1, sync_ff2;
    
    always_ff @(posedge clock_domain or negedge async_reset_in) begin
        if (!async_reset_in) begin
            // Asynchronous reset assertion
            sync_ff1 <= 1'b0;
            sync_ff2 <= 1'b0;
        end else begin
            // Synchronous reset deassertion
            sync_ff1 <= 1'b1;          // First stage
            sync_ff2 <= sync_ff1;      // Second stage
        end
    end
    
    // Output synchronized reset (active low)
    assign sync_reset_out = sync_ff2;
    
    // Display messages for simulation
    initial begin
        $display("Reset Synchronizer initialized");
        $display("- Provides clean reset release synchronized to clock");
    end

endmodule