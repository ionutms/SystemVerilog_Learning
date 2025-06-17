// ripple_carry_adder.sv

// Full adder module (building block)
module full_adder(
    input logic a, b, cin,
    output logic sum, cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Ripple carry adder using generate block
module ripple_carry_adder #(parameter WIDTH = 8)(
    input logic [WIDTH-1:0] a, b,
    input logic cin,
    output logic [WIDTH-1:0] sum,
    output logic cout
);
    logic [WIDTH:0] carry;
    
    assign carry[0] = cin;
    
    generate
        for (genvar i = 0; i < WIDTH; i++) begin : adder_stage
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate
    
    assign cout = carry[WIDTH];
endmodule