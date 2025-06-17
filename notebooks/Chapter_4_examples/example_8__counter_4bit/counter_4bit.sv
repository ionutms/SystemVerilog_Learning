// counter_4bit.sv
module counter_4bit (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       enable,
    output logic [3:0] count
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0000;
            $display("Counter reset - count = %0d", count);
        end
        else if (enable) begin
            count <= count + 1;
            $display("Counter enabled - count = %0d", count + 1);
        end
        else begin
            $display("Counter disabled - count = %0d", count);
        end
    end

endmodule