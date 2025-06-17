// conditional_example.sv
module conditional_example;
    logic [7:0] a = 8'd10;
    logic [7:0] b = 8'd20;
    logic [7:0] max_val;
    logic [7:0] abs_diff;
    logic [1:0] sel = 2'b10;
    logic [7:0] mux_out;
    
    initial begin
        $display();                                    // Display empty line
        $display("Hello from conditional design!");    // Display message
        
        // Find maximum
        max_val = (a > b) ? a : b;  // max_val = 20
        
        // Absolute difference
        abs_diff = (a > b) ? (a - b) : (b - a);  // abs_diff = 10
        
        // Nested conditional
        mux_out = (sel == 2'b00) ? 8'd1 :
                  (sel == 2'b01) ? 8'd2 :
                  (sel == 2'b10) ? 8'd4 : 8'd8;  // mux_out = 4
        
        $display("max(%d, %d) = %d", a, b, max_val);
        $display("abs_diff = %d", abs_diff);
        $display("mux_out = %d", mux_out);
    end
endmodule