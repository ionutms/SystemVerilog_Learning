// clock_divider_circuit.sv
module clock_divider_circuit #(
    parameter DIVIDE_RATIO = 4  // Division ratio (can be even or odd)
)(
    input  logic clk_in,        // Input clock
    input  logic reset_n,       // Active low reset
    output logic clk_out        // Divided output clock
);

    // Counter to track clock cycles
    logic [$clog2(DIVIDE_RATIO)-1:0] counter;
    logic divided_clock;
    
    // For odd division ratios, we need special handling
    logic toggle_early;
    
    // Local parameters to avoid width mismatch warnings
    localparam COUNTER_WIDTH = $clog2(DIVIDE_RATIO);
    localparam [COUNTER_WIDTH-1:0] MAX_COUNT = COUNTER_WIDTH'(DIVIDE_RATIO - 1);
    localparam [COUNTER_WIDTH-1:0] HALF_COUNT = COUNTER_WIDTH'(DIVIDE_RATIO >> 1);
    
    always_ff @(posedge clk_in or negedge reset_n) begin
        if (!reset_n) begin
            counter <= '0;
            divided_clock <= 1'b0;
            toggle_early <= 1'b0;
        end else begin
            if (counter == MAX_COUNT) begin
                counter <= '0;
                divided_clock <= ~divided_clock;
                toggle_early <= 1'b0;
            end else begin
                counter <= counter + 1'b1;
                
                // For odd division ratios, toggle early to maintain 50% duty cycle
                if (DIVIDE_RATIO % 2 == 1 && counter == HALF_COUNT) begin
                    toggle_early <= ~toggle_early;
                end
            end
        end
    end
    
    // Output assignment - handle even and odd division differently
    always_comb begin
        if (DIVIDE_RATIO % 2 == 0) begin
            // Even division: simple toggle at half count
            clk_out = (counter >= HALF_COUNT) ? 1'b1 : 1'b0;
        end else begin
            // Odd division: combine main clock and early toggle for better duty cycle
            clk_out = divided_clock ^ toggle_early;
        end
    end
    
    // Display division information
    initial begin
        $display("Clock Divider Configuration:");
        $display("  Division Ratio: %0d", DIVIDE_RATIO);
        $display("  Division Type: %s", (DIVIDE_RATIO % 2 == 0) ? "Even" : "Odd");
        $display();
    end

endmodule