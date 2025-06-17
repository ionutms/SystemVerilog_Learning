// arithmetic_testbench.sv
module arithmetic_testbench;
    // Instantiate the design under test
    arithmetic DESIGN_INSTANCE();
    
    // Test control
    initial begin
        // Enable VCD dumping
        $dumpfile("arithmetic_testbench.vcd");
        $dumpvars(0, arithmetic_testbench);
        
        // Wait for the arithmetic module to complete
        #20;
        
        // Finish simulation
        $finish;
    end
endmodule