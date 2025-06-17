// bitwise_example.sv
module bitwise_example;
    logic [3:0] a = 4'b1010;
    logic [3:0] b = 4'b1100;
    logic [3:0] result;
    logic logical_result;
    
    initial begin
        #10; // Wait for 10 time units before starting operations
        $display("Starting logical and bitwise operations...");
        $display("Initial values: a = %b, b = %b", a, b);
        $display();

        $display("a = %b", a);
        $display("b = %b", b);
        
        // Bitwise operations
        result = a & b;     // 4'b1000
        $display("a & b = %b (bitwise AND)", result);
        
        result = a | b;     // 4'b1110
        $display("a | b = %b (bitwise OR)", result);
        
        result = a ^ b;     // 4'b0110
        $display("a ^ b = %b (bitwise XOR)", result);
        
        result = ~a;        // 4'b0101
        $display("~a = %b (bitwise NOT)", result);
        
        result = 4'(~&a);   // 1'b1 (NAND of all bits) - cast to 4-bit
        $display("~&a = %b (reduction NAND)", result);
        
        $display();
        
        // Logical operations
        logical_result = (a > 0) && (b > 0);  // 1'b1
        $display("(a > 0) && (b > 0) = %b (logical AND)", logical_result);
        
        logical_result = (a == 0) || (b == 0); // 1'b0
        $display("(a == 0) || (b == 0) = %b (logical OR)", logical_result);
        
        logical_result = !(a == b);            // 1'b1
        $display("!(a == b) = %b (logical NOT)", logical_result);
        
        $display();
        $display("All operations completed successfully!");
    end
endmodule