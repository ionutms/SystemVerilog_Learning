// multi_level_combinational_testbench.sv
module multilevel_comb_testbench;

    // Testbench signals
    logic a, b, c, d;
    logic result_blocking;
    logic result_nonblocking; 
    logic result_continuous;
    
    // Expected result calculation
    logic expected_result;
    assign expected_result = ((a & b) | (c & d)) ^ (a | c);
    
    // Test vectors - all 16 possible combinations
    logic [3:0] test_vectors [0:15];
    
    // Instantiate the multi-level combinational logic
    multi_level_combinational MULTILEVEL_INSTANCE (
        .a(a),
        .b(b), 
        .c(c),
        .d(d),
        .result_blocking(result_blocking),
        .result_nonblocking(result_nonblocking),
        .result_continuous(result_continuous)
    );
    
    // Initialize test vectors
    initial begin
        for (int i = 0; i < 16; i++) begin
            test_vectors[i] = i[3:0];
        end
    end
    
    // Test sequence
    initial begin
        // Dump waves for analysis
        $dumpfile("multilevel_comb_testbench.vcd");
        $dumpvars(0, multilevel_comb_testbench);
        
        $display("\n=== Multi-Level Combinational Logic Test ===");
        $display("Circuit: result = ((a & b) | (c & d)) ^ (a | c)");
        $display("Testing all 16 input combinations...\n");
        
        $display("Inputs | Expected | Blocking | NonBlock | Continuous | Status");
        $display("-------|----------|----------|----------|------------|--------");
        
        // Test all combinations
        for (int i = 0; i < 16; i++) begin
            // Apply test vector
            {a, b, c, d} = test_vectors[i];
            
            // Small delay to let combinational logic settle
            #1;
            
            // Check results and display
            $display("%b%b%b%b   |    %b     |    %b     |    %b     |     %b      | %s %s %s",
                     a, b, c, d, expected_result, 
                     result_blocking, result_nonblocking, result_continuous,
                     (result_blocking == expected_result) ? "B_OK" : "B_ERR",
                     (result_nonblocking == expected_result) ? "N_OK" : "N_ERR",
                     (result_continuous == expected_result) ? "C_OK" : "C_ERR");
            
            // Small delay between tests
            #5;
        end
        
        $display("\n--- Detailed Analysis ---");
        
        // Test specific cases to show timing effects
        $display("\nTesting timing behavior with specific transitions:");
        
        // Start with all zeros
        {a, b, c, d} = 4'b0000;
        #1;
        $display("Initial: abcd=0000 -> Block=%b, NonBlock=%b, Cont=%b (Expected=%b)", 
                 result_blocking, result_nonblocking, result_continuous, expected_result);
        
        // Change to case that should produce different result
        {a, b, c, d} = 4'b1100;  // (1&1)|(0&0) ^ (1|0) = 1|0 ^ 1 = 1^1 = 0
        #1;
        $display("After 1100: Block=%b, NonBlock=%b, Cont=%b (Expected=%b)", 
                 result_blocking, result_nonblocking, result_continuous, expected_result);
        
        // Another transition
        {a, b, c, d} = 4'b1010;  // (1&0)|(1&0) ^ (1|1) = 0|0 ^ 1 = 0^1 = 1
        #1; 
        $display("After 1010: Block=%b, NonBlock=%b, Cont=%b (Expected=%b)", 
                 result_blocking, result_nonblocking, result_continuous, expected_result);
        
        $display("\n--- Summary of Assignment Methods ---");
        
        $display("\n1. BLOCKING ASSIGNMENTS (=) in always_comb:");
        $display("   CORRECT for combinational logic"); 
        $display("   Sequential execution ensures intermediate values update first");
        $display("   Each level uses updated values from previous level");
        $display("   Behaves like real hardware propagation delays");
        
        $display("\n2. NON-BLOCKING ASSIGNMENTS (<=) in always_comb:");
        $display("   INCORRECT for combinational logic");
        $display("   Uses stale values from previous evaluation cycle");
        $display("   Can cause incorrect results and race conditions");
        $display("   Creates artificial delay that doesn't match hardware");
        
        $display("\n3. CONTINUOUS ASSIGNMENTS (assign):");
        $display("   BEST PRACTICE for combinational logic");
        $display("   Pure combinational behavior - no procedural timing"); 
        $display("   Clear, readable, and matches hardware exactly");
        $display("   Automatic sensitivity to all inputs");
        
        $display("\n--- Key Insights ---");
        $display("Multi-level combinational logic requires proper signal propagation");
        $display("Blocking assignments (=) work because they execute sequentially");
        $display("Non-blocking (<=) fails because it uses old intermediate values"); 
        $display("Continuous assignments (assign) are the gold standard");
        $display("Always use assign for pure combinational logic when possible");
        
        $display("\n=== Test Complete ===");
        $display("Check VCD for detailed signal transitions and timing");
        $finish;
    end

endmodule