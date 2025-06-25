// multi_stage_pipeline_testbench.sv
module pipeline_testbench;

    // Testbench signals
    logic        clk;
    logic        reset_n;
    logic        enable;
    logic [7:0]  data_in_a;
    logic [7:0]  data_in_b;
    logic [7:0]  data_in_c;
    logic [15:0] result_correct;
    logic [15:0] result_incorrect;
    logic        valid_out;
    
    // Test data
    logic [7:0] test_a [0:4] = '{5, 10, 3, 8, 12};
    logic [7:0] test_b [0:4] = '{3, 2,  7, 4, 1};
    logic [7:0] test_c [0:4] = '{2, 4,  3, 5, 6};
    
    // Expected results: (a + b) * c
    logic [15:0] expected [0:4] = '{16, 48, 30, 60, 78}; // (5+3)*2, (10+2)*4, (3+7)*3, (8+4)*5, (12+1)*6
    
    int test_index = 0;
    int cycle_count = 0;
    
    // Instantiate the multi-stage pipeline
    multi_stage_pipeline PIPELINE_INSTANCE (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .data_in_a(data_in_a),
        .data_in_b(data_in_b),
        .data_in_c(data_in_c),
        .result_correct(result_correct),
        .result_incorrect(result_incorrect),
        .valid_out(valid_out)
    );
    
    // Clock generation - 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test sequence
    initial begin
        // Dump waves for analysis
        $dumpfile("pipeline_testbench.vcd");
        $dumpvars(0, pipeline_testbench);
        
        // Initialize
        reset_n = 0;
        enable = 0;
        data_in_a = 0;
        data_in_b = 0;
        data_in_c = 0;
        
        $display("\n=== Multi-Stage Pipeline Test ===");
        $display("Pipeline: INPUT -> ADD -> MULTIPLY -> OUTPUT");
        $display("Operation: result = (a + b) * c");
        
        // Reset
        repeat(2) @(posedge clk);
        reset_n = 1;
        enable = 1;
        
        $display("\n--- Feeding Test Data ---");
        
        // Feed test data into pipeline
        for (int i = 0; i < 5; i++) begin
            @(posedge clk);
            data_in_a = test_a[i];
            data_in_b = test_b[i];
            data_in_c = test_c[i];
            cycle_count++;
            
            $display("Cycle %0d: Input a=%0d, b=%0d, c=%0d (expected result = %0d)", 
                     cycle_count, data_in_a, data_in_b, data_in_c, expected[i]);
            $display("         Immediate results: correct=%0d, incorrect=%0d", 
                     result_correct, result_incorrect);
        end
        
        // Continue running to see pipeline results
        $display("\n--- Pipeline Results ---");
        for (int i = 0; i < 8; i++) begin
            @(posedge clk);
            cycle_count++;
            
            if (valid_out) begin
                $display("Cycle %0d: VALID OUTPUT -> correct=%0d, incorrect=%0d", 
                         cycle_count, result_correct, result_incorrect);
                
                // Check if correct result matches expected
                if (test_index < 5 && result_correct == expected[test_index]) begin
                    $display("         ✓ Correct pipeline result matches expected %0d", expected[test_index]);
                end else if (test_index < 5) begin
                    $display("         ✗ Correct pipeline result %0d != expected %0d", result_correct, expected[test_index]);
                end
                test_index++;
            end else begin
                $display("Cycle %0d: Pipeline filling... correct=%0d, incorrect=%0d", 
                         cycle_count, result_correct, result_incorrect);
            end
        end
        
        $display("\n--- Analysis Summary ---");
        $display("INCORRECT Implementation (blocking =):");
        $display("- All computation happens in same clock cycle");
        $display("- Creates combinational path through entire pipeline");
        $display("- No pipeline latency - result appears immediately");
        $display("- Defeats the purpose of pipelining");
        
        $display("\nCORRECT Implementation (non-blocking <=):");
        $display("- Each stage operates independently");
        $display("- Takes 4 clock cycles for first result (pipeline latency)");
        $display("- Subsequent results appear every clock cycle (throughput)");
        $display("- Proper pipeline behavior for high-performance designs");
        
        $display("\n=== Test Complete ===");
        $finish;
    end
    
    // Monitor pipeline stages for educational purposes
    always @(posedge clk) begin
        if (reset_n && enable) begin
            $display("Stage Values: S1_a=%0d S1_b=%0d S1_c=%0d | S2_sum=%0d S2_c=%0d | S3_prod=%0d", 
                     PIPELINE_INSTANCE.stage1_a, PIPELINE_INSTANCE.stage1_b, PIPELINE_INSTANCE.stage1_c,
                     PIPELINE_INSTANCE.stage2_sum, PIPELINE_INSTANCE.stage2_c, 
                     PIPELINE_INSTANCE.stage3_product);
        end
    end

endmodule