// clock_divider_circuit_testbench.sv
module clock_divider_testbench;
    
    // Testbench signals
    logic clk_in;
    logic reset_n;
    logic clk_out_div2, clk_out_div3, clk_out_div4, clk_out_div5;
    
    // Clock generation
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;  // 100MHz clock (10ns period)
    end
    
    // Instantiate clock dividers with different ratios
    clock_divider_circuit #(.DIVIDE_RATIO(2)) DIV_BY_2 (
        .clk_in(clk_in),
        .reset_n(reset_n),
        .clk_out(clk_out_div2)
    );
    
    clock_divider_circuit #(.DIVIDE_RATIO(3)) DIV_BY_3 (
        .clk_in(clk_in),
        .reset_n(reset_n),
        .clk_out(clk_out_div3)
    );
    
    clock_divider_circuit #(.DIVIDE_RATIO(4)) DIV_BY_4 (
        .clk_in(clk_in),
        .reset_n(reset_n),
        .clk_out(clk_out_div4)
    );
    
    clock_divider_circuit #(.DIVIDE_RATIO(5)) DIV_BY_5 (
        .clk_in(clk_in),
        .reset_n(reset_n),
        .clk_out(clk_out_div5)
    );
    
    // Test sequence
    initial begin
        // Dump waves
        $dumpfile("clock_divider_testbench.vcd");
        $dumpvars(0, clock_divider_testbench);
        
        $display("Starting Clock Divider Test");
        $display("Input Clock Period: 10ns (100MHz)");
        $display();
        
        // Reset sequence
        reset_n = 0;
        #20;
        reset_n = 1;
        $display("Reset released at time %0t", $time);
        $display();
        
        // Monitor clock transitions
        $display("Time\tClk_In\tDiv2\tDiv3\tDiv4\tDiv5");
        $display("----\t------\t----\t----\t----\t----");
        
        // Run simulation for several clock cycles
        repeat (50) begin
            @(posedge clk_in);
            $display("%0t\t%b\t%b\t%b\t%b\t%b", 
                     $time, clk_in, clk_out_div2, clk_out_div3, clk_out_div4, clk_out_div5);
        end
        
        $display();
        $display("Clock frequencies:");
        $display("  Input:  100 MHz");
        $display("  Div/2:   50 MHz (even division)");
        $display("  Div/3: 33.33 MHz (odd division)");
        $display("  Div/4:   25 MHz (even division)");
        $display("  Div/5:   20 MHz (odd division)");
        $display();
        
        $display("Clock Divider Test Complete!");
        $finish;
    end
    
    // Additional monitoring for frequency verification
    integer div2_count = 0, div3_count = 0, div4_count = 0, div5_count = 0;
    
    always @(posedge clk_out_div2) div2_count++;
    always @(posedge clk_out_div3) div3_count++;
    always @(posedge clk_out_div4) div4_count++;
    always @(posedge clk_out_div5) div5_count++;
    
    // Report frequency counts at end
    final begin
        $display("Positive edge counts during simulation:");
        $display("  Div/2: %0d edges", div2_count);
        $display("  Div/3: %0d edges", div3_count);
        $display("  Div/4: %0d edges", div4_count);
        $display("  Div/5: %0d edges", div5_count);
    end

endmodule