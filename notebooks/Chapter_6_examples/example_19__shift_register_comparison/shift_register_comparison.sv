// shift_register_comparison.sv
// Demonstrates critical differences between blocking and non-blocking assignments
// in shift register implementations - side-by-side comparison

module shift_register_comparison (
    input  logic       clk,
    input  logic       reset_n,
    input  logic       shift_enable,
    input  logic       serial_in,
    output logic [7:0] parallel_out_correct,
    output logic [7:0] parallel_out_incorrect,
    output logic       serial_out_correct,
    output logic       serial_out_incorrect
);

    // ========================================
    // CORRECT SHIFT REGISTER IMPLEMENTATION
    // Using non-blocking assignments (<=)
    // ========================================
    
    logic [7:0] shift_reg_correct;
    
    // CORRECT: Non-blocking assignments create proper shift register
    always_ff @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            shift_reg_correct <= 8'b0;
        end else if (shift_enable) begin
            // All assignments happen simultaneously at clock edge
            shift_reg_correct[7] <= serial_in;           // New bit in
            shift_reg_correct[6] <= shift_reg_correct[7]; // Bit 7 -> 6
            shift_reg_correct[5] <= shift_reg_correct[6]; // Bit 6 -> 5
            shift_reg_correct[4] <= shift_reg_correct[5]; // Bit 5 -> 4
            shift_reg_correct[3] <= shift_reg_correct[4]; // Bit 4 -> 3
            shift_reg_correct[2] <= shift_reg_correct[3]; // Bit 3 -> 2
            shift_reg_correct[1] <= shift_reg_correct[2]; // Bit 2 -> 1
            shift_reg_correct[0] <= shift_reg_correct[1]; // Bit 1 -> 0
        end
    end
    
    // Outputs for correct implementation
    assign parallel_out_correct = shift_reg_correct;
    assign serial_out_correct = shift_reg_correct[0];

    // ========================================
    // INCORRECT SHIFT REGISTER IMPLEMENTATION  
    // Using blocking assignments (=)
    // ========================================
    
    logic [7:0] shift_reg_incorrect;
    
    // INCORRECT: Blocking assignments create wrong behavior
    always_ff @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            shift_reg_incorrect = 8'b0;
        end else if (shift_enable) begin
            // PROBLEM: Assignments execute sequentially!
            // This creates a "shift-through" effect in one clock cycle
            shift_reg_incorrect[7] = serial_in;              // Executes first
            shift_reg_incorrect[6] = shift_reg_incorrect[7]; // Uses NEW value of [7]!
            shift_reg_incorrect[5] = shift_reg_incorrect[6]; // Uses NEW value of [6]!
            shift_reg_incorrect[4] = shift_reg_incorrect[5]; // Uses NEW value of [5]!
            shift_reg_incorrect[3] = shift_reg_incorrect[4]; // Uses NEW value of [4]!
            shift_reg_incorrect[2] = shift_reg_incorrect[3]; // Uses NEW value of [3]!
            shift_reg_incorrect[1] = shift_reg_incorrect[2]; // Uses NEW value of [2]!
            shift_reg_incorrect[0] = shift_reg_incorrect[1]; // Uses NEW value of [1]!
            // Result: serial_in propagates through ALL bits in ONE clock cycle!
        end
    end
    
    // Outputs for incorrect implementation
    assign parallel_out_incorrect = shift_reg_incorrect;
    assign serial_out_incorrect = shift_reg_incorrect[0];
    
    // Alternative correct implementation using concatenation (for reference)
    logic [7:0] shift_reg_concat;
    always_ff @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            shift_reg_concat <= 8'b0;
        end else if (shift_enable) begin
            // This is also correct - concatenation with non-blocking assignment
            shift_reg_concat <= {serial_in, shift_reg_concat[7:1]};
        end
    end
    
    // Display educational information
    initial begin
        $display("=== SHIFT REGISTER ASSIGNMENT COMPARISON ===");
        $display("CORRECT (<=):   Each bit shifts one position per clock");
        $display("INCORRECT (=):  Input propagates through ALL bits in one clock");
        $display("=> Watch how serial_in='1' behaves differently:");
        $display("   - Correct: Takes 8 clocks to reach serial_out");
        $display("   - Incorrect: Reaches serial_out in 1 clock!");
        $display("===========================================");
    end

endmodule