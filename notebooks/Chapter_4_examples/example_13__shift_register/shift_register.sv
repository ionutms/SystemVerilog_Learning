// shift_register.sv
module shift_register (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       serial_in,
    output logic [7:0] parallel_out
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            parallel_out <= 8'h00;
            $display("Shift Register: Reset - parallel_out cleared");
        end else begin
            parallel_out <= {parallel_out[6:0], serial_in};
            $display("Shift Register: Shifted in %b, parallel_out = %b", serial_in, {parallel_out[6:0], serial_in});
        end
    end

endmodule