// bit_manipulation_functions_testbench.sv
module bit_manipulation_functions_testbench;

  // Instantiate design under test
  bit_manipulation_functions BIT_MANIP_DUT();

  // Test variables
  logic [31:0] test_data_word;
  logic [7:0] test_input_byte;
  logic [15:0] shift_test_data;
  int expected_ones_count;
  logic [7:0] expected_reversed_byte;
  logic [31:0] expected_mask_value;
  logic [31:0] expected_extracted_field;
  logic [15:0] expected_shifted_result;

  initial begin
    // Setup waveform dump
    $dumpfile("bit_manipulation_functions_testbench.vcd");
    $dumpvars(0, bit_manipulation_functions_testbench);
    
    $display("=== Comprehensive Bit Manipulation Testing ===");
    $display();
    
    // Test Case 1: Count ones function verification
    test_data_word = 32'hFFFF_0000;  // 16 ones, 16 zeros
    expected_ones_count = 16;
    #1;
    if (BIT_MANIP_DUT.count_ones(test_data_word) == expected_ones_count) begin
      $display("PASS: count_ones(0x%08h) = %0d", 
               test_data_word, BIT_MANIP_DUT.count_ones(test_data_word));
    end else begin
      $display("FAIL: count_ones(0x%08h) = %0d, expected %0d", 
               test_data_word, BIT_MANIP_DUT.count_ones(test_data_word), 
               expected_ones_count);
    end
    
    // Test Case 2: Byte bit reversal verification
    test_input_byte = 8'b1100_0011;  // 0xC3
    expected_reversed_byte = 8'b1100_0011;  // Same when palindromic
    #1;
    if (BIT_MANIP_DUT.reverse_byte_bits(test_input_byte) == expected_reversed_byte) begin
      $display("PASS: reverse_byte_bits(0x%02h) = 0x%02h", 
               test_input_byte, BIT_MANIP_DUT.reverse_byte_bits(test_input_byte));
    end else begin
      $display("FAIL: reverse_byte_bits(0x%02h) = 0x%02h, expected 0x%02h", 
               test_input_byte, BIT_MANIP_DUT.reverse_byte_bits(test_input_byte),
               expected_reversed_byte);
    end
    
    // Test Case 3: Bit mask creation verification
    expected_mask_value = 32'h0000_0F00;  // 4 bits at position 8
    #1;
    if (BIT_MANIP_DUT.create_bit_mask(4, 8) == expected_mask_value) begin
      $display("PASS: create_bit_mask(4, 8) = 0x%08h", 
               BIT_MANIP_DUT.create_bit_mask(4, 8));
    end else begin
      $display("FAIL: create_bit_mask(4, 8) = 0x%08h, expected 0x%08h", 
               BIT_MANIP_DUT.create_bit_mask(4, 8), expected_mask_value);
    end
    
    // Test Case 4: Bit field extraction verification
    test_data_word = 32'hABCD_EF12;
    expected_extracted_field = 32'h0000_00CD;  // Bits [15:8] = 0xCD
    #1;
    if (BIT_MANIP_DUT.extract_bit_field(test_data_word, 8, 8) == 
        expected_extracted_field) begin
      $display("PASS: extract_bit_field(0x%08h, 8, 8) = 0x%08h", 
               test_data_word, BIT_MANIP_DUT.extract_bit_field(test_data_word, 8, 8));
    end else begin
      $display("FAIL: extract_bit_field(0x%08h, 8, 8) = 0x%08h, expected 0x%08h", 
               test_data_word, BIT_MANIP_DUT.extract_bit_field(test_data_word, 8, 8),
               expected_extracted_field);
    end
    
    // Test Case 5: Circular shift verification
    shift_test_data = 16'hF000;  // 1111_0000_0000_0000
    expected_shifted_result = 16'h000F;  // After 4-bit left shift
    #1;
    if (BIT_MANIP_DUT.circular_left_shift(shift_test_data, 4) == 
        expected_shifted_result) begin
      $display("PASS: circular_left_shift(0x%04h, 4) = 0x%04h", 
               shift_test_data, 
               BIT_MANIP_DUT.circular_left_shift(shift_test_data, 4));
    end else begin
      $display("FAIL: circular_left_shift(0x%04h, 4) = 0x%04h, expected 0x%04h", 
               shift_test_data, 
               BIT_MANIP_DUT.circular_left_shift(shift_test_data, 4),
               expected_shifted_result);
    end
    
    $display();
    $display("=== Bit Manipulation Testing Complete ===");
    
    #1;
    $finish;
  end

endmodule