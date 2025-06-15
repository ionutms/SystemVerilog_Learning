// comparator.sv
module comparator(
    input logic [7:0] a, b,
    output logic gt, eq, lt
);
    always_comb begin
        if (a > b) begin
            gt = 1'b1;
            eq = 1'b0;
            lt = 1'b0;
        end else if (a == b) begin
            gt = 1'b0;
            eq = 1'b1;
            lt = 1'b0;
        end else begin
            gt = 1'b0;
            eq = 1'b0;
            lt = 1'b1;
        end
    end
endmodule