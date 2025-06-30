// command_queue_processor_testbench.sv
module command_queue_testbench;

    // Testbench signals
    logic                   test_clock;
    logic                   test_reset_n;
    logic                   test_push_front_enable;
    logic                   test_push_back_enable;
    logic                   test_pop_enable;
    logic [63:0]           test_command_data_in;
    logic [63:0]           test_command_data_out;
    logic                   test_queue_empty;
    logic                   test_queue_full;

    // Instantiate design under test
    command_queue_processor COMMAND_QUEUE_INSTANCE (
        .clock(test_clock),
        .reset_n(test_reset_n),
        .push_front_enable(test_push_front_enable),
        .push_back_enable(test_push_back_enable),
        .pop_enable(test_pop_enable),
        .command_data_in(test_command_data_in),
        .command_data_out(test_command_data_out),
        .queue_empty(test_queue_empty),
        .queue_full(test_queue_full)
    );

    // Clock generation
    initial begin
        test_clock = 0;
        forever #5 test_clock = ~test_clock;  // 10ns period
    end

    // Test stimulus
    initial begin
        // Dump waves
        $dumpfile("command_queue_testbench.vcd");
        $dumpvars(0, command_queue_testbench);

        // Initialize signals
        test_reset_n = 0;
        test_push_front_enable = 0;
        test_push_back_enable = 0;
        test_pop_enable = 0;
        test_command_data_in = 0;

        $display("=== Command Queue Processor Test ===");
        $display();

        // Release reset
        #20 test_reset_n = 1;
        #10;

        // Test 1: Add commands to back of queue
        $display("Test 1: Adding commands to back of queue");
        add_command_to_back(64'h4D4F56450000_0000);  // "MOVE"
        add_command_to_back(64'h5475726E0000_0000);  // "Turn"
        add_command_to_back(64'h53746F7000000000);   // "Stop"
        #10;

        // Test 2: Process commands in order
        $display("Test 2: Processing commands in FIFO order");
        process_next_command();
        process_next_command();
        process_next_command();
        #10;

        // Test 3: Add urgent commands to front
        $display("Test 3: Adding urgent commands to front");
        add_command_to_back(64'h536C6F7700000000);   // "Slow"
        add_command_to_front(64'h4272616B65000000);  // "Brake"
        add_command_to_front(64'h555247454E540000);  // "URGENT"
        #10;

        // Test 4: Process mixed priority commands
        $display("Test 4: Processing mixed priority commands");
        process_next_command();  // Should be URGENT
        process_next_command();  // Should be Brake
        process_next_command();  // Should be Slow
        #10;

        // Test 5: Fill queue to capacity
        $display("Test 5: Testing queue capacity");
        repeat(8) begin
            add_command_to_back(64'h46554C4C00000000);  // "FULL"
        end
        $display("Queue full status: %b", test_queue_full);
        #10;

        // Test 6: Empty the queue
        $display("Test 6: Emptying the queue");
        repeat(8) begin
            process_next_command();
        end
        $display("Queue empty status: %b", test_queue_empty);
        #20;

        $display();
        $display("=== Command Queue Test Complete ===");
        $finish;
    end

    // Helper task to add command to back
    task add_command_to_back(input [63:0] cmd_data);
        begin
            test_command_data_in = cmd_data;
            test_push_back_enable = 1;
            @(posedge test_clock);
            test_push_back_enable = 0;
            test_command_data_in = 0;
            $display("Added command to back of queue");
        end
    endtask

    // Helper task to add urgent command to front
    task add_command_to_front(input [63:0] cmd_data);
        begin
            test_command_data_in = cmd_data;
            test_push_front_enable = 1;
            @(posedge test_clock);
            test_push_front_enable = 0;
            test_command_data_in = 0;
            $display("Added urgent command to front of queue");
        end
    endtask

    // Helper task to process next command
    task process_next_command();
        begin
            if (!test_queue_empty) begin
                test_pop_enable = 1;
                @(posedge test_clock);
                test_pop_enable = 0;
                $display("Processed and removed command from queue");
            end else begin
                $display("Cannot process: Queue is empty");
            end
        end
    endtask

endmodule