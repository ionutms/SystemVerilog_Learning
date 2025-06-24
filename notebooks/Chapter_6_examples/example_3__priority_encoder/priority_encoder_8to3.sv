// priority_encoder_8to3.sv
module priority_encoder_8to3 (
    input  logic [7:0] data_in,     // 8-bit input data
    output logic [2:0] encoded_out, // 3-bit encoded output
    output logic       valid_out    // Valid signal (any input active)
);

    // Priority encoder logic - highest bit wins
    always_comb begin
        if (data_in[7]) begin
            encoded_out = 3'b111;       // Input 7 has highest priority
            valid_out = 1'b1;
        end else if (data_in[6]) begin
            encoded_out = 3'b110;       // Input 6
            valid_out = 1'b1;
        end else if (data_in[5]) begin
            encoded_out = 3'b101;       // Input 5
            valid_out = 1'b1;
        end else if (data_in[4]) begin
            encoded_out = 3'b100;       // Input 4
            valid_out = 1'b1;
        end else if (data_in[3]) begin
            encoded_out = 3'b011;       // Input 3
            valid_out = 1'b1;
        end else if (data_in[2]) begin
            encoded_out = 3'b010;       // Input 2
            valid_out = 1'b1;
        end else if (data_in[1]) begin
            encoded_out = 3'b001;       // Input 1
            valid_out = 1'b1;
        end else if (data_in[0]) begin
            encoded_out = 3'b000;       // Input 0 (lowest priority)
            valid_out = 1'b1;
        end else begin
            encoded_out = 3'b000;       // No inputs active
            valid_out = 1'b0;
        end
    end

    // Display encoder operation
    always_comb begin
        if (valid_out) begin
            $display(
                "Priority Encoder: Input=%8b -> Encoded=%3b (%0d), Valid=%b", 
                data_in, encoded_out, encoded_out, valid_out);
            $display();
        end else begin
            $display(
                "Priority Encoder: Input=%8b -> No valid input (Valid=%b)", 
                data_in, valid_out);
            $display();
        end
    end

endmodule