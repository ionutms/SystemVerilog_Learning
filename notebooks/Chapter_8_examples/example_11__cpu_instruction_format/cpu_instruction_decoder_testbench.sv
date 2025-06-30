// cpu_instruction_decoder_testbench.sv
module cpu_instruction_testbench;

  // Instantiate the CPU instruction decoder design
  cpu_instruction_decoder CPU_DECODER_INSTANCE();

  // Additional testbench-specific instruction testing
  typedef struct packed {
    logic [3:0]  opcode;        // 4-bit operation code
    logic [7:0]  operand_addr;  // 8-bit operand address  
    logic [3:0]  register_sel;  // 4-bit register selection
  } instruction_packet_t;

  instruction_packet_t test_instruction_sequence[3];
  logic [15:0] raw_instruction_bits;

  initial begin
    // Configure wave dump
    $dumpfile("cpu_instruction_testbench.vcd");
    $dumpvars(0, cpu_instruction_testbench);
    
    #1; // Wait for design to complete
    
    $display("=== Testbench: Additional Instruction Tests ===");
    $display();

    // Create test sequence with edge cases
    test_instruction_sequence[0] = {4'b0000, 8'hFF, 4'hF}; // All max values
    test_instruction_sequence[1] = {4'b1010, 8'h55, 4'h5}; // Pattern test
    test_instruction_sequence[2] = {4'b0101, 8'hAA, 4'hA}; // Alternating bits

    // Test instruction bit manipulation
    for (int test_index = 0; test_index < 3; test_index++) begin
      raw_instruction_bits = test_instruction_sequence[test_index];
      
      $display("Test %0d - Raw bits: 0b%016b", test_index, 
               raw_instruction_bits);
      $display("  Extracted Opcode: 0x%01X", 
               raw_instruction_bits[15:12]);
      $display("  Extracted Operand: 0x%02X", 
               raw_instruction_bits[11:4]);  
      $display("  Extracted Register: 0x%01X", 
               raw_instruction_bits[3:0]);
      $display();
    end

    // Demonstrate bit field access vs full word access
    test_instruction_sequence[0] = {4'h3, 8'h7F, 4'h8};
    $display("Field Access Demo:");
    $display("  Full instruction: 0x%04X", test_instruction_sequence[0]);
    $display("  Opcode field: %0d", test_instruction_sequence[0].opcode);
    $display("  Address field: %0d", 
             test_instruction_sequence[0].operand_addr);
    $display("  Register field: %0d", 
             test_instruction_sequence[0].register_sel);
    $display();

    $display("=== Testbench Complete ===");
    $display();
  end

endmodule