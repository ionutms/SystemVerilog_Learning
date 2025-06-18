// port_direction_testbench.sv
module port_direction_testbench;

    // Instantiate the port connection examples
    port_connection_styles connection_examples_inst();
    
    initial begin
        $dumpfile("port_direction_testbench.vcd");
        $dumpvars(0, port_direction_testbench);
        
        $display();
        $display("================================================================================");
        $display("                        PORT DIRECTION TESTBENCH");
        $display("================================================================================");
        $display();
        $display("This comprehensive testbench demonstrates SystemVerilog port direction types:");
        $display();
        $display("PORT TYPES COVERED:");
        $display("📥 INPUT  - Data flows INTO the module (read-only internally)");
        $display("📤 OUTPUT - Data flows OUT OF the module (write-only internally)");
        $display("🔄 INOUT  - Bidirectional data flow (tri-state logic required)");
        $display("🔗 REF    - References to external signals (testbench use)");
        $display();
        $display("EXAMPLES INCLUDED:");
        $display("• Multiple data widths (8-bit and 16-bit)");
        $display("• Different address widths");
        $display("• Tri-state bus arbitration");
        $display("• Reference port monitoring");
        $display("• Best practices and common mistakes");
        $display();
        $display("================================================================================");
        $display();
        
        // Wait for all examples to complete
        #3000;
        
        $display();
        $display("================================================================================");
        $display("                    PORT DIRECTION BEST PRACTICES SUMMARY");
        $display("================================================================================");
        $display();
        
        $display("🔹 INPUT PORTS:");
        $display("   ✅ GOOD:");
        $display("      • Use for clocks, resets, enables, control signals");
        $display("      • Use for data inputs and addresses");
        $display("      • Can be read anywhere in the module");
        $display("      • Connect from external signals or other module outputs");
        $display();
        $display("   ❌ AVOID:");
        $display("      • Never assign values to input ports internally");
        $display("      • Don't leave input ports unconnected (use explicit ties)");
        $display();
        
        $display("🔹 OUTPUT PORTS:");
        $display("   ✅ GOOD:");
        $display("      • Use for status signals, processed data, flags");
        $display("      • Assign using always_ff, always_comb, or continuous assign");
        $display("      • One driver per output signal");
        $display("      • Clear reset behavior");
        $display();
        $display("   ❌ AVOID:");
        $display("      • Never read output ports internally");
        $display("      • Don't create multiple drivers");
        $display("      • Avoid combinational loops");
        $display();
        
        $display("🔹 INOUT PORTS (Bidirectional):");
        $display("   ✅ GOOD:");
        $display("      • Use for true bidirectional buses (I2C, SPI data)");
        $display("      • Always implement tri-state logic ('z when not driving)");
        $display("      • Clear bus arbitration and ownership");
        $display("      • Proper timing for direction changes");
        $display();
        $display("   ❌ AVOID:");
        $display("      • Don't use unless absolutely necessary");
        $display("      • Never drive without tri-state control");
        $display("      • Avoid bus conflicts (multiple drivers)");
        $display("      • Don't mix logic levels on same bus");
        $display();
        
        $display("🔹 REF PORTS (References):");
        $display("   ✅ GOOD:");
        $display("      • Use in testbenches for debugging and monitoring");
        $display("      • Allows access without explicit port connections");
        $display("      • Great for hierarchical signal access");
        $display("      • Useful for assertion and coverage collection");
        $display();
        $display("   ❌ AVOID:");
        $display("      • Not synthesizable - simulation only");
        $display("      • Don't use in production RTL code");
        $display("      • Avoid for functional signal passing");
        $display();
        
        $display("================================================================================");
        $display("                           CONNECTION GUIDELINES");
        $display("================================================================================");
        $display();
        
        $display("🔸 NAMED CONNECTIONS (Recommended):");
        $display("   my_module inst_name (");
        $display("       .clk(system_clock),");
        $display("       .reset_n(system_reset),");
        $display("       .data_in(input_data),");
        $display("       .data_out(output_data)");
        $display("   );");
        $display();
        
        $display("🔸 PARAMETER OVERRIDES:");
        $display("   my_module #(");
        $display("       .WIDTH(16),");
        $display("       .DEPTH(1024)");
        $display("   ) inst_name (");
        $display("       .clk(clk),");
        $display("       // ... port connections");
        $display("   );");
        $display();
        
        $display("🔸 TRI-STATE TEMPLATE:");
        $display("   // Control signal");
        $display("   logic drive_enable;");
        $display("   ");
        $display("   // Tri-state driver");
        $display("   assign bidirectional_bus = drive_enable ? output_data : 'z;");
        $display("   ");
        $display("   // Input reading");
        $display("   assign input_data = drive_enable ? 'x : bidirectional_bus;");
        $display();
        
        $display("================================================================================");
        $display("                              COMMON MISTAKES");
        $display("================================================================================");
        $display();
        
        $display("❗ Mistake 1: Assigning to input ports");
        $display("   // WRONG:");
        $display("   always_comb data_in = processed_value;  // ERROR!");
        $display("   ");
        $display("   // CORRECT:");
        $display("   always_comb data_out = processed_value;  // OK");
        $display();
        
        $display("❗ Mistake 2: Reading output ports internally");
        $display("   // WRONG:");
        $display("   always_comb internal_sig = data_out;  // ERROR!");
        $display("   ");
        $display("   // CORRECT:");
        $display("   always_comb data_out = internal_sig;  // OK");
        $display();
        
        $display("❗ Mistake 3: Inout without tri-state");
        $display("   // WRONG:");
        $display("   assign bidirectional = output_data;  // Always drives!");
        $display("   ");
        $display("   // CORRECT:");
        $display("   assign bidirectional = enable ? output_data : 'z;");
        $display();
        
        $display("❗ Mistake 4: Positional connections");
        $display("   // WRONG (error-prone):");
        $display("   my_module inst(clk, rst, en, din, dout);");
        $display("   ");
        $display("   // CORRECT (readable):");
        $display("   my_module inst(.clk(clk), .reset_n(rst), .enable(en));");
        $display();
        
        $display("================================================================================");
        $display("                          VERIFICATION CHECKLIST");
        $display("================================================================================");
        $display();
        
        $display("Before finalizing your design, verify:");
        $display();
        $display("🔲 All input ports are properly connected");
        $display("🔲 No input ports are assigned internally");
        $display("🔲 All output ports have single drivers");
        $display("🔲 No output ports are read internally");
        $display("🔲 Inout ports use proper tri-state logic");
        $display("🔲 No bus conflicts on bidirectional signals");
        $display("🔲 REF ports are used only in testbenches");
        $display("🔲 All ports have meaningful names");
        $display("🔲 Parameters are properly documented");
        $display("🔲 Reset behavior is clearly defined");
        $display();
        
        $display("================================================================================");
        $display("                           TESTBENCH COMPLETED");
        $display("================================================================================");
        $display();
        $display("Key files generated:");
        $display("• port_direction_demo.sv - Main module with all port types");
        $display("• port_connection_styles.sv - Connection examples");
        $display("• port_direction_testbench.sv - This comprehensive testbench");
        $display("• .env - Project configuration");
        $display();
        $display("View the VCD file to see signal waveforms and timing relationships.");
        $display();
        
        $finish;
    end

endmodule