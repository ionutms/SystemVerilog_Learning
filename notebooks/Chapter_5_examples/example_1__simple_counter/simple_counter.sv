// simple_counter.sv
module simple_counter #(
    // Parameters with default values
    parameter int WIDTH = 8,                    // Counter width in bits
    parameter int MAX_COUNT = 255,              // Maximum count value
    parameter bit WRAP_AROUND = 1'b1,           // Enable wrap-around behavior
    parameter int RESET_VALUE = 0               // Reset value for counter
) (
    // ANSI-style port declarations
    input  logic                    clk,        // Clock input
    input  logic                    reset_n,    // Active-low asynchronous reset
    input  logic                    enable,     // Counter enable
    input  logic                    load,       // Load enable
    input  logic [WIDTH-1:0]        load_value, // Value to load
    input  logic                    count_up,   // Count direction (1=up, 0=down)
    output logic [WIDTH-1:0]        count,      // Current counter value
    output logic                    overflow,   // Overflow flag
    output logic                    underflow,  // Underflow flag
    output logic                    max_reached // Maximum count reached flag
);

    // Internal register to hold counter value
    logic [WIDTH-1:0] count_reg;
    
    // Derived parameters using localparam
    localparam logic [WIDTH-1:0] MIN_COUNT = '0;
    localparam logic [WIDTH-1:0] MAX_VAL = MAX_COUNT[WIDTH-1:0];
    localparam logic [WIDTH-1:0] RESET_VAL = RESET_VALUE[WIDTH-1:0];
    
    // Main counter logic
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Asynchronous reset
            count_reg <= RESET_VAL;
            overflow <= 1'b0;
            underflow <= 1'b0;
        end else begin
            // Clear flags by default
            overflow <= 1'b0;
            underflow <= 1'b0;
            
            if (load) begin
                // Load operation has highest priority
                count_reg <= load_value;
            end else if (enable) begin
                if (count_up) begin
                    // Count up logic
                    if (count_reg >= MAX_VAL) begin
                        overflow <= 1'b1;
                        if (WRAP_AROUND) begin
                            count_reg <= MIN_COUNT;
                        end else begin
                            count_reg <= MAX_VAL; // Saturate at maximum
                        end
                    end else begin
                        count_reg <= count_reg + 1'b1;
                    end
                end else begin
                    // Count down logic
                    if (count_reg <= MIN_COUNT) begin
                        underflow <= 1'b1;
                        if (WRAP_AROUND) begin
                            count_reg <= MAX_VAL;
                        end else begin
                            count_reg <= MIN_COUNT; // Saturate at minimum
                        end
                    end else begin
                        count_reg <= count_reg - 1'b1;
                    end
                end
            end
            // If enable is false, counter holds its current value
        end
    end
    
    // Continuous assignments for outputs
    assign count = count_reg;
    assign max_reached = (count_reg == MAX_VAL);
    
    // Assertions for parameter validation (synthesis will ignore these)
    initial begin
        assert (WIDTH > 0) else $error("WIDTH parameter must be greater than 0");
        assert (MAX_COUNT >= 0) else $error("MAX_COUNT parameter must be non-negative");
        assert (MAX_COUNT < (2**WIDTH)) else $error("MAX_COUNT exceeds maximum value for given WIDTH");
        assert (RESET_VALUE >= 0) else $error("RESET_VALUE parameter must be non-negative");
        assert (RESET_VALUE < (2**WIDTH)) else $error("RESET_VALUE exceeds maximum value for given WIDTH");
        
        $display("Simple Counter Module Initialized:");
        $display("  WIDTH = %0d bits", WIDTH);
        $display("  MAX_COUNT = %0d", MAX_COUNT);
        $display("  WRAP_AROUND = %b", WRAP_AROUND);
        $display("  RESET_VALUE = %0d", RESET_VALUE);
        $display("  Counter range: %0d to %0d", MIN_COUNT, MAX_VAL);
    end

endmodule