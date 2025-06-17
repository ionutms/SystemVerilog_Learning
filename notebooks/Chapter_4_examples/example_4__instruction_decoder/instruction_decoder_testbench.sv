// instruction_decoder_testbench.sv
module instruction_decoder_testbench;
    // Testbench signals
    logic [7:0] instruction;
    logic [2:0] op_type;
    
    // Instantiate the design under test
    instruction_decoder DUT (
        .instruction(instruction),
        .op_type(op_type)
    );
    
    // Test stimulus
    initial begin
        // Dump waves
        $dumpfile("instruction_decoder_testbench.vcd");
        $dumpvars(0, instruction_decoder_testbench);
        
        $display("Starting Instruction Decoder Test");
        $display("=====================================");
        $display();
        
        // Test Load instructions (000?????)
        instruction = 8'b00000000; #1;
        $display("Instruction: %b, Op Type: %b (Expected: 001 - Load)", instruction, op_type);
        instruction = 8'b00011111; #1;
        $display("Instruction: %b, Op Type: %b (Expected: 001 - Load)", instruction, op_type);
        
        // Test Store instructions (001?????)
        instruction = 8'b00100000; #1;
        $display("Instruction: %b, Op Type: %b (Expected: 010 - Store)", instruction, op_type);
        instruction = 8'b00111111; #1;
        $display("Instruction: %b, Op Type: %b (Expected: 010 - Store)", instruction, op_type);
        
        // Test Arithmetic instructions (010?????)
        instruction = 8'b01000000; #1;
        $display("Instruction: %b, Op Type: %b (Expected: 011 - Arithmetic)", instruction, op_type);
        instruction = 8'b01011111; #1;
        $display("Instruction: %b, Op Type: %b (Expected: 011 - Arithmetic)", instruction, op_type);
        
        // Test Logic instructions (011?????)
        instruction = 8'b01100000; #1;
        $display("Instruction: %b, Op Type: %b (Expected: 100 - Logic)", instruction, op_type);
        instruction = 8'b01111111; #1;
        $display("Instruction: %b, Op Type: %b (Expected: 100 - Logic)", instruction, op_type);
        
        // Test Branch instructions (1???????)
        instruction = 8'b10000000; #1;
        $display("Instruction: %b, Op Type: %b (Expected: 101 - Branch)", instruction, op_type);
        instruction = 8'b11111111; #1;
        $display("Instruction: %b, Op Type: %b (Expected: 101 - Branch)", instruction, op_type);
        instruction = 8'b10101010; #1;
        $display("Instruction: %b, Op Type: %b (Expected: 101 - Branch)", instruction, op_type);
        
        $display();
        $display("Test completed!");
        $display("=====================================");
        
        $finish;
    end

endmodule