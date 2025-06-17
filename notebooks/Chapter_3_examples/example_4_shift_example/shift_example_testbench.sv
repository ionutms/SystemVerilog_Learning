// shift_example_testbench.sv
module shift_example_testbench;  // Testbench module
  shift_example DESIGN_INSTANCE();  // Instantiate design under test
  
  // Variables for verification - moved to module level
  logic [7:0] test_data = 8'b10110100;
  logic signed [7:0] test_signed = 8'sb10110100;
  
  // Edge case variables - moved to module level
  logic [7:0] all_ones = 8'b11111111;
  logic [7:0] all_zeros = 8'b00000000;
  logic signed [7:0] neg_one = -1;
  
  initial begin
    // Dump waves
    $dumpfile("shift_example_testbench.vcd");       // Specify the VCD file
    $dumpvars(0, shift_example_testbench);          // Dump all variables in the test module
    #1;                                             // Wait for a time unit
    $display("Hello from shift operations testbench!");       // Display message
    $display("Testing all shift operators...");
    $display();                                     // Display empty line
    
    // Wait for design to complete its operations
    #20;  // Longer wait for multiple test patterns
    
    // Display final results from the design
    $display();
    $display("=== Test Results Summary ===");
    $display("Final unsigned result: %b (decimal %d)", 
             DESIGN_INSTANCE.result, DESIGN_INSTANCE.result);
    $display("Final signed result: %b (decimal %d)", 
             DESIGN_INSTANCE.signed_result, DESIGN_INSTANCE.signed_result);
    
    // Manual verification of shift operations
    $display();
    $display("=== Manual Verification ===");
    $display("Test data: %b (decimal %d)", test_data, test_data);
    
    $display("Logical shifts:");
    $display("  << 2: Expected %b, Manual calc: %b", test_data << 2, test_data << 2);
    $display("  >> 2: Expected %b, Manual calc: %b", test_data >> 2, test_data >> 2);
    
    $display("Arithmetic shifts:");
    $display("  <<< 2: Expected %b, Manual calc: %b", test_data <<< 2, test_data <<< 2);
    $display("  >>> 2: Expected %b, Manual calc: %b", test_signed >>> 2, test_signed >>> 2);
    
    // Bit-by-bit analysis
    $display();
    $display("=== Bit-by-bit Analysis ===");
    $display("Original: %b", test_data);
    $display("Positions: 76543210");
    $display("After << 2: %b (bits shifted left, zeros fill right)", test_data << 2);
    $display("After >> 2: %b (bits shifted right, zeros fill left)", test_data >> 2);
    
    $display();
    $display("Signed arithmetic right shift analysis:");
    $display("Original signed: %b (decimal %d)", test_signed, test_signed);
    $display("After >>> 2:     %b (decimal %d) - sign bit extended", 
             test_signed >>> 2, test_signed >>> 2);
    $display("Sign bit (%b) extended to fill left positions", test_signed[7]);
    
    // Edge case testing
    $display();
    $display("=== Edge Case Testing ===");
    
    $display("All ones (%b):", all_ones);
    $display("  << 1 = %b", all_ones << 1);
    $display("  >> 1 = %b", all_ones >> 1);
    
    $display("All zeros (%b):", all_zeros);
    $display("  << 3 = %b", all_zeros << 3);
    $display("  >> 3 = %b", all_zeros >> 3);
    
    $display("Negative one (%b = %d):", neg_one, neg_one);
    $display("  >>> 1 = %b = %d", neg_one >>> 1, neg_one >>> 1);
    $display("  >>> 3 = %b = %d", neg_one >>> 3, neg_one >>> 3);
    
    $display("=== Test Completed Successfully ===");
    $display();
    
    // End simulation
    $finish;
  end

endmodule