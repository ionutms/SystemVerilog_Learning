// Testbench module: generic_pair_tb
module generic_pair_tb;
    // Instantiate the design module
    generic_pair #(
        .T1(integer),
        .T2(string)
    ) dut (
        .value1(10),
        .value2("Hello"),
        .first(out_first),
        .second(out_second)
    );

    integer out_first;
    string out_second;

    initial begin
        $dumpfile("generic_pair_tb.vcd");
        $dumpvars(0, generic_pair_tb);

        $display("=== Generic Pair Testbench Started ===");

        $display("Testing generic pair...");
        $display("Applying inputs: value1 = 10, value2 = 'Hello'");

        #10; // Wait for 10 time units
        $display("Time %0t: Checking outputs...", $time);
        $display("Expected: first = 10, second = 'Hello'");
        $display("Got: first = %d, second = %s", out_first, out_second);

        if (out_first == 10 && out_second == "Hello") begin
            $display("Test generic_pair: PASSED");
        end else begin
            $display("Test generic_pair: FAILED");
        end

        $display("=== Testbench Completed ===");
        $finish;
    end
endmodule