// encoder_width_selector_testbench.sv
module encoder_width_selector_testbench;

  // Test signals for different encoder widths
  logic [1:0]  data_in_2,  encoded_out_2;
  logic [3:0]  data_in_4,  encoded_out_4;
  logic [7:0]  data_in_8,  encoded_out_8;
  logic [15:0] data_in_16, encoded_out_16;
  logic        valid_out_2, valid_out_4, valid_out_8, valid_out_16;
  
  // Fixed: Correct signal widths for invalid width test
  logic [2:0] data_in_3;
  logic [1:0] encoded_out_3;  // $clog2(3) = 2, so output is [1:0]
  logic valid_out_3;

  // Instance 1: 2-to-1 encoder
  encoder_width_selector #(.INPUT_WIDTH(2)) encoder_2 (
    .data_in(data_in_2),
    .encoded_out(encoded_out_2[0]),  // Only need 1 bit
    .valid_out(valid_out_2)
  );

  // Instance 2: 4-to-2 encoder
  encoder_width_selector #(.INPUT_WIDTH(4)) encoder_4 (
    .data_in(data_in_4),
    .encoded_out(encoded_out_4[1:0]),  // Only need 2 bits
    .valid_out(valid_out_4)
  );

  // Instance 3: 8-to-3 encoder
  encoder_width_selector #(.INPUT_WIDTH(8)) encoder_8 (
    .data_in(data_in_8),
    .encoded_out(encoded_out_8[2:0]),  // Only need 3 bits
    .valid_out(valid_out_8)
  );

  // Instance 4: 16-to-4 encoder
  encoder_width_selector #(.INPUT_WIDTH(16)) encoder_16 (
    .data_in(data_in_16),
    .encoded_out(encoded_out_16[3:0]),  // Only need 4 bits
    .valid_out(valid_out_16)
  );

  // Instance 5: Invalid width (3) - Fixed width mismatch
  encoder_width_selector #(.INPUT_WIDTH(3)) encoder_invalid (
    .data_in(data_in_3),
    .encoded_out(encoded_out_3),  // Now correctly sized as [1:0]
    .valid_out(valid_out_3)
  );

  initial begin
    // Dump waves
    $dumpfile("encoder_width_selector_testbench.vcd");
    $dumpvars(0, encoder_width_selector_testbench);
    
    $display("=== Encoder Width Selector Testbench ===");
    $display("Testing parameter-based selection with generate case");
    $display();
    
    // Wait for generation messages
    #1;
    
    // Test 2-to-1 encoder
    $display("--- Testing 2-to-1 Encoder ---");
    data_in_2 = 2'b01; #1;
    $display("Input: %b -> Output: %b, Valid: %b", data_in_2, encoded_out_2[0], valid_out_2);
    data_in_2 = 2'b10; #1;
    $display("Input: %b -> Output: %b, Valid: %b", data_in_2, encoded_out_2[0], valid_out_2);
    data_in_2 = 2'b11; #1;
    $display("Input: %b -> Output: %b, Valid: %b (invalid)", data_in_2, encoded_out_2[0], valid_out_2);
    
    // Test 4-to-2 encoder
    $display("--- Testing 4-to-2 Encoder ---");
    data_in_4 = 4'b0001; #1;
    $display("Input: %b -> Output: %b, Valid: %b", data_in_4, encoded_out_4[1:0], valid_out_4);
    data_in_4 = 4'b0100; #1;
    $display("Input: %b -> Output: %b, Valid: %b", data_in_4, encoded_out_4[1:0], valid_out_4);
    data_in_4 = 4'b1000; #1;
    $display("Input: %b -> Output: %b, Valid: %b", data_in_4, encoded_out_4[1:0], valid_out_4);
    
    // Test 8-to-3 encoder
    $display("--- Testing 8-to-3 Encoder ---");
    data_in_8 = 8'b00000001; #1;
    $display("Input: %b -> Output: %b, Valid: %b", data_in_8, encoded_out_8[2:0], valid_out_8);
    data_in_8 = 8'b00100000; #1;
    $display("Input: %b -> Output: %b, Valid: %b", data_in_8, encoded_out_8[2:0], valid_out_8);
    data_in_8 = 8'b10000000; #1;
    $display("Input: %b -> Output: %b, Valid: %b", data_in_8, encoded_out_8[2:0], valid_out_8);
    
    // Test 16-to-4 encoder
    $display("--- Testing 16-to-4 Encoder ---");
    data_in_16 = 16'b0000000000000001; #1;
    $display("Input: %b -> Output: %b, Valid: %b", data_in_16, encoded_out_16[3:0], valid_out_16);
    data_in_16 = 16'b0000001000000000; #1;
    $display("Input: %b -> Output: %b, Valid: %b", data_in_16, encoded_out_16[3:0], valid_out_16);
    data_in_16 = 16'b1000000000000000; #1;
    $display("Input: %b -> Output: %b, Valid: %b", data_in_16, encoded_out_16[3:0], valid_out_16);
    
    // Test invalid width encoder
    $display("--- Testing Invalid Width (3) Encoder ---");
    data_in_3 = 3'b001; #1;
    $display("Input: %b -> Output: %b, Valid: %b (should be invalid)", data_in_3, encoded_out_3, valid_out_3);
    data_in_3 = 3'b100; #1;
    $display("Input: %b -> Output: %b, Valid: %b (should be invalid)", data_in_3, encoded_out_3, valid_out_3);
    
    $display();
    $display("Each encoder was generated with different logic based on INPUT_WIDTH!");
    $display("Same module interface, completely different implementations!");
    
    #10;
    $finish;
  end

endmodule