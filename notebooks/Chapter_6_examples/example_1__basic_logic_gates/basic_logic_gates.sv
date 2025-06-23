// basic_logic_gates.sv
module basic_logic_gates (
    input  logic a,        // First input
    input  logic b,        // Second input
    output logic and_out,  // AND gate output
    output logic or_out,   // OR gate output  
    output logic xor_out,  // XOR gate output
    output logic nand_out  // NAND gate output
);

    // Combinational logic assignments
    assign and_out  = a & b;   // AND gate
    assign or_out   = a | b;   // OR gate
    assign xor_out  = a ^ b;   // XOR gate
    assign nand_out = ~(a & b); // NAND gate (inverted AND)

    // Display gate outputs whenever inputs change
    always_comb begin
        $display(
            "Inputs: a=%b, b=%b | Outputs: AND=%b, OR=%b, XOR=%b, NAND=%b", 
            a, b, and_out, or_out, xor_out, nand_out);
    end

endmodule