// arithmetic_example.sv
module arithmetic_example;
    logic [7:0] a = 8'd25;
    logic [7:0] b = 8'd5;
    logic [15:0] result;
    
    logic signed [7:0] x = -8'd10;
    logic signed [7:0] y = 8'd3;
    logic signed [15:0] signed_result;
    
    initial begin
        $display();

        // Unsigned arithmetic operations
        // cast to 16-bit to match result width
        $display("a = %d", a);
        $display("b = %d", b);

        result = 16'(a + b);     // result = 30
        $display("a + b = %d", result);
        
        result = 16'(a - b);     // result = 20
        $display("a - b = %d", result);
        
        result = 16'(a * b);     // result = 125
        $display("a * b = %d", result);
        
        result = 16'(a / b);     // result = 5
        $display("a / b = %d", result);
        
        result = 16'(a % b);     // result = 0 (25 % 5)
        $display("a %% b = %d", result);
        
        result = 16'(a ** 2);    // result = 625 (25^2)
        $display("a ** 2 = %d", result);
        
        // Signed arithmetic operations
        // cast to 16-bit signed to match signed_result width
        $display();
        $display("x = %d", x);
        $display("y = %d", y);

        signed_result = 16'(signed'(x + y));  // -7
        $display("x + y = %d", signed_result);
        
        signed_result = 16'(signed'(x / y));  // -3 (truncated toward zero)
        $display("x / y = %d", signed_result);

        $display();
    end
endmodule