// file_processor_testbench.sv
module file_processor_testbench;

  // Testbench signals
  logic       tb_clock;
  logic       tb_reset_n;
  logic [7:0] tb_input_data;
  logic       tb_data_valid;
  logic [7:0] tb_processed_data;
  logic       tb_output_valid;

  // File handles
  integer input_file_handle;
  integer output_file_handle;
  integer log_file_handle;

  // Test data
  logic [7:0] read_data;
  integer     scan_result;

  // DUT instantiation
  file_data_processor #(
    .DATA_WIDTH(8)
  ) dut_file_processor (
    .clock(tb_clock),
    .reset_n(tb_reset_n),
    .input_data(tb_input_data),
    .data_valid(tb_data_valid),
    .processed_data(tb_processed_data),
    .output_valid(tb_output_valid)
  );

  // Clock generation
  initial begin
    tb_clock = 1'b0;
    forever #5 tb_clock = ~tb_clock;  // 10ns period
  end

  // Main test sequence
  initial begin
    // Setup waveform dumping
    $dumpfile("file_processor_testbench.vcd");
    $dumpvars(0, file_processor_testbench);

    // Open files
    input_file_handle = $fopen("input_test_data.txt", "r");
    output_file_handle = $fopen("output_results.txt", "w");
    log_file_handle = $fopen("simulation_log.txt", "w");

    // Check if files opened successfully
    if (input_file_handle == 0) begin
      $display("ERROR: Could not open input_test_data.txt");
      $finish;
    end

    // Write header to log file
    $fwrite(log_file_handle, "=== File I/O Test Simulation Log ===\n");
    $fwrite(log_file_handle, "Time\tInput\tOutput\tValid\n");
    $fwrite(log_file_handle, "----\t-----\t------\t-----\n");

    // Initialize signals
    tb_reset_n = 1'b0;
    tb_input_data = 8'h00;
    tb_data_valid = 1'b0;

    // Reset sequence
    repeat(3) @(posedge tb_clock);
    tb_reset_n = 1'b1;
    @(posedge tb_clock);

    $display("Starting file I/O test...");

    // Read data from file and process
    while (!$feof(input_file_handle)) begin
      // Read data from input file
      scan_result = $fscanf(input_file_handle, "%h\n", read_data);
      
      if (scan_result == 1) begin
        // Apply data to DUT
        tb_input_data = read_data;
        tb_data_valid = 1'b1;
        @(posedge tb_clock);
        
        // Wait for output
        @(posedge tb_clock);
        
        if (tb_output_valid) begin
          // Write results to output file
          $fwrite(output_file_handle, "%02h -> %02h\n", 
                  read_data, tb_processed_data);
          
          // Write to log file
          $fwrite(log_file_handle, "%0t\t%02h\t%02h\t%b\n", 
                  $time, read_data, tb_processed_data, tb_output_valid);
          
          $display("Processed: 0x%02h -> 0x%02h", 
                   read_data, tb_processed_data);
        end
        
        tb_data_valid = 1'b0;
        @(posedge tb_clock);
      end
    end

    // Write test summary
    $fwrite(log_file_handle, "\n=== Test Completed Successfully ===\n");
    $fwrite(output_file_handle, "\n# Test completed at time %0t\n", $time);

    // Close all files
    $fclose(input_file_handle);
    $fclose(output_file_handle);
    $fclose(log_file_handle);

    $display("File I/O test completed!");
    $display("Check output_results.txt and simulation_log.txt");
    
    #20;
    $finish;
  end

  // Create input test data file
  initial begin
    integer temp_file;
    temp_file = $fopen("input_test_data.txt", "w");
    
    // Write test data (hex values)
    $fwrite(temp_file, "0A\n");
    $fwrite(temp_file, "1F\n");
    $fwrite(temp_file, "33\n");
    $fwrite(temp_file, "7E\n");
    $fwrite(temp_file, "FF\n");
    
    $fclose(temp_file);
  end

endmodule