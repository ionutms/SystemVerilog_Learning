// lookup_table_rom_testbench.sv
module lookup_table_rom_testbench;
    
    // Testbench signals
    logic [2:0] test_address;                   // Address input signal
    logic [7:0] expected_data;                  // Expected data output
    logic [7:0] actual_data;                    // Actual data from ROM

    // Instantiate the design under test
    lookup_table_rom ROM_INSTANCE (
        .address_input(test_address),
        .data_output(actual_data)
    );

    initial begin
        // Setup waveform dumping
        $dumpfile("lookup_table_rom_testbench.vcd");
        $dumpvars(0, lookup_table_rom_testbench);
        
        $display();
        $display("=== ROM Lookup Table Test Started ===");
        $display();

        // Test all ROM addresses
        for (int addr = 0; addr < 8; addr++) begin
            test_address = addr[2:0];           // Set address
            #1;                                 // Wait for combinational delay
            
            // Display results
            $display("Address: %0d (0x%h) -> Data: 0x%h", 
                     test_address, test_address, actual_data);
        end

        $display();
        $display("=== Verification Test ===");
        
        // Verify specific values
        test_address = 3'b000; #1;
        if (actual_data !== 8'h10) 
            $display(
                "ERROR: Address 0 expected 0x10, got 0x%h", actual_data);
        
        test_address = 3'b011; #1;
        if (actual_data !== 8'h47) 
            $display(
                "ERROR: Address 3 expected 0x47, got 0x%h", actual_data);
        
        test_address = 3'b111; #1;
        if (actual_data !== 8'h83) 
            $display(
                "ERROR: Address 7 expected 0x83, got 0x%h", actual_data);

        $display();
        $display("=== ROM Lookup Table Test Completed ===");
        $display();
        
        $finish;
    end

endmodule