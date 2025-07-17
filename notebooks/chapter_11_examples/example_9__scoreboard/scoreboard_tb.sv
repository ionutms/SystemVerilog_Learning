module scoreboard_tb;

    logic clk;
    integer expected;
    integer actual;
    logic check;

    scoreboard #(int) scoreboard_inst (
        .clk(clk),
        .expected(expected),
        .actual(actual),
        .check(check)
    );

    initial begin
        $dumpfile("scoreboard_tb.vcd");
        $dumpvars(0, scoreboard_tb);

        $display("=== Scoreboard Testbench Started ===");

        clk = 0;
        expected = 1;
        actual = 1;
        check = 1;

        #10 clk = 1;
        #10 clk = 0;

        expected = 2;
        actual = 2;
        check = 1;

        #10 clk = 1;
        #10 clk = 0;

        expected = 3;
        actual = 4;
        check = 1;

        #10 clk = 1;
        #10 clk = 0;

        $display("=== Testbench Completed ===");
        $finish;
    end

endmodule