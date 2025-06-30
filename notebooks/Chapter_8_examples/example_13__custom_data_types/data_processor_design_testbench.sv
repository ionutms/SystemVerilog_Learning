// data_processor_design_testbench.sv
module data_processor_testbench;

  // Custom data type definitions (same as design for consistency)
  typedef logic [7:0]  byte_t;      // 8-bit byte type
  typedef logic [15:0] word_t;      // 16-bit word type  
  typedef logic [31:0] dword_t;     // 32-bit double word type

  // Testbench signals using custom data types
  logic   clock_signal;
  logic   reset_signal;
  byte_t  stimulus_byte_data;
  word_t  stimulus_word_data;
  dword_t stimulus_dword_data;
  byte_t  captured_byte_result;
  word_t  captured_word_result;
  dword_t captured_dword_result;

  // Clock generation
  initial begin
    clock_signal = 0;
    forever #5 clock_signal = ~clock_signal;  // 10ns period clock
  end

  // Design under test instantiation
  data_processor_module PROCESSOR_INSTANCE (
    .clock_signal       (clock_signal),
    .reset_signal       (reset_signal),
    .input_byte_data    (stimulus_byte_data),
    .input_word_data    (stimulus_word_data),
    .input_dword_data   (stimulus_dword_data),
    .output_byte_result (captured_byte_result),
    .output_word_result (captured_word_result),
    .output_dword_result(captured_dword_result)
  );

  // Test stimulus and verification
  initial begin
    // Initialize waveform dumping
    $dumpfile("data_processor_testbench.vcd");
    $dumpvars(0, data_processor_testbench);

    $display("=== Custom Data Types Example ===");
    $display("Testing byte_t, word_t, and dword_t definitions");
    $display();

    // Initialize signals
    reset_signal = 1;
    stimulus_byte_data  = byte_t'(8'h00);
    stimulus_word_data  = word_t'(16'h0000);
    stimulus_dword_data = dword_t'(32'h00000000);

    // Release reset after 2 clock cycles
    repeat(2) @(posedge clock_signal);
    reset_signal = 0;
    $display("Reset released - starting data processing tests");
    $display();

    // Test case 1: Small values
    @(posedge clock_signal);
    stimulus_byte_data  = byte_t'(8'h0F);
    stimulus_word_data  = word_t'(16'h1234);
    stimulus_dword_data = dword_t'(32'hABCD_EF01);
    
    @(posedge clock_signal);
    @(posedge clock_signal);

    // Test case 2: Maximum values
    @(posedge clock_signal);
    stimulus_byte_data  = byte_t'(8'hFF);
    stimulus_word_data  = word_t'(16'hFFFF);
    stimulus_dword_data = dword_t'(32'hFFFF_FFFF);
    
    @(posedge clock_signal);
    @(posedge clock_signal);

    // Test case 3: Pattern testing
    @(posedge clock_signal);
    stimulus_byte_data  = byte_t'(8'h55);    // Alternating pattern
    stimulus_word_data  = word_t'(16'h5AA5);  // Alternating pattern
    stimulus_dword_data = dword_t'(32'h5555_AAAA);
    
    @(posedge clock_signal);
    @(posedge clock_signal);

    // Test case 4: Zero values
    @(posedge clock_signal);
    stimulus_byte_data  = byte_t'(8'h00);
    stimulus_word_data  = word_t'(16'h0000);
    stimulus_dword_data = dword_t'(32'h0000_0000);
    
    @(posedge clock_signal);
    @(posedge clock_signal);

    $display();
    $display("=== Custom Data Types Test Complete ===");
    $display("Demonstrated usage of:");
    $display("- byte_t  (8-bit)  type alias");
    $display("- word_t  (16-bit) type alias");
    $display("- dword_t (32-bit) type alias");
    $display("Benefits: Improved code readability and maintainability");
    $display();

    $finish;
  end

endmodule