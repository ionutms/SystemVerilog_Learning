// cpu_instruction_decoder.sv
module cpu_instruction_decoder ();

  // Define packed structure for CPU instruction format (16-bit instruction)
  typedef struct packed {
    logic [3:0]  opcode;        // 4-bit operation code
    logic [7:0]  operand_addr;  // 8-bit operand address
    logic [3:0]  register_sel;  // 4-bit register selection
  } cpu_instruction_format_t;

  // Define opcode constants for readability
  typedef enum logic [3:0] {
    OP_NOP  = 4'b0000,  // No operation
    OP_LOAD = 4'b0001,  // Load from memory
    OP_STORE= 4'b0010,  // Store to memory  
    OP_ADD  = 4'b0011,  // Addition
    OP_SUB  = 4'b0100,  // Subtraction
    OP_JUMP = 4'b0101,  // Jump instruction
    OP_HALT = 4'b1111   // Halt processor
  } opcode_enum_t;

  // Create instruction instances
  cpu_instruction_format_t current_instruction;
  cpu_instruction_format_t sample_instructions[5];

  initial begin
    $display("=== CPU Instruction Format Demonstration ===");
    $display();

    // Initialize sample instructions
    sample_instructions[0] = {OP_LOAD,  8'h42, 4'h1};  // Load from addr 0x42
    sample_instructions[1] = {OP_ADD,   8'h00, 4'h2};  // Add to register 2
    sample_instructions[2] = {OP_STORE, 8'h50, 4'h2};  // Store reg 2 to 0x50
    sample_instructions[3] = {OP_JUMP,  8'h10, 4'h0};  // Jump to address 0x10
    sample_instructions[4] = {OP_HALT,  8'h00, 4'h0};  // Halt processor

    // Display instruction format information
    $display("Instruction Format (16-bit total):");
    $display("  [15:12] Opcode     - 4 bits");
    $display("  [11:4]  Operand    - 8 bits"); 
    $display("  [3:0]   Register   - 4 bits");
    $display();

    // Process and display each instruction
    for (int instruction_index = 0; instruction_index < 5; 
         instruction_index++) begin
      current_instruction = sample_instructions[instruction_index];
      
      $display("Instruction %0d: 0x%04X", instruction_index,
               current_instruction);
      $display("  Opcode: %s (0x%01X)", 
               get_opcode_name(current_instruction.opcode),
               current_instruction.opcode);
      $display("  Operand Address: 0x%02X", 
               current_instruction.operand_addr);
      $display("  Register Select: R%0d", 
               current_instruction.register_sel);
      $display();
    end

    $display("=== End of CPU Instruction Demo ===");
  end

  // Function to convert opcode to readable string
  function string get_opcode_name(logic [3:0] opcode_value);
    case (opcode_value)
      OP_NOP:   return "NOP";
      OP_LOAD:  return "LOAD";
      OP_STORE: return "STORE";
      OP_ADD:   return "ADD";
      OP_SUB:   return "SUB";
      OP_JUMP:  return "JUMP";
      OP_HALT:  return "HALT";
      default:  return "UNKNOWN";
    endcase
  endfunction

endmodule