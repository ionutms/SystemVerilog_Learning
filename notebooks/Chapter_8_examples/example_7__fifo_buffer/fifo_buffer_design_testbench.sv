// fifo_buffer_design_testbench.sv
module fifo_buffer_testbench;

  // Testbench signals
  logic        clock_signal;
  logic        reset_signal;
  logic        push_enable;
  logic        pop_enable;
  logic [7:0]  data_input;
  logic [7:0]  data_output;
  logic        fifo_empty_flag;
  logic        fifo_full_flag;

  // Instantiate the FIFO buffer design under test
  simple_fifo_buffer #(
    .DATA_WIDTH(8),
    .FIFO_DEPTH(4)
  ) FIFO_BUFFER_INSTANCE (
    .clock_signal(clock_signal),
    .reset_signal(reset_signal),
    .push_enable(push_enable),
    .pop_enable(pop_enable),
    .data_input(data_input),
    .data_output(data_output),
    .fifo_empty_flag(fifo_empty_flag),
    .fifo_full_flag(fifo_full_flag)
  );

  // Clock generation
  always #5 clock_signal = ~clock_signal;

  initial begin
    // Dump waves for analysis
    $dumpfile("fifo_buffer_testbench.vcd");
    $dumpvars(0, fifo_buffer_testbench);

    // Initialize all signals
    clock_signal = 0;
    reset_signal = 1;
    push_enable  = 0;
    pop_enable   = 0;
    data_input   = 8'h00;

    $display();
    $display("=== FIFO Buffer Test Starting ===");
    
    // Release reset
    #10 reset_signal = 0;
    #10;

    // Test push_back operations (filling FIFO)
    $display("\n--- Testing push_back operations ---");
    push_data_to_fifo(8'hAA);
    push_data_to_fifo(8'hBB);
    push_data_to_fifo(8'hCC);
    push_data_to_fifo(8'hDD);
    
    // Try to push when full
    $display("\n--- Testing push when FIFO is full ---");
    push_data_to_fifo(8'hEE);

    // Test pop_front operations (emptying FIFO)
    $display("\n--- Testing pop_front operations ---");
    pop_data_from_fifo();
    pop_data_from_fifo();
    pop_data_from_fifo();
    pop_data_from_fifo();
    
    // Try to pop when empty
    $display("\n--- Testing pop when FIFO is empty ---");
    pop_data_from_fifo();

    // Test mixed push and pop operations
    $display("\n--- Testing mixed push/pop operations ---");
    push_data_to_fifo(8'h11);
    push_data_to_fifo(8'h22);
    pop_data_from_fifo();
    push_data_to_fifo(8'h33);
    pop_data_from_fifo();
    pop_data_from_fifo();

    $display();
    $display("=== FIFO Buffer Test Complete ===");
    $display();
    
    #20 $finish;
  end

  // Task for push_back operation
  task push_data_to_fifo(input [7:0] test_data);
    data_input  = test_data;
    push_enable = 1;
    #10;
    push_enable = 0;
    #10;
  endtask

  // Task for pop_front operation  
  task pop_data_from_fifo();
    pop_enable = 1;
    #10;
    pop_enable = 0;
    #10;
  endtask

endmodule