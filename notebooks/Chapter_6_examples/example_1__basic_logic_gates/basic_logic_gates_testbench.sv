// basic_logic_gates_testbench.sv
module logic_gates_testbench;

    // Test signals
    logic test_a, test_b;
    logic result_and, result_or, result_xor, result_nand;

    // Instantiate the design under test
    basic_logic_gates DUT (
        .a(test_a),
        .b(test_b),
        .and_out(result_and),
        .or_out(result_or),
        .xor_out(result_xor),
        .nand_out(result_nand)
    );

    initial begin
        // Setup waveform dumping
        $dumpfile("basic_logic_gates_testbench.vcd");
        $dumpvars(0, basic_logic_gates_testbench);
        
        $display("=== Basic Logic Gates Test ===");
        $display();
        
        // Test all input combinations (truth table)
        $display("Testing all 2-input combinations:");
        
        // Test case 1: 00
        test_a = 1'b0; test_b = 1'b0;
        #10;
        
        // Test case 2: 01  
        test_a = 1'b0; test_b = 1'b1;
        #10;
        
        // Test case 3: 10
        test_a = 1'b1; test_b = 1'b0;
        #10;
        
        // Test case 4: 11
        test_a = 1'b1; test_b = 1'b1;
        #10;
        
        $display();
        $display("=== Truth Table Complete ===");
        $display("AND: outputs 1 only when both inputs are 1");
        $display("OR:  outputs 1 when at least one input is 1");
        $display("XOR: outputs 1 when inputs are different");
        $display("NAND: outputs 0 only when both inputs are 1 (inverted AND)");
        
        $finish;
    end

endmodule