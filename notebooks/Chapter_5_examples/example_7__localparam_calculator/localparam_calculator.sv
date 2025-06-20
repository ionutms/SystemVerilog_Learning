// localparam_calculator.sv
// Simple example demonstrating localparam usage for derived values

// Fixed-point multiplier with derived timing parameters
module fixed_point_mult #(
    parameter int DATA_WIDTH = 16,
    parameter int FRAC_BITS = 8,
    parameter real CLK_FREQ_MHZ = 100.0
) (
    input  logic                     clk,
    input  logic                     reset_n,
    input  logic [DATA_WIDTH-1:0]    a,
    input  logic [DATA_WIDTH-1:0]    b,
    input  logic                     start,
    output logic [DATA_WIDTH-1:0]    result,
    output logic                     valid
);

    // Derived parameters using localparam
    localparam int PRODUCT_WIDTH = DATA_WIDTH * 2;
    localparam int INT_BITS = DATA_WIDTH - FRAC_BITS;
    localparam logic [DATA_WIDTH-1:0] MAX_VALUE = (1 << (DATA_WIDTH-1)) - 1;
    localparam logic [DATA_WIDTH-1:0] MIN_VALUE = -(1 << (DATA_WIDTH-1));
    
    // Timing-related derived parameters
    localparam real CLK_PERIOD_NS = 1000.0 / CLK_FREQ_MHZ;
    localparam int PIPELINE_STAGES = (CLK_FREQ_MHZ > 200.0) ? 3 : 
                                    (CLK_FREQ_MHZ > 100.0) ? 2 : 1;
    localparam int TIMEOUT_CYCLES = int'(CLK_FREQ_MHZ * 10); // 10µs timeout
    
    // Display derived parameters
    initial begin
        $display("Fixed-Point Multiplier Parameters:");
        $display("  Input: DATA_WIDTH=%0d, FRAC_BITS=%0d, CLK_FREQ_MHZ=%.1f", 
                DATA_WIDTH, FRAC_BITS, CLK_FREQ_MHZ);
        $display("  Derived: INT_BITS=%0d, PRODUCT_WIDTH=%0d", 
                INT_BITS, PRODUCT_WIDTH);
        $display("  Range: [%0d.%0d to %0d.%0d]", 
                MIN_VALUE >>> FRAC_BITS, MIN_VALUE & ((1<<FRAC_BITS)-1),
                MAX_VALUE >>> FRAC_BITS, MAX_VALUE & ((1<<FRAC_BITS)-1));
        $display("  Timing: CLK_PERIOD=%.2fns, PIPELINE_STAGES=%0d, TIMEOUT=%0d cycles", 
                CLK_PERIOD_NS, PIPELINE_STAGES, TIMEOUT_CYCLES);
    end
    
    // Pipeline registers for different timing requirements
    logic [DATA_WIDTH-1:0] mult_result;
    logic mult_valid;
    
    generate
        if (PIPELINE_STAGES == 1) begin : single_stage
            // Single cycle multiplication
            logic [PRODUCT_WIDTH-1:0] product;
            
            always_ff @(posedge clk or negedge reset_n) begin
                if (!reset_n) begin
                    mult_result <= '0;
                    mult_valid <= 1'b0;
                end else begin
                    product = a * b;
                    // Scale back by removing FRAC_BITS
                    mult_result <= product[FRAC_BITS+DATA_WIDTH-1:FRAC_BITS];
                    mult_valid <= start;
                end
            end
            
        end else if (PIPELINE_STAGES == 2) begin : two_stage
            // Two stage pipeline
            logic [DATA_WIDTH-1:0] a_reg, b_reg;
            logic [PRODUCT_WIDTH-1:0] product_reg;
            logic start_reg;
            
            always_ff @(posedge clk or negedge reset_n) begin
                if (!reset_n) begin
                    a_reg <= '0;
                    b_reg <= '0;
                    start_reg <= 1'b0;
                    product_reg <= '0;
                    mult_result <= '0;
                    mult_valid <= 1'b0;
                end else begin
                    // Stage 1: Register inputs and multiply
                    a_reg <= a;
                    b_reg <= b;
                    start_reg <= start;
                    product_reg <= a_reg * b_reg;
                    
                    // Stage 2: Scale and output
                    mult_result <= product_reg[FRAC_BITS+DATA_WIDTH-1:FRAC_BITS];
                    mult_valid <= start_reg;
                end
            end
            
        end else begin : three_stage
            // Three stage pipeline
            logic [DATA_WIDTH-1:0] a_reg1, b_reg1, a_reg2, b_reg2;
            logic [PRODUCT_WIDTH-1:0] product_reg;
            logic start_reg1, start_reg2;
            
            always_ff @(posedge clk or negedge reset_n) begin
                if (!reset_n) begin
                    a_reg1 <= '0; b_reg1 <= '0;
                    a_reg2 <= '0; b_reg2 <= '0;
                    start_reg1 <= 1'b0; start_reg2 <= 1'b0;
                    product_reg <= '0;
                    mult_result <= '0;
                    mult_valid <= 1'b0;
                end else begin
                    // Stage 1: Register inputs
                    a_reg1 <= a;
                    b_reg1 <= b;
                    start_reg1 <= start;
                    
                    // Stage 2: Register again and multiply
                    a_reg2 <= a_reg1;
                    b_reg2 <= b_reg1;
                    start_reg2 <= start_reg1;
                    product_reg <= a_reg2 * b_reg2;
                    
                    // Stage 3: Scale and output
                    mult_result <= product_reg[FRAC_BITS+DATA_WIDTH-1:FRAC_BITS];
                    mult_valid <= start_reg2;
                end
            end
        end
    endgenerate
    
    assign result = mult_result;
    assign valid = mult_valid;

endmodule

// Simple FIFO with derived sizing parameters
module param_fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int MIN_DEPTH = 16
) (
    input  logic                    clk,
    input  logic                    reset_n,
    input  logic                    push,
    input  logic                    pop,
    input  logic [DATA_WIDTH-1:0]   data_in,
    output logic [DATA_WIDTH-1:0]   data_out,
    output logic                    full,
    output logic                    empty,
    output logic                    almost_full,
    output logic                    almost_empty
);

    // Derive actual depth as next power of 2
    localparam int ADDR_WIDTH = $clog2(MIN_DEPTH);
    localparam int ACTUAL_DEPTH = 1 << ADDR_WIDTH;
    localparam int ALMOST_FULL_THRESH = ACTUAL_DEPTH - 4;
    localparam int ALMOST_EMPTY_THRESH = 4;
    localparam logic [ADDR_WIDTH:0] FULL_COUNT = ACTUAL_DEPTH[ADDR_WIDTH:0];
    
    initial begin
        $display("FIFO Parameters:");
        $display("  Requested MIN_DEPTH=%0d, Actual DEPTH=%0d", 
                MIN_DEPTH, ACTUAL_DEPTH);
        $display("  ADDR_WIDTH=%0d, DATA_WIDTH=%0d", 
                ADDR_WIDTH, DATA_WIDTH);
        $display("  Thresholds: ALMOST_FULL=%0d, ALMOST_EMPTY=%0d", 
                ALMOST_FULL_THRESH, ALMOST_EMPTY_THRESH);
    end
    
    // FIFO storage and pointers
    logic [DATA_WIDTH-1:0] memory [0:ACTUAL_DEPTH-1];
    logic [ADDR_WIDTH-1:0] write_ptr, read_ptr;
    logic [ADDR_WIDTH:0] count;
    
    // FIFO control logic
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            write_ptr <= '0;
            read_ptr <= '0;
            count <= '0;
        end else begin
            case ({push & ~full, pop & ~empty})
                2'b01: begin // Pop only
                    read_ptr <= read_ptr + 1;
                    count <= count - 1;
                end
                2'b10: begin // Push only
                    memory[write_ptr] <= data_in;
                    write_ptr <= write_ptr + 1;
                    count <= count + 1;
                end
                2'b11: begin // Push and pop
                    memory[write_ptr] <= data_in;
                    write_ptr <= write_ptr + 1;
                    read_ptr <= read_ptr + 1;
                    // count stays same
                end
                default: begin // No operation
                    // All signals maintain their values
                end
            endcase
        end
    end
    
    // Output assignments using derived parameters
    assign data_out = memory[read_ptr];
    assign full = (count == FULL_COUNT);
    assign empty = (count == '0);
    assign almost_full = (count >= ALMOST_FULL_THRESH[ADDR_WIDTH:0]);
    assign almost_empty = (count <= ALMOST_EMPTY_THRESH[ADDR_WIDTH:0]);

endmodule