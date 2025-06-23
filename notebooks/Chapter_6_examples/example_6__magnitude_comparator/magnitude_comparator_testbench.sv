// magnitude_comparator_testbench.sv
module comparator_testbench;

    // Test parameters
    parameter WIDTH = 8;
    
    // Test signals
    logic [WIDTH-1:0] test_a;
    logic [WIDTH-1:0] test_b;
    logic eq_out, gt_out, lt_out;
    
    // Test counters
    int test_count = 0;
    int pass_count = 0;
    int fail_count = 0;

    // Instantiate the design under test
    magnitude_comparator #(.WIDTH(WIDTH)) DUT (
        .a_in(test_a),
        .b_in(test_b),
        .equal(eq_out),
        .greater(gt_out),
        .less(lt_out)
    );

    initial begin
        // Setup waveform dumping
        $dumpfile("comparator_testbench.vcd");
        $dumpvars(0, comparator_testbench);
        
        $display("=== %0d-bit Magnitude Comparator Test ===", WIDTH);
        $display("Testing A vs B with Equal, Greater, Less outputs");
        $display();
        
        // Test 1: Equal values
        $display("Test 1: Equal Values");
        test_equal_values();
        $display();
        
        // Test 2: A greater than B
        $display("Test 2: A > B Cases");
        test_greater_than();
        $display();
        
        // Test 3: A less than B
        $display("Test 3: A < B Cases");
        test_less_than();
        $display();
        
        // Test 4: Edge cases
        $display("Test 4: Edge Cases");
        test_edge_cases();
        $display();
        
        // Test 5: Random comprehensive test
        $display("Test 5: Random Comprehensive Test");
        test_random_values();
        $display();
        
        // Final summary
        $display("=== Test Summary ===");
        $display("Total tests: %0d", test_count);
        $display("Passed: %0d", pass_count);
        $display("Failed: %0d", fail_count);
        if (fail_count == 0) begin
            $display("ALL TESTS PASSED!");
        end else begin
            $display("%0d TESTS FAILED", fail_count);
        end
        
        $finish;
    end

    // Task to test equal values
    task automatic test_equal_values();
        logic [WIDTH-1:0] test_values [5];
        
        // Initialize test values
        test_values[0] = 0;
        test_values[1] = 1;
        test_values[2] = 15;
        test_values[3] = 128;
        test_values[4] = 255;
        
        foreach (test_values[i]) begin
            test_a = test_values[i];
            test_b = test_values[i];
            #10;
            verify_result(1, 0, 0, "Equal");
        end
    endtask

    // Task to test A > B cases
    task automatic test_greater_than();
        // Test arrays for A > B cases
        logic [WIDTH-1:0] test_a_vals [5] = '{10, 255, 128, 100, 200};
        logic [WIDTH-1:0] test_b_vals [5] = '{5, 254, 127, 50, 199};
        
        for (int i = 0; i < 5; i++) begin
            test_a = test_a_vals[i];
            test_b = test_b_vals[i];
            #10;
            verify_result(0, 1, 0, "Greater");
        end
    endtask

    // Task to test A < B cases
    task automatic test_less_than();
        // Test arrays for A < B cases
        logic [WIDTH-1:0] test_a_vals [5] = '{5, 0, 127, 50, 199};
        logic [WIDTH-1:0] test_b_vals [5] = '{10, 1, 128, 100, 200};
        
        for (int i = 0; i < 5; i++) begin
            test_a = test_a_vals[i];
            test_b = test_b_vals[i];
            #10;
            verify_result(0, 0, 1, "Less");
        end
    endtask

    // Task to test edge cases
    task automatic test_edge_cases();
        // Minimum values
        test_a = 0; test_b = 0;
        #10; verify_result(1, 0, 0, "Min Equal");
        
        // Maximum values
        test_a = {WIDTH{1'b1}}; test_b = {WIDTH{1'b1}};
        #10; verify_result(1, 0, 0, "Max Equal");
        
        // Min vs Max
        test_a = 0; test_b = {WIDTH{1'b1}};
        #10; verify_result(0, 0, 1, "Min < Max");
        
        // Max vs Min
        test_a = {WIDTH{1'b1}}; test_b = 0;
        #10; verify_result(0, 1, 0, "Max > Min");
        
        // Adjacent values
        test_a = 100; test_b = 101;
        #10; verify_result(0, 0, 1, "Adjacent Less");
        
        test_a = 101; test_b = 100;
        #10; verify_result(0, 1, 0, "Adjacent Greater");
    endtask

    // Task for random testing
    task automatic test_random_values();
        logic [31:0] rand_val;
        
        for (int i = 0; i < 20; i++) begin
            // Generate random values with proper bit width
            rand_val = $random();
            test_a = rand_val[WIDTH-1:0];
            rand_val = $random();
            test_b = rand_val[WIDTH-1:0];
            #10;
            
            // Determine expected result
            if (test_a == test_b)
                verify_result(1, 0, 0, "Random Equal");
            else if (test_a > test_b)
                verify_result(0, 1, 0, "Random Greater");
            else
                verify_result(0, 0, 1, "Random Less");
        end
    endtask

    // Verification task
    task automatic verify_result(logic exp_eq, logic exp_gt, logic exp_lt, string test_name);
        test_count++;
        
        if (eq_out == exp_eq && gt_out == exp_gt && lt_out == exp_lt) begin
            pass_count++;
            $display(
                "%s: A=%0d, B=%0d -> EQ=%b GT=%b LT=%b", 
                test_name, test_a, test_b, eq_out, gt_out, lt_out);
        end else begin
            fail_count++;
            $display(
                "%s: A=%0d, B=%0d -> Expected: EQ=%b GT=%b LT=%b, Got: EQ=%b GT=%b LT=%b", 
                test_name, test_a, test_b, exp_eq, exp_gt, exp_lt, eq_out, gt_out, lt_out);
        end
    endtask

    // Monitor for timing analysis
    always @(test_a or test_b) begin
        #1; // Small delay to let outputs settle
        // Check that exactly one output is active
        if ((eq_out + gt_out + lt_out) != 1) begin
            $display(
                "WARNING: Invalid output state at A=%0d, B=%0d",
                test_a, test_b);
        end
    end

    // Performance analysis
    initial begin
        #1000; // Wait for all tests to complete
        $display();
        $display("=== Performance Analysis ===");
        $display("Comparator width: %0d bits", WIDTH);
        $display("Maximum input value: %0d", (2**WIDTH)-1);
        $display("Total possible comparisons: %0d", (2**WIDTH) * (2**WIDTH));
        $display("Tests performed: %0d (%.2f%% coverage)", 
                test_count,
                (real'(test_count) / real'((2**WIDTH) * (2**WIDTH))) * 100.0);
    end

endmodule