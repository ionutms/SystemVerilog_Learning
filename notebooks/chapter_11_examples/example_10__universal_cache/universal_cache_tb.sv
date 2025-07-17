module universal_cache_tb;

logic clk;
logic rst;
logic [7:0] key;
logic [7:0] value;
logic put;
logic [7:0] output_value;
logic hit;

universal_cache #(.KEY_WIDTH(8), .VALUE_WIDTH(8), .CACHE_SIZE(4)) dut (
    .clk(clk),
    .rst(rst),
    .key(key),
    .value(value),
    .put(put),
    .output_value(output_value),
    .hit(hit)
);

initial begin
    $dumpfile("universal_cache_tb.vcd");
    $dumpvars(0, universal_cache_tb);
end

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 1;
    #10 rst = 0;
    $display("=== Universal Cache Testbench Started ===");

    $display("Testing cache put/get...");
    key = 1;
    value = 10;
    put = 1;
    #10 put = 0;
    #10 key = 2;
    #10 value = 20;
    put = 1;
    #10 put = 0;
    #10 key = 1;
    #10 if (output_value != 10) $display("Error: cache get failed");
    else $display("Test cache put/get: PASSED");

    $display("Testing cache hit...");
    key = 2;
    #10 if (hit != 1) $display("Error: cache hit failed");
    else $display("Test cache hit: PASSED");

    $display("Testing cache miss...");
    key = 3;
    #10 if (hit != 0) $display("Error: cache miss failed");
    else $display("Test cache miss: PASSED");

    $display("=== Testbench Completed ===");
    #10 $finish;
end

endmodule