// fifo_buffer_design_testbench.sv
module fifo_buffer_testbench;
    
    // Testbench signals
    logic       clock;
    logic       reset_n;
    logic       write_enable;
    logic       read_enable;
    logic [3:0] write_data;
    logic [3:0] read_data;
    logic       fifo_full;
    logic       fifo_empty;
    logic [2:0] data_count;
    
    // Test data array
    logic [3:0] test_data [0:9] = '{4'hA, 4'hB, 4'hC, 4'hD, 4'hE, 
                                    4'hF, 4'h1, 4'h2, 4'h3, 4'h4};
    integer write_index;
    
    // Instantiate the FIFO buffer design
    fifo_buffer_8x4 FIFO_BUFFER_INSTANCE (
        .clock(clock),
        .reset_n(reset_n),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .write_data(write_data),
        .read_data(read_data),
        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty),
        .data_count(data_count)
    );
    
    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end
    
    // Test sequence
    initial begin
        // Setup waveform dumping
        $dumpfile("fifo_buffer_testbench.vcd");
        $dumpvars(0, fifo_buffer_testbench);
        
        // Display header
        $display();
        $display("=== 8x4 FIFO Buffer Test ===");
        $display("FIFO Depth: 8 locations, Data Width: 4 bits");
        $display();
        
        // Initialize signals
        reset_n = 0;
        write_enable = 0;
        read_enable = 0;
        write_data = 0;
        write_index = 0;
        
        // Apply reset
        #15;
        reset_n = 1;
        $display("=== RESET COMPLETE ===");
        #10;
        
        // Test 1: Fill FIFO completely
        $display();
        $display("=== TEST 1: Filling FIFO ===");
        for (int i = 0; i < 8; i++) begin
            write_data = test_data[i];
            write_enable = 1;
            #10;
            write_enable = 0;
            #10;
        end
        
        // Try to write when full
        $display();
        $display("=== Testing write when FULL ===");
        write_data = 4'h9;
        write_enable = 1;
        #10;
        write_enable = 0;
        #10;
        
        // Test 2: Read all data from FIFO
        $display();
        $display("=== TEST 2: Reading from FIFO ===");
        for (int i = 0; i < 8; i++) begin
            read_enable = 1;
            #10;
            read_enable = 0;
            #10;
        end
        
        // Try to read when empty
        $display();
        $display("=== Testing read when EMPTY ===");
        read_enable = 1;
        #10;
        read_enable = 0;
        #10;
        
        // Test 3: Simultaneous read/write operations
        $display();
        $display("=== TEST 3: Simultaneous Read/Write ===");
        
        // First, put some data in FIFO
        for (int i = 0; i < 4; i++) begin
            write_data = test_data[i];
            write_enable = 1;
            #10;
            write_enable = 0;
            #10;
        end
        
        // Now do simultaneous read/write
        $display("Performing simultaneous read/write operations:");
        for (int i = 0; i < 3; i++) begin
            write_data = test_data[i+4];
            write_enable = 1;
            read_enable = 1;
            #10;
            write_enable = 0;
            read_enable = 0;
            #10;
        end
        
        // Test 4: Verify FIFO ordering (First-In-First-Out)
        $display();
        $display("=== TEST 4: FIFO Ordering Verification ===");
        
        // Clear FIFO first
        while (!fifo_empty) begin
            read_enable = 1;
            #10;
            read_enable = 0;
            #10;
        end
        
        // Write known sequence
        $display("Writing sequence: A, B, C, D");
        for (int i = 0; i < 4; i++) begin
            write_data = 4'hA + i[3:0];  // A, B, C, D
            write_enable = 1;
            #10;
            write_enable = 0;
            #10;
        end
        
        // Read back and verify order
        $display("Reading back sequence (should be A, B, C, D):");
        for (int i = 0; i < 4; i++) begin
            logic [3:0] expected_data;
            read_enable = 1;
            #10;
            expected_data = 4'hA + i[3:0];
            $display("Expected: %h, Got: %h %s", 
                     expected_data, read_data, 
                     (read_data == expected_data) ? "✓" : "✗");
            read_enable = 0;
            #10;
        end
        
        $display();
        $display("=== FIFO Buffer Test Complete ===");
        $display();
        
        #20;
        $finish;
    end
    
    // Monitor FIFO status changes
    always @(posedge clock) begin
        if (reset_n && (fifo_full || fifo_empty)) begin
            if (fifo_full)
                $display("*** FIFO is FULL ***");
            if (fifo_empty)
                $display("*** FIFO is EMPTY ***");
        end
    end

endmodule