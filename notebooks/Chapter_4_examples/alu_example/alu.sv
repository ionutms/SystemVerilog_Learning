// alu.sv
module alu(
    input logic [3:0] opcode,
    input logic [7:0] a, b,
    output logic [7:0] result,
    output logic zero
);
    always_comb begin
        case (opcode)
            4'b0000: result = a + b;        // ADD
            4'b0001: result = a - b;        // SUB
            4'b0010: result = a & b;        // AND
            4'b0011: result = a | b;        // OR
            4'b0100: result = a ^ b;        // XOR
            4'b0101: result = ~a;           // NOT
            4'b0110: result = a << 1;       // Shift left
            4'b0111: result = a >> 1;       // Shift right
            default: result = 8'h00;
        endcase
        
        zero = (result == 8'h00);
    end
endmodule