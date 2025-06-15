// instruction_decoder.sv
module instruction_decoder(
    input logic [7:0] instruction,
    output logic [2:0] op_type
);
    always_comb begin
        /* verilator lint_off CASEX */
        casex (instruction)
            8'b000?????: op_type = 3'b001;  // Load instructions
            8'b001?????: op_type = 3'b010;  // Store instructions
            8'b010?????: op_type = 3'b011;  // Arithmetic
            8'b011?????: op_type = 3'b100;  // Logic
            8'b1???????: op_type = 3'b101;  // Branch
            default:     op_type = 3'b000;  // NOP
        endcase
        /* verilator lint_on CASEX */
    end
endmodule