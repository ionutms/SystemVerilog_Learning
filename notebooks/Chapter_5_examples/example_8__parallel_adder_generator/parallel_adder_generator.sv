// parallel_adder_generator.sv
// Demonstrates generate for loops creating repetitive parallel adder structures
// Fixed version without circular combinational logic

// Basic full adder cell
module full_adder (
    input  logic a, b, cin,
    output logic sum, cout
);
    assign {cout, sum} = a + b + cin;
endmodule

// Ripple carry adder using generate for loop
module ripple_carry_adder #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0] a, b,
    input  logic             cin,
    output logic [WIDTH-1:0] sum,
    output logic             cout
);
    
    // Array of carry signals
    logic [WIDTH:0] carry;
    assign carry[0] = cin;
    assign cout = carry[WIDTH];
    
    // Generate WIDTH full adders
    generate
        for (genvar i = 0; i < WIDTH; i++) begin : gen_adder
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate
    
    // Display generation info
    initial begin
        $display("Ripple Carry Adder Generated:");
        $display("  Width: %0d bits", WIDTH);
        $display("  Full adders instantiated: %0d", WIDTH);
    end

endmodule

// Carry-lookahead adder with hierarchical generate
module carry_lookahead_adder #(
    parameter int WIDTH = 16,
    parameter int BLOCK_SIZE = 4
) (
    input  logic [WIDTH-1:0] a, b,
    input  logic             cin,
    output logic [WIDTH-1:0] sum,
    output logic             cout
);
    
    localparam int NUM_BLOCKS = (WIDTH + BLOCK_SIZE - 1) / BLOCK_SIZE;
    
    // Generate and propagate signals for each bit
    logic [WIDTH-1:0] g, p;  // Generate and propagate
    logic [NUM_BLOCKS:0] block_carry;
    
    assign block_carry[0] = cin;
    assign cout = block_carry[NUM_BLOCKS];
    
    // Generate bit-level G and P signals
    generate
        for (genvar i = 0; i < WIDTH; i++) begin : gen_gp
            assign g[i] = a[i] & b[i];      // Generate
            assign p[i] = a[i] ^ b[i];      // Propagate
        end
    endgenerate
    
    // Generate carry-lookahead blocks
    generate
        for (genvar blk = 0; blk < NUM_BLOCKS; blk++) begin : gen_cla_block
            localparam int START_BIT = blk * BLOCK_SIZE;
            localparam int END_BIT = (START_BIT + BLOCK_SIZE - 1 < WIDTH) ? 
                                   START_BIT + BLOCK_SIZE - 1 : WIDTH - 1;
            localparam int ACTUAL_WIDTH = END_BIT - START_BIT + 1;
            
            // Block-level generate and propagate
            logic [BLOCK_SIZE-1:0] block_g, block_p;
            logic [BLOCK_SIZE:0] local_carry;
            
            // Map signals for this block
            assign local_carry[0] = block_carry[blk];
            assign block_carry[blk+1] = local_carry[ACTUAL_WIDTH];
            
            // Generate local carries and sums for this block
            for (genvar j = 0; j < ACTUAL_WIDTH; j++) begin : gen_bit
                assign block_g[j] = g[START_BIT + j];
                assign block_p[j] = p[START_BIT + j];
                
                // Carry calculation
                assign local_carry[j+1] = block_g[j] | (block_p[j] & local_carry[j]);
                
                // Sum calculation
                assign sum[START_BIT + j] = block_p[j] ^ local_carry[j];
            end
        end
    endgenerate
    
    initial begin
        $display("Carry-Lookahead Adder Generated:");
        $display("  Total width: %0d bits", WIDTH);
        $display("  Block size: %0d bits", BLOCK_SIZE);
        $display("  Number of blocks: %0d", NUM_BLOCKS);
    end

endmodule

// Fixed parallel prefix adder (Kogge-Stone style)
module parallel_prefix_adder #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0] a, b,
    input  logic             cin,
    output logic [WIDTH-1:0] sum,
    output logic             cout
);
    
    localparam int LEVELS = $clog2(WIDTH);
    
    // Separate arrays for each level to avoid circular logic
    logic [WIDTH-1:0] g0, g1, g2, g3, g4, g5, g6, g7;
    logic [WIDTH-1:0] p0, p1, p2, p3, p4, p5, p6, p7;
    
    // Level 0: bit-level G and P
    generate
        for (genvar i = 0; i < WIDTH; i++) begin : gen_level0
            assign g0[i] = a[i] & b[i];
            assign p0[i] = a[i] ^ b[i];
        end
    endgenerate
    
    // Generate prefix network levels using explicit level assignments
    generate
        if (LEVELS >= 1) begin : gen_level1
            for (genvar i = 0; i < WIDTH; i++) begin : gen_bits
                if (i >= 1) begin : gen_compute
                    assign g1[i] = g0[i] | (p0[i] & g0[i-1]);
                    assign p1[i] = p0[i] & p0[i-1];
                end else begin : gen_passthrough
                    assign g1[i] = g0[i];
                    assign p1[i] = p0[i];
                end
            end
        end else begin : no_level1
            assign g1 = g0;
            assign p1 = p0;
        end
        
        if (LEVELS >= 2) begin : gen_level2
            for (genvar i = 0; i < WIDTH; i++) begin : gen_bits
                if (i >= 2) begin : gen_compute
                    assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
                    assign p2[i] = p1[i] & p1[i-2];
                end else begin : gen_passthrough
                    assign g2[i] = g1[i];
                    assign p2[i] = p1[i];
                end
            end
        end else begin : no_level2
            assign g2 = g1;
            assign p2 = p1;
        end
        
        if (LEVELS >= 3) begin : gen_level3
            for (genvar i = 0; i < WIDTH; i++) begin : gen_bits
                if (i >= 4) begin : gen_compute
                    assign g3[i] = g2[i] | (p2[i] & g2[i-4]);
                    assign p3[i] = p2[i] & p2[i-4];
                end else begin : gen_passthrough
                    assign g3[i] = g2[i];
                    assign p3[i] = p2[i];
                end
            end
        end else begin : no_level3
            assign g3 = g2;
            assign p3 = p2;
        end
    endgenerate
    
    // For simplicity, use the appropriate level based on WIDTH
    logic [WIDTH-1:0] final_g;
    
    generate
        if (WIDTH <= 2) begin : use_g1
            assign final_g = g1;
        end else if (WIDTH <= 4) begin : use_g2
            assign final_g = g2;
        end else begin : use_g3
            assign final_g = g3;
        end
    endgenerate
    
    // Generate final sum
    generate
        for (genvar i = 0; i < WIDTH; i++) begin : gen_sum
            if (i == 0) begin : gen_lsb
                assign sum[i] = p0[i] ^ cin;
            end else begin : gen_other
                assign sum[i] = p0[i] ^ final_g[i-1];
            end
        end
    endgenerate
    
    // Final carry out
    assign cout = final_g[WIDTH-1];
    
    initial begin
        $display("Parallel Prefix Adder Generated:");
        $display("  Width: %0d bits", WIDTH);
        $display("  Prefix levels: %0d", LEVELS);
    end

endmodule

// Multi-operand adder tree using generate
module multi_operand_adder #(
    parameter int NUM_OPERANDS = 8,
    parameter int WIDTH = 16
) (
    input  logic [WIDTH-1:0] operands [NUM_OPERANDS-1:0],
    output logic [WIDTH-1:0] sum,
    output logic             overflow
);
    
    localparam int LEVELS = $clog2(NUM_OPERANDS);
    localparam int MAX_NODES = NUM_OPERANDS - 1;
    
    // Extended width for intermediate results
    localparam int EXT_WIDTH = WIDTH + LEVELS;
    
    // Use separate arrays for each level to avoid indexing issues
    logic [EXT_WIDTH-1:0] level0_data [0:NUM_OPERANDS-1];
    logic [EXT_WIDTH-1:0] level1_data [0:NUM_OPERANDS/2-1];
    logic [EXT_WIDTH-1:0] level2_data [0:NUM_OPERANDS/4-1];
    logic [EXT_WIDTH-1:0] level3_data [0:NUM_OPERANDS/8-1];
    
    // Level 0: Input operands
    generate
        for (genvar i = 0; i < NUM_OPERANDS; i++) begin : gen_inputs
            assign level0_data[i] = {{LEVELS{1'b0}}, operands[i]};
        end
    endgenerate
    
    // Level 1: Pair adjacent operands
    generate
        for (genvar i = 0; i < NUM_OPERANDS/2; i++) begin : gen_level1
            assign level1_data[i] = level0_data[2*i] + level0_data[2*i+1];
        end
    endgenerate
    
    // Level 2: Continue pairing
    generate
        if (NUM_OPERANDS >= 4) begin : has_level2
            for (genvar i = 0; i < NUM_OPERANDS/4; i++) begin : gen_level2
                assign level2_data[i] = level1_data[2*i] + level1_data[2*i+1];
            end
        end
    endgenerate
    
    // Level 3: Final level for 8 operands
    generate
        if (NUM_OPERANDS >= 8) begin : has_level3
            for (genvar i = 0; i < NUM_OPERANDS/8; i++) begin : gen_level3
                assign level3_data[i] = level2_data[2*i] + level2_data[2*i+1];
            end
        end
    endgenerate
    
    // Final result assignment based on number of operands
    logic [EXT_WIDTH-1:0] final_result;
    
    generate
        if (NUM_OPERANDS == 2) begin : result_level1
            assign final_result = level1_data[0];
        end else if (NUM_OPERANDS == 4) begin : result_level2
            assign final_result = level2_data[0];
        end else if (NUM_OPERANDS == 8) begin : result_level3
            assign final_result = level3_data[0];
        end else begin : result_default
            // Default case - just sum first two operands
            assign final_result = level0_data[0] + level0_data[1];
        end
    endgenerate
    
    // Extract sum and overflow from final result
    assign sum = final_result[WIDTH-1:0];
    assign overflow = |final_result[EXT_WIDTH-1:WIDTH];
    
    initial begin
        $display("Multi-Operand Adder Tree Generated:");
        $display("  Number of operands: %0d", NUM_OPERANDS);
        $display("  Operand width: %0d bits", WIDTH);
        $display("  Tree levels: %0d", LEVELS);
        $display("  Extended width: %0d bits", EXT_WIDTH);
    end

endmodule

// Configurable parallel adder array
module parallel_adder_array #(
    parameter int NUM_ADDERS = 4,
    parameter int WIDTH = 8,
    parameter string ADDER_TYPE = "RIPPLE" // "RIPPLE", "CLA", "PREFIX"
) (
    input  logic [WIDTH-1:0] a_array [NUM_ADDERS-1:0],
    input  logic [WIDTH-1:0] b_array [NUM_ADDERS-1:0],
    input  logic [NUM_ADDERS-1:0] cin_array,
    output logic [WIDTH-1:0] sum_array [NUM_ADDERS-1:0],
    output logic [NUM_ADDERS-1:0] cout_array
);
    
    // Generate different types of adders based on parameter
    generate
        for (genvar i = 0; i < NUM_ADDERS; i++) begin : gen_adder_array
            
            if (ADDER_TYPE == "RIPPLE") begin : gen_ripple
                ripple_carry_adder #(.WIDTH(WIDTH)) adder (
                    .a(a_array[i]),
                    .b(b_array[i]),
                    .cin(cin_array[i]),
                    .sum(sum_array[i]),
                    .cout(cout_array[i])
                );
                
            end else if (ADDER_TYPE == "CLA") begin : gen_cla
                carry_lookahead_adder #(.WIDTH(WIDTH), .BLOCK_SIZE(4)) adder (
                    .a(a_array[i]),
                    .b(b_array[i]),
                    .cin(cin_array[i]),
                    .sum(sum_array[i]),
                    .cout(cout_array[i])
                );
                
            end else if (ADDER_TYPE == "PREFIX") begin : gen_prefix
                parallel_prefix_adder #(.WIDTH(WIDTH)) adder (
                    .a(a_array[i]),
                    .b(b_array[i]),
                    .cin(cin_array[i]),
                    .sum(sum_array[i]),
                    .cout(cout_array[i])
                );
                
            end else begin : gen_default
                // Default to ripple carry
                ripple_carry_adder #(.WIDTH(WIDTH)) adder (
                    .a(a_array[i]),
                    .b(b_array[i]),
                    .cin(cin_array[i]),
                    .sum(sum_array[i]),
                    .cout(cout_array[i])
                );
            end
        end
    endgenerate
    
    initial begin
        $display("Parallel Adder Array Generated:");
        $display("  Number of adders: %0d", NUM_ADDERS);
        $display("  Adder width: %0d bits", WIDTH);
        $display("  Adder type: %s", ADDER_TYPE);
    end

endmodule