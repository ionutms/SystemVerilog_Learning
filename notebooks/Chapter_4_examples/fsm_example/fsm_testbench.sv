// fsm_testbench.sv
module fsm_testbench;
    // Testbench signals
    logic clk, rst_n, start, rw;
    logic busy, done;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period clock
    end
    
    // Instantiate the design under test
    fsm DUT (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .rw(rw),
        .busy(busy),
        .done(done)
    );
    
    // Test stimulus
    initial begin
        // Dump waves
        $dumpfile("fsm_testbench.vcd");
        $dumpvars(0, fsm_testbench);
        
        $display();
        $display("Starting FSM Test");
        $display("=================");
        $display("Time\tState\t\tInputs\t\tOutputs");
        $display("    \t     \t\trst_n start rw\tbusy done");
        $display("-----------------------------------------------");
        
        // Initialize signals
        rst_n = 0;
        start = 0;
        rw = 0;
        
        // Reset test
        #10;
        $display("%4t\t%s\t%b     %b     %b\t%b    %b", 
                 $time, DUT.current_state.name(), rst_n, start, rw, busy, done);
        
        // Release reset
        rst_n = 1;
        #10;
        $display("%4t\t%s\t%b     %b     %b\t%b    %b", 
                 $time, DUT.current_state.name(), rst_n, start, rw, busy, done);
        
        // Test READ operation
        $display("\n--- Testing READ Operation ---");
        start = 1;
        rw = 0;  // READ
        #10;
        $display("%4t\t%s\t%b     %b     %b\t%b    %b", 
                 $time, DUT.current_state.name(), rst_n, start, rw, busy, done);
        
        start = 0;
        #10;
        $display("%4t\t%s\t%b     %b     %b\t%b    %b", 
                 $time, DUT.current_state.name(), rst_n, start, rw, busy, done);
        
        #10;
        $display("%4t\t%s\t%b     %b     %b\t%b    %b", 
                 $time, DUT.current_state.name(), rst_n, start, rw, busy, done);
        
        #10;
        $display("%4t\t%s\t%b     %b     %b\t%b    %b", 
                 $time, DUT.current_state.name(), rst_n, start, rw, busy, done);
        
        // Test WRITE operation
        $display("\n--- Testing WRITE Operation ---");
        start = 1;
        rw = 1;  // WRITE
        #10;
        $display("%4t\t%s\t%b     %b     %b\t%b    %b", 
                 $time, DUT.current_state.name(), rst_n, start, rw, busy, done);
        
        start = 0;
        #10;
        $display("%4t\t%s\t%b     %b     %b\t%b    %b", 
                 $time, DUT.current_state.name(), rst_n, start, rw, busy, done);
        
        #10;
        $display("%4t\t%s\t%b     %b     %b\t%b    %b", 
                 $time, DUT.current_state.name(), rst_n, start, rw, busy, done);
        
        #10;
        $display("%4t\t%s\t%b     %b     %b\t%b    %b", 
                 $time, DUT.current_state.name(), rst_n, start, rw, busy, done);
        
        // Test staying in IDLE when start is not asserted
        $display("\n--- Testing IDLE Hold ---");
        start = 0;
        rw = 0;
        #20;
        $display("%4t\t%s\t%b     %b     %b\t%b    %b", 
                 $time, DUT.current_state.name(), rst_n, start, rw, busy, done);
        
        // Test reset during operation
        $display("\n--- Testing Reset During Operation ---");
        start = 1;
        rw = 1;
        #10;
        $display("%4t\t%s\t%b     %b     %b\t%b    %b", 
                 $time, DUT.current_state.name(), rst_n, start, rw, busy, done);
        
        // Assert reset
        rst_n = 0;
        #10;
        $display("%4t\t%s\t%b     %b     %b\t%b    %b", 
                 $time, DUT.current_state.name(), rst_n, start, rw, busy, done);
        
        // Release reset
        rst_n = 1;
        start = 0;
        #10;
        $display("%4t\t%s\t%b     %b     %b\t%b    %b", 
                 $time, DUT.current_state.name(), rst_n, start, rw, busy, done);
        
        $display("\n=================");
        $display("Test completed!");
        $display();
        
        #20;
        $finish;
    end

endmodule