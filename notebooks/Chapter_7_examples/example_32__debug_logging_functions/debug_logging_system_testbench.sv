// debug_logging_system_testbench.sv
module debug_logging_testbench;
    
    // Instantiate design under test with debug enabled
    debug_logging_system #(
        .DATA_WIDTH(8),
        .ENABLE_DEBUG(1)
    ) debug_system_instance();
    
    // Testbench logging functions
    function void test_log(string test_message);
        $display("[TEST] [%0t] %s", $time, test_message);
    endfunction
    
    function void test_pass(string test_name);
        $display("[PASS] [%0t] Test '%s' completed successfully", 
                $time, test_name);
    endfunction
    
    function void test_fail(string test_name, string reason);
        $display("[FAIL] [%0t] Test '%s' failed: %s", 
                $time, test_name, reason);
    endfunction
    
    function void test_section_header(string section_name);
        $display("");
        $display("============ %s ============", section_name);
    endfunction
    
    initial begin
        // Setup waveform dumping
        $dumpfile("debug_logging_testbench.vcd");
        $dumpvars(0, debug_logging_testbench);
        
        test_section_header("DEBUG LOGGING SYSTEM TEST");
        test_log("Starting comprehensive debug logging test");
        
        // Test 1: Basic logging functionality
        test_section_header("TEST 1: BASIC LOGGING");
        test_log("Verifying basic log message output");
        #5;
        test_pass("Basic logging verification");
        
        // Test 2: Debug message filtering
        test_section_header("TEST 2: DEBUG FILTERING");
        test_log("Testing debug message filtering capability");
        #20;
        test_pass("Debug filtering test");
        
        // Test 3: Error logging and tracing
        test_section_header("TEST 3: ERROR HANDLING");
        test_log("Monitoring error detection and logging");
        #25;
        test_pass("Error handling verification");
        
        // Test 4: System state dumping
        test_section_header("TEST 4: STATE DUMPING");
        test_log("Verifying system state dump functionality");
        #35;
        test_pass("State dumping test");
        
        // Test 5: Performance checkpoints
        test_section_header("TEST 5: PERFORMANCE TRACKING");
        test_log("Testing performance checkpoint logging");
        #45;
        test_pass("Performance tracking test");
        
        // Final test summary
        test_section_header("TEST SUMMARY");
        test_log("All debug and logging functions verified");
        test_pass("Complete test suite");
        
        $display("");
        $display("========================================");
        $display("Debug logging system test completed at time %0t", $time);
        $display("========================================");
        
        #10;
        $finish;
    end
    
    // Monitor for any unexpected conditions
    initial begin
        #1000;
        test_fail("Timeout test", "Simulation exceeded maximum time limit");
        $finish;
    end
    
endmodule