// shift_example.sv
module shift_example;
    logic [7:0] data = 8'b10110100;
    logic signed [7:0] signed_data = 8'sb10110100; // -76 in decimal
    logic [7:0] result;
    logic signed [7:0] signed_result;
    
    // Move variable declaration to module level
    logic signed [7:0] pos_signed = 8'sb01110100; // +116
    
    initial begin
        #10; // Wait for initial setup
        $display();
        $display("Starting shift operations...");
        $display("Original data: %b (decimal %d)", data, data);
        $display("Signed data: %b (decimal %d)", signed_data, signed_data);
        $display();
        
        // Logical shifts
        result = data << 2;     // 8'b10110100 -> 8'b11010000
        $display("Logical left shift by 2:  %b << 2 = %b (decimal %d)", data, result, result);
        
        result = data >> 2;     // 8'b10110100 -> 8'b00101101
        $display("Logical right shift by 2: %b >> 2 = %b (decimal %d)", data, result, result);
        
        $display();
        
        // Arithmetic shifts
        result = data <<< 2;    // Same as logical left shift
        $display("Arithmetic left shift by 2:  %b <<< 2 = %b (decimal %d)", data, result, result);
        
        signed_result = signed_data >>> 2; // Sign extension: 8'b11101101
        $display("Arithmetic right shift by 2: %b >>> 2 = %b (decimal %d)", signed_data, signed_result, signed_result);
        
        $display();
        
        // Additional test patterns
        $display("=== Testing different shift amounts ===");
        
        // Test shift by 1
        $display("Shift by 1:");
        $display("  %b << 1 = %b", data, data << 1);
        $display("  %b >> 1 = %b", data, data >> 1);
        $display("  %b >>> 1 = %b (signed)", signed_data, signed_data >>> 1);
        
        // Test shift by 4
        $display("Shift by 4:");
        $display("  %b << 4 = %b", data, data << 4);
        $display("  %b >> 4 = %b", data, data >> 4);
        $display("  %b >>> 4 = %b (signed)", signed_data, signed_data >>> 4);
        
        $display();
        
        // Test with positive signed number
        $display("=== Testing with positive signed number ===");
        $display("Positive signed: %b (decimal %d)", pos_signed, pos_signed);
        $display("  >>> 2 = %b (decimal %d)", pos_signed >>> 2, pos_signed >>> 2);
        
        $display();
        $display("All shift operations completed successfully!");
    end
endmodule