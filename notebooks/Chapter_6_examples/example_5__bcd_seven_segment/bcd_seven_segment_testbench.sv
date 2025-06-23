// bcd_seven_segment_testbench.sv
module bcd_testbench;

    // Test signals
    logic [3:0] test_bcd;
    logic [6:0] display_segments;

    // Expected patterns for verification
    logic [6:0] expected_patterns [0:9] = '{
        7'b1111110, // 0
        7'b0110000, // 1
        7'b1101101, // 2
        7'b1111001, // 3
        7'b0110011, // 4
        7'b1011011, // 5
        7'b1011111, // 6
        7'b1110000, // 7
        7'b1111111, // 8
        7'b1111011  // 9
    };

    // Instantiate the design under test
    bcd_seven_segment DUT (
        .bcd_in(test_bcd),
        .segments(display_segments)
    );

    initial begin
        // Setup waveform dumping
        $dumpfile("bcd_testbench.vcd");
        $dumpvars(0, bcd_testbench);
        
        $display("=== BCD to Seven-Segment Decoder Test ===");
        $display("Segment order: [a,b,c,d,e,f,g] (MSB to LSB)");
        $display("Display layout:");
        $display("  aaa  ");
        $display(" f   b ");
        $display(" f   b ");
        $display("  ggg  ");
        $display(" e   c ");
        $display(" e   c ");
        $display("  ddd  ");
        $display();
        
        // Test all valid BCD inputs (0-9)
        $display("Testing valid BCD inputs (0-9):");
        for (int i = 0; i <= 9; i++) begin
            test_bcd = i[3:0];
            #10;
            
            // Verify the output
            if (display_segments == expected_patterns[i]) begin
                $display("✓ BCD %0d: PASS - Segments: %7b", i, display_segments);
            end else begin
                $display("✗ BCD %0d: FAIL - Expected: %7b, Got: %7b", 
                        i, expected_patterns[i], display_segments);
            end
        end
        
        $display();
        
        // Test invalid BCD inputs (10-15)
        $display("Testing invalid BCD inputs (A-F):");
        for (int i = 10; i <= 15; i++) begin
            test_bcd = i[3:0];
            #10;
            
            if (display_segments == 7'b0000000) begin
                $display("✓ BCD %X: PASS - Blank display (segments: %7b)", i, display_segments);
            end else begin
                $display("✗ BCD %X: FAIL - Expected blank, Got: %7b", i, display_segments);
            end
        end
        
        $display();
        
        // Visual representation test
        $display("Visual representation of each digit:");
        for (int i = 0; i <= 9; i++) begin
            test_bcd = i[3:0];
            #10;
            $display("Digit %0d:", i);
            display_seven_segment(display_segments);
            $display();
        end
        
        $display("=== BCD Decoder Test Complete ===");
        $finish;
    end

    // Function to display seven-segment pattern visually
    task display_seven_segment(logic [6:0] seg);
        string a, b, c, d, e, f, g;
        
        // Convert segment bits to display characters
        a = seg[6] ? "###" : "   ";
        b = seg[5] ? "#" : " ";
        c = seg[4] ? "#" : " ";
        d = seg[3] ? "###" : "   ";
        e = seg[2] ? "#" : " ";
        f = seg[1] ? "#" : " ";
        g = seg[0] ? "###" : "   ";
        
        // Display the seven-segment pattern
        $display(" %s ", a);
        $display("%s   %s", f, b);
        $display("%s   %s", f, b);
        $display(" %s ", g);
        $display("%s   %s", e, c);
        $display("%s   %s", e, c);
        $display(" %s ", d);
    endtask

    // Monitor for any changes
    always @(display_segments) begin
        #1; // Small delay for clean display
    end

endmodule