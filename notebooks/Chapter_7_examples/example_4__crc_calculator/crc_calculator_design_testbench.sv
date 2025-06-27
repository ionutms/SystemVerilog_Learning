// crc_calculator_design_testbench.sv
module crc_calculator_testbench_module;

  // Testbench signals with descriptive names
  logic        clock_signal_tb;
  logic        reset_active_low_tb;
  logic        data_valid_input_tb;
  logic [7:0]  data_byte_input_tb;
  logic [7:0]  crc_checksum_output_tb;
  logic        crc_calculation_complete_tb;

  // Test data array for CRC calculation
  logic [7:0] test_data_array [4] = '{8'hAB, 8'hCD, 8'hEF, 8'h12};
  integer     data_index_counter;

  // Instantiate the CRC calculator design under test
  crc_calculator_design_module CRC_CALCULATOR_INSTANCE (
    .clock_signal              (clock_signal_tb),
    .reset_active_low          (reset_active_low_tb),
    .data_valid_input          (data_valid_input_tb),
    .data_byte_input           (data_byte_input_tb),
    .crc_checksum_output       (crc_checksum_output_tb),
    .crc_calculation_complete  (crc_calculation_complete_tb)
  );

  // Clock generation - 10ns period
  always #5 clock_signal_tb = ~clock_signal_tb;

  // Main test sequence
  initial begin
    // Initialize waveform dump
    $dumpfile("crc_calculator_testbench_module.vcd");
    $dumpvars(0, crc_calculator_testbench_module);
    
    // Display test start message
    $display();
    $display("=== CRC Calculator Testbench Starting ===");
    $display();

    // Initialize all signals
    clock_signal_tb      = 1'b0;
    reset_active_low_tb  = 1'b1;
    data_valid_input_tb  = 1'b0;
    data_byte_input_tb   = 8'h00;
    data_index_counter   = 0;

    // Apply reset sequence
    $display("Applying reset sequence...");
    #10 reset_active_low_tb = 1'b0;  // Assert reset
    #20 reset_active_low_tb = 1'b1;  // Release reset
    #10;

    // Test CRC calculation with sample data
    $display("Starting CRC calculation with test data:");
    for (data_index_counter = 0; data_index_counter < 4; 
         data_index_counter++) begin
      
      $display("Processing byte %0d: 0x%02h", 
               data_index_counter, test_data_array[data_index_counter]);
      
      // Present data to CRC calculator
      data_byte_input_tb  = test_data_array[data_index_counter];
      data_valid_input_tb = 1'b1;
      #10;
      
      // Remove data valid signal
      data_valid_input_tb = 1'b0;
      #10;
      
      // Wait for calculation completion
      wait (crc_calculation_complete_tb);
      #5;
    end

    // Final CRC result display
    $display();
    $display("Final CRC checksum result: 0x%02h", crc_checksum_output_tb);
    $display();

    // Test reset functionality
    $display("Testing reset functionality...");
    #10 reset_active_low_tb = 1'b0;
    #10 reset_active_low_tb = 1'b1;
    #10;
    
    $display("CRC after reset: 0x%02h", crc_checksum_output_tb);
    $display();

    // Complete testbench execution
    $display("=== CRC Calculator Testbench Complete ===");
    $display();
    #50;
    $finish;
  end

  // Monitor for important signal changes
  initial begin
    forever begin
      @(posedge crc_calculation_complete_tb);
      $display("Time %0t: CRC calculation completed, result = 0x%02h", 
               $time, crc_checksum_output_tb);
    end
  end

endmodule