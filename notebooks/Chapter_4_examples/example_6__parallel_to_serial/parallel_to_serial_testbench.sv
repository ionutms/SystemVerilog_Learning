// parallel_to_serial_testbench.sv
module parallel_to_serial_testbench;
    // Testbench signals
    logic clk, rst_n, load;
    logic [7:0] parallel_in;
    logic serial_out, done;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period clock
    end
    
    // Instantiate the design under test
    parallel_to_serial DUT (
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .parallel_in(parallel_in),
        .serial_out(serial_out),
        .done(done)
    );
    
    // Task to display current state
    task display_state(string description);
        $display("%s", description);
        $display("Time: %4t | Load: %b | Parallel_in: %8b (%02h) | Serial_out: %b | Done: %b | Count: %d | Shift_reg: %8b", 
                 $time, load, parallel_in, parallel_in, serial_out, done, DUT.count, DUT.shift_reg);
        $display("---------------------------------------------------------");
    endtask
    
    // Test stimulus
    initial begin
        // Dump waves
        $dumpfile("parallel_to_serial_testbench.vcd");
        $dumpvars(0, parallel_to_serial_testbench);
        
        $display("Starting Parallel-to-Serial Converter Test");
        $display("==========================================");
        $display();
        
        // Initialize signals
        rst_n = 0;
        load = 0;
        parallel_in = 8'h00;
        
        // Reset test
        #10;
        display_state("After Reset:");
        
        // Release reset
        rst_n = 1;
        #10;
        display_state("Reset Released:");
        
        // Test 1: Load pattern 10101010 (0xAA)
        $display("\n=== TEST 1: Converting 0xAA (10101010) ===");
        parallel_in = 8'hAA;
        load = 1;
        #10;
        display_state("Data Loaded:");
        
        load = 0;
        
        // Shift out all 8 bits
        for (int i = 0; i < 8; i++) begin
            #10;
            $display("Cycle %d: Serial_out = %b, Done = %b, Count = %d, Shift_reg = %8b", 
                     i+1, serial_out, done, DUT.count, DUT.shift_reg);
        end
        
        #10;
        display_state("After all bits shifted:");
        
        // Test 2: Load pattern 11110000 (0xF0)
        $display("\n=== TEST 2: Converting 0xF0 (11110000) ===");
        parallel_in = 8'hF0;
        load = 1;
        #10;
        display_state("Data Loaded:");
        
        load = 0;
        
        // Shift out all 8 bits
        for (int i = 0; i < 8; i++) begin
            #10;
            $display("Cycle %d: Serial_out = %b, Done = %b, Count = %d, Shift_reg = %8b", 
                     i+1, serial_out, done, DUT.count, DUT.shift_reg);
        end
        
        #10;
        display_state("After all bits shifted:");
        
        // Test 3: Load new data while shifting (should restart)
        $display("\n=== TEST 3: Load during shifting (0x55 then 0x33) ===");
        parallel_in = 8'h55;  // 01010101
        load = 1;
        #10;
        display_state("First Data Loaded (0x55):");
        
        load = 0;
        
        // Shift a few bits
        #10;
        $display("After 1 shift: Serial_out = %b, Count = %d, Shift_reg = %8b", 
                 serial_out, DUT.count, DUT.shift_reg);
        #10;
        $display("After 2 shifts: Serial_out = %b, Count = %d, Shift_reg = %8b", 
                 serial_out, DUT.count, DUT.shift_reg);
        
        // Load new data while shifting
        parallel_in = 8'h33;  // 00110011
        load = 1;
        #10;
        display_state("New Data Loaded (0x33) - Should restart:");
        
        load = 0;
        
        // Continue shifting the new data
        for (int i = 0; i < 8; i++) begin
            #10;
            $display("Cycle %d: Serial_out = %b, Done = %b, Count = %d, Shift_reg = %8b", 
                     i+1, serial_out, done, DUT.count, DUT.shift_reg);
        end
        
        // Test 4: Reset during operation
        $display("\n=== TEST 4: Reset during shifting ===");
        parallel_in = 8'hC3;  // 11000011
        load = 1;
        #10;
        display_state("Data Loaded (0xC3):");
        
        load = 0;
        
        // Shift a few bits
        #10;
        #10;
        #10;
        $display("After 3 shifts: Serial_out = %b, Count = %d, Shift_reg = %8b", 
                 serial_out, DUT.count, DUT.shift_reg);
        
        // Reset during operation
        rst_n = 0;
        #10;
        display_state("Reset Applied During Operation:");
        
        rst_n = 1;
        #10;
        display_state("Reset Released:");
        
        $display("\n==========================================");
        $display("Test completed!");
        
        #20;
        $finish;
    end

endmodule