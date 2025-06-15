// comparator_testbench.sv
module comparator_testbench;  // Testbench module
    
    // Testbench signals
    logic [7:0] a, b;
    logic gt, eq, lt;
    
    // Instantiate design under test
    comparator DUT (
        .a(a),
        .b(b),
        .gt(gt),
        .eq(eq),
        .lt(lt)
    );

    initial begin
        // Dump waves
        $dumpfile("comparator_testbench.vcd");       // Specify the VCD file
        $dumpvars(0, comparator_testbench);          // Dump all variables in the test module
        
        $display();
        $display("Hello from testbench!");
        $display("Starting Comparator Tests");
        $display("====================");
        $display();

        // Test case 1: a > b
        a = 8'h50; b = 8'h30;
        #1;  // Wait for combinational logic to settle
        $display("Test 1: a=%0d, b=%0d -> gt=%b, eq=%b, lt=%b", a, b, gt, eq, lt);
        assert (gt == 1'b1 && eq == 1'b0 && lt == 1'b0) 
            else $error("Test 1 failed: Expected gt=1, eq=0, lt=0");

        // Test case 2: a == b
        a = 8'h42; b = 8'h42;
        #1;
        $display("Test 2: a=%0d, b=%0d -> gt=%b, eq=%b, lt=%b", a, b, gt, eq, lt);
        assert (gt == 1'b0 && eq == 1'b1 && lt == 1'b0) 
            else $error("Test 2 failed: Expected gt=0, eq=1, lt=0");

        // Test case 3: a < b
        a = 8'h10; b = 8'h60;
        #1;
        $display("Test 3: a=%0d, b=%0d -> gt=%b, eq=%b, lt=%b", a, b, gt, eq, lt);
        assert (gt == 1'b0 && eq == 1'b0 && lt == 1'b1) 
            else $error("Test 3 failed: Expected gt=0, eq=0, lt=1");

        // Test case 4: Edge case - maximum values
        a = 8'hFF; b = 8'hFF;
        #1;
        $display("Test 4: a=%0d, b=%0d -> gt=%b, eq=%b, lt=%b", a, b, gt, eq, lt);
        assert (gt == 1'b0 && eq == 1'b1 && lt == 1'b0) 
            else $error("Test 4 failed: Expected gt=0, eq=1, lt=0");

        // Test case 5: Edge case - minimum values
        a = 8'h00; b = 8'h00;
        #1;
        $display("Test 5: a=%0d, b=%0d -> gt=%b, eq=%b, lt=%b", a, b, gt, eq, lt);
        assert (gt == 1'b0 && eq == 1'b1 && lt == 1'b0) 
            else $error("Test 5 failed: Expected gt=0, eq=1, lt=0");

        // Test case 6: One maximum, one minimum
        a = 8'hFF; b = 8'h00;
        #1;
        $display("Test 6: a=%0d, b=%0d -> gt=%b, eq=%b, lt=%b", a, b, gt, eq, lt);
        assert (gt == 1'b1 && eq == 1'b0 && lt == 1'b0) 
            else $error("Test 6 failed: Expected gt=1, eq=0, lt=0");

        // Test case 7: One minimum, one maximum
        a = 8'h00; b = 8'hFF;
        #1;
        $display("Test 7: a=%0d, b=%0d -> gt=%b, eq=%b, lt=%b", a, b, gt, eq, lt);
        assert (gt == 1'b0 && eq == 1'b0 && lt == 1'b1) 
            else $error("Test 7 failed: Expected gt=0, eq=0, lt=1");

        $display();
        $display("All tests completed!");
        $display("====================");
        $display();
        
        $finish;  // End simulation
    end

endmodule