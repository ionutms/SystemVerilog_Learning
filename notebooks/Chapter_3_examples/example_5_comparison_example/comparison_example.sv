// comparison_example.sv
module comparison_example;
    logic [3:0] a = 4'b1010;  // 10 in decimal
    logic [3:0] b = 4'b1010;  // 10 in decimal
    logic [3:0] c = 4'b1x1z;  // Contains unknown (x) and high-impedance (z)
    logic [3:0] d = 4'b0110;  // 6 in decimal
    logic [3:0] e = 4'b1111;  // 15 in decimal
    logic result;
    
    // Additional test variables
    logic signed [3:0] pos_num = 4'sb0111;  // +7
    logic signed [3:0] neg_num = 4'sb1001;  // -7 (two's complement)
    logic [7:0] wide_val = 8'b00001010;     // Same value as 'a' but wider
    
    initial begin
        #10; // Wait for initial setup
        $display();
        $display("Starting comparison operations...");
        $display("Values: a=%b(%d), b=%b(%d), c=%b, d=%b(%d), e=%b(%d)", 
                 a, a, b, b, c, d, d, e, e);
        $display("Signed values: pos_num=%b(%d), neg_num=%b(%d)", 
                 pos_num, pos_num, neg_num, neg_num);
        $display();
        
        // === EQUALITY COMPARISONS ===
        $display("=== Equality Comparisons ===");
        
        // Logical equality (==) and inequality (!=)
        result = (a == b);
        $display("a == b: %b == %b = %b (identical values)", a, b, result);
        
        result = (a != b);
        $display("a != b: %b != %b = %b (should be 0)", a, b, result);
        
        result = (a == d);
        $display("a == d: %b == %b = %b (different values)", a, d, result);
        
        result = (a != d);
        $display("a != d: %b != %b = %b (different values)", a, d, result);
        
        $display();
        
        // Comparisons with unknown values
        $display("=== Comparisons with Unknown Values ===");
        result = (a == c);
        $display("a == c: %b == %b = %b (unknown due to x/z in c)", a, c, result);
        
        result = (a != c);
        $display("a != c: %b != %b = %b (unknown due to x/z in c)", a, c, result);
        
        // Case equality (===) and case inequality (!==)
        result = (a === b);
        $display("a === b: %b === %b = %b (exact bit-by-bit match)", a, b, result);
        
        result = (a === c);
        $display("a === c: %b === %b = %b (exact comparison, no x/z match)", a, c, result);
        
        result = (c === c);
        $display("c === c: %b === %b = %b (identical including x/z)", c, c, result);
        
        result = (a !== c);
        $display("a !== c: %b !== %b = %b (case inequality)", a, c, result);
        
        $display();
        
        // === RELATIONAL COMPARISONS ===
        $display("=== Relational Comparisons ===");
        
        // Less than (<)
        result = (a < e);
        $display("a < e: %b(%d) < %b(%d) = %b", a, a, e, e, result);
        
        result = (d < a);
        $display("d < a: %b(%d) < %b(%d) = %b", d, d, a, a, result);
        
        result = (a < a);
        $display("a < a: %b(%d) < %b(%d) = %b (same values)", a, a, a, a, result);
        
        // Less than or equal (<=)
        result = (a <= b);
        $display("a <= b: %b(%d) <= %b(%d) = %b (equal values)", a, a, b, b, result);
        
        result = (d <= a);
        $display("d <= a: %b(%d) <= %b(%d) = %b", d, d, a, a, result);
        
        // Greater than (>)
        result = (e > a);
        $display("e > a: %b(%d) > %b(%d) = %b", e, e, a, a, result);
        
        result = (a > d);
        $display("a > d: %b(%d) > %b(%d) = %b", a, a, d, d, result);
        
        // Greater than or equal (>=)
        result = (a >= b);
        $display("a >= b: %b(%d) >= %b(%d) = %b (equal values)", a, a, b, b, result);
        
        result = (a >= d);
        $display("a >= d: %b(%d) >= %b(%d) = %b", a, a, d, d, result);
        
        $display();
        
        // === SIGNED COMPARISONS ===
        $display("=== Signed Number Comparisons ===");
        result = (pos_num > neg_num);
        $display("pos_num > neg_num: %b(%d) > %b(%d) = %b", 
                 pos_num, pos_num, neg_num, neg_num, result);
        
        result = (neg_num < pos_num);
        $display("neg_num < pos_num: %b(%d) < %b(%d) = %b", 
                 neg_num, neg_num, pos_num, pos_num, result);
        
        result = (neg_num < 4'sd0);
        $display("neg_num < 0: %b(%d) < 0 = %b", neg_num, neg_num, result);
        
        $display();
        
        // === WIDTH MISMATCHED COMPARISONS ===
        $display("=== Width Mismatched Comparisons ===");
        /* verilator lint_off WIDTHEXPAND */
        result = (a == wide_val);
        /* verilator lint_on WIDTHEXPAND */
        $display("a == wide_val: %b(%d) == %b(%d) = %b (different widths, same value)", 
                 a, a, wide_val, wide_val, result);
        
        result = (a === wide_val[3:0]);
        $display("a === wide_val[3:0]: %b === %b = %b (same width after slicing)", 
                 a, wide_val[3:0], result);
        
        $display();
        
        // === EDGE CASES ===
        $display("=== Edge Cases ===");
        
        // All zeros and all ones
        result = (4'b0000 == 4'd0);
        $display("4'b0000 == 4'd0: %b", result);
        
        result = (4'b1111 == 4'd15);
        $display("4'b1111 == 4'd15: %b", result);
        
        // Comparison with unknown results
        result = (c > d);
        $display("c > d: %b > %b(%d) = %b (unknown due to x/z)", c, d, d, result);
        
        result = (c < d);
        $display("c < d: %b < %b(%d) = %b (unknown due to x/z)", c, d, d, result);
        
        $display();
        
        // === CHAINED COMPARISONS ===
        $display("=== Chained Comparisons ===");
        result = (d < a) && (a < e);
        $display("(d < a) && (a < e): (%b < %b) && (%b < %b) = %b && %b = %b", 
                 d, a, a, e, (d < a), (a < e), result);
        
        result = (a >= d) || (a <= b);
        $display("(a >= d) || (a <= b): (%b >= %b) || (%b <= %b) = %b || %b = %b", 
                 a, d, a, b, (a >= d), (a <= b), result);
        
        $display();
        $display("All comparison operations completed successfully!");
    end
endmodule