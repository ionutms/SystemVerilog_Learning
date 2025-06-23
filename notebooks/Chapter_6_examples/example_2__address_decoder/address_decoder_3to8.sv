// address_decoder_3to8.sv
module address_decoder_3to8 (
    input  logic [2:0] address,    // 3-bit address input (0-7)
    input  logic       enable,     // Active high enable signal
    output logic [7:0] decoded_out // 8-bit one-hot output
);

    // Address decoder logic using case statement
    always_comb begin
        if (enable) begin
            case (address)
                3'b000: decoded_out = 8'b00000001; // Address 0 -> bit 0
                3'b001: decoded_out = 8'b00000010; // Address 1 -> bit 1
                3'b010: decoded_out = 8'b00000100; // Address 2 -> bit 2
                3'b011: decoded_out = 8'b00001000; // Address 3 -> bit 3
                3'b100: decoded_out = 8'b00010000; // Address 4 -> bit 4
                3'b101: decoded_out = 8'b00100000; // Address 5 -> bit 5
                3'b110: decoded_out = 8'b01000000; // Address 6 -> bit 6
                3'b111: decoded_out = 8'b10000000; // Address 7 -> bit 7
                default: decoded_out = 8'b00000000; // Should never happen
            endcase
        end else begin
            // All outputs disabled when enable is low
            decoded_out = 8'b00000000; 
        end
    end

    // Display decoder operation
    always_comb begin
        if (enable) begin
            $display(
                "Address Decoder: Enable=%b, Address=%3b (%0d) -> %8b", 
                enable, address, address, decoded_out);
        end else begin
            $display(
                "Address Decoder: Enable=%b -> All outputs disabled", 
                enable);
        end
    end

endmodule