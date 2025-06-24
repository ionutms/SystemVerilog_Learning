// lfsr_generator_design.sv
module lfsr_4bit_generator (
    input  logic clock,
    input  logic reset_n,
    input  logic enable,
    output logic [3:0] lfsr_output,
    output logic random_bit
);

    // 4-bit LFSR register
    logic [3:0] lfsr_register;
    logic feedback_bit;
    
    // XOR feedback taps for 4-bit LFSR (polynomial: x^4 + x^3 + 1)
    // Taps at positions 4 and 3 (bits 3 and 2 in 0-indexed)
    assign feedback_bit = lfsr_register[3] ^ lfsr_register[2];
    
    always_ff @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            // Initialize with non-zero seed (avoid all-zeros state)
            lfsr_register <= 4'b0001;
        end
        else if (enable) begin
            // Shift left and insert feedback bit at LSB
            lfsr_register <= {lfsr_register[2:0], feedback_bit};
        end
    end
    
    // Outputs
    assign lfsr_output = lfsr_register;
    assign random_bit = lfsr_register[3];  // MSB as random output
    
    // Display current state and feedback for debugging
    always @(posedge clock) begin
        if (enable && reset_n) begin
            $display("LFSR: %b, Feedback: %b, Random bit: %b", 
                     lfsr_register, feedback_bit, random_bit);
        end
    end

endmodule