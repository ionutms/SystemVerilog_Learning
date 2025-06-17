// reduction_example.sv
module reduction_example;
    logic [7:0] data = 8'b11010010;
    logic result;
    
    initial begin
        #10; // Wait for 10 time units before starting operations
        $display();
        $display("Starting reduction operations...");
        $display("Input data: %b (decimal %d)", data, data);
        $display("Bit count analysis: %d ones, %d zeros", $countones(data), 8-$countones(data));
        $display();
        
        // Reduction operations
        result = &data;   // 1'b0 (not all bits are 1)
        $display("&data = %b (AND reduction - all bits 1?)", result);
        
        result = |data;   // 1'b1 (at least one bit is 1)
        $display("|data = %b (OR reduction - any bit 1?)", result);
        
        result = ^data;   // 1'b1 (odd number of 1s - parity)
        $display("^data = %b (XOR reduction - odd parity?)", result);
        
        result = ~&data;  // 1'b1 (NAND - not all bits are 1)
        $display("~&data = %b (NAND reduction - not all bits 1?)", result);
        
        result = ~|data;  // 1'b0 (NOR - not all bits are 0)
        $display("~|data = %b (NOR reduction - all bits 0?)", result);
        
        result = ~^data;  // 1'b0 (XNOR - even parity)
        $display("~^data = %b (XNOR reduction - even parity?)", result);
        
        $display();
        
        // Additional test with different data patterns
        $display("=== Testing with different patterns ===");
        
        // Test with all 1s
        data = 8'b11111111;
        $display("All 1s (%b): &=%b |=%b ^=%b", data, &data, |data, ^data);
        
        // Test with all 0s
        data = 8'b00000000;
        $display("All 0s (%b): &=%b |=%b ^=%b", data, &data, |data, ^data);
        
        // Test with single 1
        data = 8'b00000001;
        $display("Single 1 (%b): &=%b |=%b ^=%b", data, &data, |data, ^data);
        
        // Test with even number of 1s
        data = 8'b11000011;
        $display("Even 1s (%b): &=%b |=%b ^=%b", data, &data, |data, ^data);
        
        $display();
        $display("All reduction operations completed successfully!");
        $display();
    end
endmodule