// metastability_synchronizer.sv
module metastability_synchronizer #(
    parameter SYNC_STAGES = 2,      // Number of synchronizer stages (typically 2 or 3)
    parameter RESET_VALUE = 1'b0    // Reset value for synchronizer chain
)(
    input  logic clk,               // Destination clock domain
    input  logic reset_n,           // Active low reset
    input  logic async_in,          // Asynchronous input signal
    output logic sync_out           // Synchronized output signal
);

    // Synchronizer flip-flop chain
    // These should be placed close together and have no logic between them
    (* ASYNC_REG = "TRUE" *) logic [SYNC_STAGES-1:0] sync_ff;
    
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            sync_ff <= {SYNC_STAGES{RESET_VALUE}};
        end else begin
            // Shift register implementation
            sync_ff <= {sync_ff[SYNC_STAGES-2:0], async_in};
        end
    end
    
    // Output is the last stage of the synchronizer
    assign sync_out = sync_ff[SYNC_STAGES-1];
    
    // Information display
    initial begin
        $display("Metastability Synchronizer Configuration:");
        $display("  Synchronizer Stages: %0d", SYNC_STAGES);
        $display("  Reset Value: %b", RESET_VALUE);
        $display("  MTBF Improvement: ~%0d orders of magnitude", SYNC_STAGES * 10);
        $display();
    end

endmodule

// Alternative single-bit synchronizer with explicit FF naming
module simple_two_ff_synchronizer (
    input  logic clk,               // Destination clock domain
    input  logic reset_n,           // Active low reset  
    input  logic async_in,          // Asynchronous input signal
    output logic sync_out           // Synchronized output signal
);

    // Explicit two flip-flop synchronizer
    (* ASYNC_REG = "TRUE" *) logic sync_ff1;  // First synchronizer flip-flop
    (* ASYNC_REG = "TRUE" *) logic sync_ff2;  // Second synchronizer flip-flop
    
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            sync_ff1 <= 1'b0;
            sync_ff2 <= 1'b0;
        end else begin
            sync_ff1 <= async_in;    // First stage captures async signal
            sync_ff2 <= sync_ff1;    // Second stage synchronizes to clock
        end
    end
    
    assign sync_out = sync_ff2;
    
    initial begin
        $display("Simple Two-FF Synchronizer: 2-stage synchronizer for metastability protection");
        $display();
    end

endmodule