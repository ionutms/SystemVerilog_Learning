module scoreboard #(type T = int) (
    input  logic clk,
    input  T expected,
    input  T actual,
    input  logic check
);

    integer pass_count = 0;
    integer fail_count = 0;

    always @(posedge clk) begin
        if (check) begin
            if (expected == actual) begin
                pass_count++;
                $display("Test PASSED: Expected %d, Got %d", expected, actual);
            end else begin
                fail_count++;
                $display("Test FAILED: Expected %d, Got %d", expected, actual);
            end
        end
    end

    always @(posedge clk) begin
        $display("Scoreboard: %d Passed, %d Failed", pass_count, fail_count);
    end

endmodule