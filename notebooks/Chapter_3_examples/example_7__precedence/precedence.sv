// precedence.sv
module precedence;
    logic [7:0] a = 8'd2;
    logic [7:0] b = 8'd3;
    logic [7:0] c = 8'd4;
    logic [7:0] result;
    
    initial begin
        $display();                                      // Display empty line
        $display("Hello from precedence design!");       // Display message
        
        // Without parentheses - follows precedence
        result = a + b * c;     // 2 + (3 * 4) = 14
        $display("a + b * c = %d", result);
        
        // With parentheses - overrides precedence
        result = (a + b) * c;   // (2 + 3) * 4 = 20
        $display("(a + b) * c = %d", result);
        
        // Complex expression
        result = a < b && b < c ? a + b : b * c;
        // Evaluated as: ((a < b) && (b < c)) ? (a + b) : (b * c)
        // Result: 5 (since 2 < 3 && 3 < 4 is true)
        $display("Complex expression = %d", result);
        
        // Additional precedence examples
        result = a | b & c;     // a | (b & c) = 2 | (3 & 4) = 2 | 0 = 2
        $display("a | b & c = %d", result);
        
        result = (a | b) & c;   // (2 | 3) & 4 = 3 & 4 = 0
        $display("(a | b) & c = %d", result);
        
        // Shift and arithmetic precedence
        result = a + b << 1;    // (a + b) << 1 = (2 + 3) << 1 = 5 << 1 = 10
        $display("a + b << 1 = %d", result);
        
        result = a + (b << 1);  // a + (b << 1) = 2 + (3 << 1) = 2 + 6 = 8
        $display("a + (b << 1) = %d", result);
    end
endmodule