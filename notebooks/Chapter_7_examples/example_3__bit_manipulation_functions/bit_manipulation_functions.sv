// bit_manipulation_functions.sv
module bit_manipulation_functions ();

  // Function to count number of set bits (population count)
  function automatic int count_ones(input logic [31:0] data_word);
    int bit_count = 0;
    for (int bit_index = 0; bit_index < 32; bit_index++) begin
      if (data_word[bit_index]) bit_count++;
    end
    return bit_count;
  endfunction

  // Function to reverse bits in a byte
  function automatic logic [7:0] reverse_byte_bits(input logic [7:0] byte_in);
    logic [7:0] reversed_byte;
    for (int bit_pos = 0; bit_pos < 8; bit_pos++) begin
      reversed_byte[7-bit_pos] = byte_in[bit_pos];
    end
    return reversed_byte;
  endfunction

  // Function to create bit mask with specified width and position
  function automatic logic [31:0] create_bit_mask(input int mask_width, 
                                                   input int start_position);
    logic [31:0] generated_mask = 0;
    for (int mask_bit = 0; mask_bit < mask_width; mask_bit++) begin
      generated_mask[start_position + mask_bit] = 1'b1;
    end
    return generated_mask;
  endfunction

  // Function to extract bit field from word
  function automatic logic [31:0] extract_bit_field(input logic [31:0] source_word,
                                                     input int field_width,
                                                     input int field_position);
    logic [31:0] extraction_mask;
    extraction_mask = create_bit_mask(field_width, field_position);
    return (source_word & extraction_mask) >> field_position;
  endfunction

  // Function to perform circular left shift
  function automatic logic [15:0] circular_left_shift(input logic [15:0] shift_data,
                                                       input int shift_amount);
    int effective_shift = shift_amount % 16;
    return (shift_data << effective_shift) | (shift_data >> (16 - effective_shift));
  endfunction

  initial begin
    logic [31:0] test_word = 32'hA5C3_F0E1;
    logic [7:0] test_byte = 8'b1010_0011;
    logic [15:0] rotation_data = 16'hBEEF;
    
    $display("=== Bit Manipulation Functions Demo ===");
    $display();
    
    // Test count_ones function
    $display("Count ones in 0x%08h: %0d bits", test_word, count_ones(test_word));
    
    // Test reverse_byte_bits function  
    $display("Reverse bits in 0x%02h: 0x%02h", test_byte, 
             reverse_byte_bits(test_byte));
    
    // Test create_bit_mask function
    $display("Create 4-bit mask at position 8: 0x%08h", 
             create_bit_mask(4, 8));
    
    // Test extract_bit_field function
    $display("Extract 8 bits from position 16 of 0x%08h: 0x%02h", 
             test_word, extract_bit_field(test_word, 8, 16));
    
    // Test circular_left_shift function
    $display("Circular left shift 0x%04h by 4 positions: 0x%04h", 
             rotation_data, circular_left_shift(rotation_data, 4));
    
    $display();
  end

endmodule