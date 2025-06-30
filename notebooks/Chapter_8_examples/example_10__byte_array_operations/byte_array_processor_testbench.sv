// byte_array_processor_testbench.sv
module byte_array_testbench;

  // Testbench signals
  logic        test_clock;
  logic        test_reset;
  logic [31:0] test_data_word;
  logic [1:0]  test_byte_select;
  logic        test_write_enable;
  logic [7:0]  result_selected_byte;
  logic        result_byte_parity;
  logic [3:0]  result_nibble_high;
  logic [3:0]  result_nibble_low;

  // Instantiate design under test
  byte_array_processor BYTE_PROCESSOR_INSTANCE (
    .clock(test_clock),
    .reset(test_reset),
    .data_word(test_data_word),
    .byte_select(test_byte_select),
    .write_enable(test_write_enable),
    .selected_byte(result_selected_byte),
    .byte_parity(result_byte_parity),
    .nibble_high(result_nibble_high),
    .nibble_low(result_nibble_low)
  );

  // Clock generation
  always #5 test_clock = ~test_clock;

  initial begin
    // Dump waves
    $dumpfile("byte_array_testbench.vcd");
    $dumpvars(0, byte_array_testbench);
    
    // Initialize signals
    test_clock = 0;
    test_reset = 1;
    test_data_word = 32'h00000000;
    test_byte_select = 2'b00;
    test_write_enable = 0;
    
    $display("=== Byte Array Operations Test ===");
    $display();
    
    // Release reset
    #10 test_reset = 0;
    
    // Test 1: Write test pattern and access different bytes
    $display("Test 1: Writing byte pattern 0xDEADBEEF");
    test_data_word = 32'hDEADBEEF;
    test_write_enable = 1;
    #10;
    test_write_enable = 0;
    
    // Access each byte and show bit-level operations
    for (int byte_index = 0; byte_index < 4; byte_index++) begin
      test_byte_select = byte_index[1:0];
      #5;
      $display("Byte[%0d]: 0x%02h, Parity: %b, High: 0x%01h, Low: 0x%01h",
               byte_index, result_selected_byte, result_byte_parity,
               result_nibble_high, result_nibble_low);
    end
    
    $display();
    
    // Test 2: Write different pattern and test bit access
    $display("Test 2: Writing byte pattern 0x12345678");
    test_data_word = 32'h12345678;
    test_write_enable = 1;
    #10;
    test_write_enable = 0;
    
    // Show byte-level access with bit operations
    for (int byte_index = 0; byte_index < 4; byte_index++) begin
      test_byte_select = byte_index[1:0];
      #5;
      $display("Byte[%0d]: 0x%02h = 8'b%08b, Nibbles: %04b_%04b",
               byte_index, result_selected_byte, result_selected_byte,
               result_nibble_high, result_nibble_low);
    end
    
    $display();
    $display("Byte array operations test completed!");
    
    #10 $finish;
  end

endmodule