// multi_stage_pipeline.sv
// Demonstrates correct vs incorrect assignment usage in multi-stage pipelines
// This example shows a 4-stage arithmetic pipeline: INPUT -> ADD -> MULTIPLY -> OUTPUT

module multi_stage_pipeline (
    input  logic        clk,
    input  logic        reset_n,
    input  logic        enable,
    input  logic [7:0]  data_in_a,
    input  logic [7:0]  data_in_b,
    input  logic [7:0]  data_in_c,
    output logic [15:0] result_correct,
    output logic [15:0] result_incorrect,
    output logic        valid_out
);

    // ========================================
    // CORRECT PIPELINE IMPLEMENTATION
    // Using non-blocking assignments (<=)
    // ========================================
    
    // Stage 1: Input registers
    logic [7:0] stage1_a, stage1_b, stage1_c;
    logic       stage1_valid;
    
    // Stage 2: Addition stage
    logic [8:0] stage2_sum;        // a + b (9 bits to handle overflow)
    logic [7:0] stage2_c;
    logic       stage2_valid;
    
    // Stage 3: Multiplication stage  
    logic [15:0] stage3_product;   // sum * c
    logic        stage3_valid;
    
    // CORRECT: Non-blocking assignments for sequential logic
    always_ff @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            // Reset all pipeline stages
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
            stage1_c <= 8'b0;
            stage1_valid <= 1'b0;
            
            stage2_sum <= 9'b0;
            stage2_c <= 8'b0;
            stage2_valid <= 1'b0;
            
            stage3_product <= 16'b0;
            stage3_valid <= 1'b0;
            
            result_correct <= 16'b0;
            valid_out <= 1'b0;
        end else if (enable) begin
            // Stage 1: Input capture
            stage1_a <= data_in_a;
            stage1_b <= data_in_b;
            stage1_c <= data_in_c;
            stage1_valid <= 1'b1;
            
            // Stage 2: Addition (a + b)
            stage2_sum <= stage1_a + stage1_b;
            stage2_c <= stage1_c;
            stage2_valid <= stage1_valid;
            
            // Stage 3: Multiplication (sum * c)
            stage3_product <= stage2_sum * stage2_c;
            stage3_valid <= stage2_valid;
            
            // Stage 4: Output
            result_correct <= stage3_product;
            valid_out <= stage3_valid;
        end
    end

    // ========================================
    // INCORRECT PIPELINE IMPLEMENTATION
    // Using blocking assignments (=) - DEMONSTRATES PROBLEMS
    // ========================================
    
    // Incorrect pipeline registers
    logic [7:0] bad_stage1_a, bad_stage1_b, bad_stage1_c;
    logic [8:0] bad_stage2_sum;
    logic [7:0] bad_stage2_c;
    logic [15:0] bad_stage3_product;
    
    // INCORRECT: Blocking assignments cause race conditions and incorrect behavior
    always_ff @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            bad_stage1_a = 8'b0;
            bad_stage1_b = 8'b0;
            bad_stage1_c = 8'b0;
            bad_stage2_sum = 9'b0;
            bad_stage2_c = 8'b0;
            bad_stage3_product = 16'b0;
            result_incorrect = 16'b0;
        end else if (enable) begin
            // PROBLEM: All assignments execute immediately in order
            // This creates a combinational path through all stages!
            bad_stage1_a = data_in_a;           // Executes first
            bad_stage1_b = data_in_b;           // Executes second  
            bad_stage1_c = data_in_c;           // Executes third
            
            bad_stage2_sum = bad_stage1_a + bad_stage1_b;  // Uses NEW values immediately!
            bad_stage2_c = bad_stage1_c;                   // Uses NEW value immediately!
            
            bad_stage3_product = bad_stage2_sum * bad_stage2_c;  // Uses NEW values immediately!
            
            result_incorrect = bad_stage3_product;         // Final result in same clock!
        end
    end
    
    // Display warnings about the incorrect implementation
    initial begin
        $display("=== PIPELINE ASSIGNMENT USAGE DEMO ===");
        $display("CORRECT:   Uses non-blocking assignments (<=) for proper pipeline behavior");
        $display("INCORRECT: Uses blocking assignments (=) causing combinational behavior");
        $display("=> Compare result_correct vs result_incorrect in simulation");
        $display("=> Incorrect version computes result in single clock cycle!");
        $display("=> Correct version takes 4 clock cycles for first result");
        $display("=======================================");
    end

endmodule