// shift_register_testbench.sv
module shift_register_testbench;    // Testbench module
    logic clk, rst_n, serial_in;
    logic [7:0] parallel_out;
    logic [7:0] test_pattern = 8'b10110011;
    
    shift_register SHIFT_REG_DUT (.*);  // Instantiate shift register design under test
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Main test sequence
    initial begin
        // Dump waves
        $dumpfile("shift_register_testbench.vcd");      // Specify the VCD file
        $dumpvars(0, shift_register_testbench);         // Dump all variables in the test module
        
        $display();                                     // Display empty line
        $display("Testbench: Starting shift register validation...");
        $display();                                     // Display empty line
        
        rst_n = 0;
        serial_in = 0;
        
        #10 rst_n = 1;
        $display("Testbench: Reset released, starting shift operations...");
        
        // Shift in test pattern 10110011
        for (int i = 7; i >= 0; i--) begin
            @(posedge clk);
            serial_in = test_pattern[i];
        end
        
        @(posedge clk);
        $display();                                     // Display empty line
        $display("Testbench: Final parallel output: %b", parallel_out);
        $display("Testbench: Shift register validation completed!");
        $display();                                     // Display empty line
        $finish;
    end

endmodule