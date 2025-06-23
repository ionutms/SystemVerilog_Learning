// bcd_seven_segment.sv
// BCD to Seven-Segment Display Decoder
// Converts 4-bit BCD input (0-9) to 7-segment display pattern

module bcd_seven_segment (
    input  logic [3:0] bcd_in,      // 4-bit BCD input (0-9)
    output logic [6:0] segments     // 7-segment output [a,b,c,d,e,f,g]
);

    // Seven-segment display layout:
    //  aaa
    // f   b
    // f   b
    //  ggg
    // e   c
    // e   c
    //  ddd
    
    // segments[6] = a, segments[5] = b, segments[4] = c, segments[3] = d
    // segments[2] = e, segments[1] = f, segments[0] = g
    // Active HIGH (1 = segment ON, 0 = segment OFF)

    always_comb begin
        case (bcd_in)
            4'h0: segments = 7'b1111110; // Display "0" - all except g
            4'h1: segments = 7'b0110000; // Display "1" - b,c only
            4'h2: segments = 7'b1101101; // Display "2" - a,b,d,e,g
            4'h3: segments = 7'b1111001; // Display "3" - a,b,c,d,g
            4'h4: segments = 7'b0110011; // Display "4" - b,c,f,g
            4'h5: segments = 7'b1011011; // Display "5" - a,c,d,f,g
            4'h6: segments = 7'b1011111; // Display "6" - a,c,d,e,f,g
            4'h7: segments = 7'b1110000; // Display "7" - a,b,c
            4'h8: segments = 7'b1111111; // Display "8" - all segments
            4'h9: segments = 7'b1111011; // Display "9" - a,b,c,d,f,g
            default: segments = 7'b0000000; // Blank display for invalid BCD
        endcase
    end

    // Display decoder operation for simulation
    always_comb begin
        case (bcd_in)
            4'h0: $display(
                "BCD Decoder: %h -> '0' (segments: %7b)", bcd_in, segments);
            4'h1: $display(
                "BCD Decoder: %h -> '1' (segments: %7b)", bcd_in, segments);
            4'h2: $display(
                "BCD Decoder: %h -> '2' (segments: %7b)", bcd_in, segments);
            4'h3: $display(
                "BCD Decoder: %h -> '3' (segments: %7b)", bcd_in, segments);
            4'h4: $display(
                "BCD Decoder: %h -> '4' (segments: %7b)", bcd_in, segments);
            4'h5: $display(
                "BCD Decoder: %h -> '5' (segments: %7b)", bcd_in, segments);
            4'h6: $display(
                "BCD Decoder: %h -> '6' (segments: %7b)", bcd_in, segments);
            4'h7: $display(
                "BCD Decoder: %h -> '7' (segments: %7b)", bcd_in, segments);
            4'h8: $display(
                "BCD Decoder: %h -> '8' (segments: %7b)", bcd_in, segments);
            4'h9: $display(
                "BCD Decoder: %h -> '9' (segments: %7b)", bcd_in, segments);
            default: $display(
                "BCD Decoder: %h -> BLANK (invalid BCD)", bcd_in);
        endcase
    end

endmodule