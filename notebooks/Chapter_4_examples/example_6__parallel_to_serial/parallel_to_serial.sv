// parallel_to_serial.sv
module parallel_to_serial(
    input logic clk, rst_n, load,
    input logic [7:0] parallel_in,
    output logic serial_out, done
);
    logic [7:0] shift_reg;
    logic [2:0] count;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'h00;
            count <= 3'd0;
        end else if (load) begin
            shift_reg <= parallel_in;
            count <= 3'd0;
        end else if (count < 3'd7) begin
            shift_reg <= {shift_reg[6:0], 1'b0};
            count <= count + 1'b1;
        end
    end
    
    assign serial_out = shift_reg[7];
    assign done = (count == 3'd7);
endmodule