module universal_cache #(
    parameter int unsigned KEY_WIDTH = 8,
    parameter int unsigned VALUE_WIDTH = 8,
    parameter int unsigned CACHE_SIZE = 4
) (
    input logic clk,
    input logic rst,
    input logic [KEY_WIDTH-1:0] key,
    input logic [VALUE_WIDTH-1:0] value,
    input logic put,
    output logic [VALUE_WIDTH-1:0] output_value,
    output logic hit
);

logic [CACHE_SIZE-1:0][KEY_WIDTH-1:0] cache_keys;
logic [CACHE_SIZE-1:0][VALUE_WIDTH-1:0] cache_values;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        cache_keys <= 0;
        cache_values <= 0;
    end else begin
        if (put) begin
            cache_keys[0] <= key;
            cache_values[0] <= value;
            for (int i = 1; i < CACHE_SIZE; i++) begin
                cache_keys[i] <= cache_keys[i-1];
                cache_values[i] <= cache_values[i-1];
            end
        end
    end
end

always_comb begin
    hit = 0;
    output_value = 0;
    for (int i = 0; i < CACHE_SIZE; i++) begin
        if (cache_keys[i] == key) begin
            hit = 1;
            output_value = cache_values[i];
            break;
        end
    end
end

endmodule