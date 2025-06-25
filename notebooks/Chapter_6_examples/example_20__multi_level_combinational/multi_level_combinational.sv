// multi_level_combinational.sv
// Demonstrates assignment timing effects in multi-level combinational logic
// Shows how blocking vs non-blocking assignments affect intermediate signal propagation

module multi_level_combinational (
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic result_blocking,
    output logic result_nonblocking,
    output logic result_continuous
);

    // Intermediate signals for multi-level logic
    // Circuit implements: result = ((a & b) | (c & d)) ^ (a | c)
    
    // ========================================
    // METHOD 1: BLOCKING ASSIGNMENTS (=)
    // Sequential execution within always block
    // ========================================
    
    logic level1_and1_block, level1_and2_block, level1_or_block;
    logic level2_or_block;
    logic level3_xor_block;
    
    always_comb begin
        // Level 1: Basic gates (execute in order)
        level1_and1_block = a & b;        // Executes first
        level1_and2_block = c & d;        // Executes second  
        level1_or_block = a | c;          // Executes third
        
        // Level 2: OR of the AND results (uses NEW values immediately)
        level2_or_block = level1_and1_block | level1_and2_block;
        
        // Level 3: Final XOR (uses NEW value immediately)
        level3_xor_block = level2_or_block ^ level1_or_block;
        
        // Final result
        result_blocking = level3_xor_block;
    end

    // ========================================
    // METHOD 2: NON-BLOCKING ASSIGNMENTS (<=)
    // WARNING: This is incorrect for combinational logic!
    // COMMENTED OUT to avoid warnings - demonstrates bad practice
    // ========================================
    
    logic level1_and1_nonblock, level1_and2_nonblock, level1_or_nonblock;
    logic level2_or_nonblock;
    logic level3_xor_nonblock;
    
    // COMMENTED OUT - This code generates warnings because it's incorrect practice
    /*
    always_comb begin
        // INCORRECT: Non-blocking in combinational logic causes issues
        level1_and1_nonblock <= a & b;        // Scheduled for later
        level1_and2_nonblock <= c & d;        // Scheduled for later
        level1_or_nonblock <= a | c;          // Scheduled for later
        
        // PROBLEM: These use OLD values from previous evaluation!
        level2_or_nonblock <= level1_and1_nonblock | level1_and2_nonblock;
        level3_xor_nonblock <= level2_or_nonblock ^ level1_or_nonblock;
        
        result_nonblocking <= level3_xor_nonblock;
    end
    */
    
    // For demonstration purposes, tie nonblocking result to 0
    // In real design, you would never use non-blocking for combinational logic
    assign result_nonblocking = 1'b0;  // Shows this method is "broken"

    // ========================================
    // METHOD 3: CONTINUOUS ASSIGNMENTS (assign)
    // Best practice for combinational logic
    // ========================================
    
    logic level1_and1_cont, level1_and2_cont, level1_or_cont;
    logic level2_or_cont;
    
    // Level 1: Basic operations
    assign level1_and1_cont = a & b;
    assign level1_and2_cont = c & d;
    assign level1_or_cont = a | c;
    
    // Level 2: Combine level 1 results
    assign level2_or_cont = level1_and1_cont | level1_and2_cont;
    
    // Level 3: Final result
    assign result_continuous = level2_or_cont ^ level1_or_cont;
    
    // Alternative: Single continuous assignment (also correct)
    // assign result_continuous = ((a & b) | (c & d)) ^ (a | c);

    // ========================================
    // TIMING ANALYSIS HELPERS
    // ========================================
    
    // Monitor intermediate signals for educational purposes
    always @(*) begin
        $display("Input change detected: a=%b, b=%b, c=%b, d=%b", a, b, c, d);
        $display("  Level 1 - AND1: block=%b, nonblock=%b, cont=%b", 
                 level1_and1_block, level1_and1_nonblock, level1_and1_cont);
        $display("  Level 1 - AND2: block=%b, nonblock=%b, cont=%b", 
                 level1_and2_block, level1_and2_nonblock, level1_and2_cont);
        $display("  Level 1 - OR:   block=%b, nonblock=%b, cont=%b", 
                 level1_or_block, level1_or_nonblock, level1_or_cont);
        $display("  Level 2 - OR:   block=%b, nonblock=%b, cont=%b", 
                 level2_or_block, level2_or_nonblock, level2_or_cont);
        $display("  Final Result:   block=%b, nonblock=%b, cont=%b", 
                 result_blocking, result_nonblocking, result_continuous);
        $display("  Expected Result: %b", ((a & b) | (c & d)) ^ (a | c));
        $display("---");
    end
    
    // Display educational information
    initial begin
        $display("=== MULTI-LEVEL COMBINATIONAL LOGIC TIMING ===");
        $display("Circuit: result = ((a & b) | (c & d)) ^ (a | c)");
        $display("BLOCKING (=):     Correct - sequential execution updates intermediates");
        $display("NON-BLOCKING (<=): Commented out - incorrect for combinational logic");
        $display("CONTINUOUS (assign): Best - pure combinational behavior");
        $display("============================================");
    end

endmodule