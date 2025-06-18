// data_register_testbench.sv
module data_register_testbench;

    // Instantiate the examples module
    instantiation_examples inst_examples();
    
    initial begin
        // Set up VCD dumping
        $dumpfile("data_register_testbench.vcd");
        $dumpvars(0, data_register_testbench);
        
        $display();
        $display("=== Data Register Testbench ===");
        $display("This testbench demonstrates different module instantiation styles:");
        $display("- Named port connections (recommended)");
        $display("- Positional port connections (not recommended)");
        $display("- Parameter overrides");
        $display("- Mixed parameter and port connection styles");
        $display();
        
        // Wait for the examples to complete
        #1000;
        
        $display("=== Key Takeaways ===");
        $display();
        $display("BEST PRACTICES:");
        $display("✓ Always use named port connections");
        $display("✓ Use explicit parameter names when overriding");
        $display("✓ Group related signals logically");
        $display("✓ Use consistent indentation and formatting");
        $display();
        $display("AVOID:");
        $display("✗ Positional port connections (except for very simple modules)");
        $display("✗ Mixing named and positional styles");
        $display("✗ Long parameter lists without names");
        $display("✗ Inconsistent formatting");
        $display();
        $display("PARAMETER OVERRIDE EXAMPLES:");
        $display("- data_register #(.WIDTH(16)) inst_name (...)");
        $display("- data_register #(.WIDTH(8), .SYNC_RESET(1)) inst_name (...)");
        $display("- data_register inst_name (...) // Uses all defaults");
        $display();
        
        $finish;
    end

endmodule