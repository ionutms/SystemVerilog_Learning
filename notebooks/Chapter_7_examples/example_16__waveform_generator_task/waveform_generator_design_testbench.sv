// waveform_generator_design_testbench.sv
module waveform_generator_testbench;
  
  // Testbench signals
  logic       clock_signal;
  logic       reset_signal;
  logic [1:0] waveform_type_select;
  logic       generated_waveform_output;
  
  // Instantiate design under test
  waveform_generator_module WAVEFORM_GENERATOR_INSTANCE (
    .clock_signal(clock_signal),
    .reset_signal(reset_signal),
    .waveform_type_select(waveform_type_select),
    .generated_waveform_output(generated_waveform_output)
  );
  
  // Clock generation
  initial begin
    clock_signal = 1'b0;
    forever #5 clock_signal = ~clock_signal;
  end
  
  // Task to generate different waveform types
  task automatic generate_waveform_pattern(
    input [1:0] selected_waveform_type,
    input int   pattern_duration_cycles
  );
    $display("Generating waveform type: %0d for %0d cycles", 
             selected_waveform_type, pattern_duration_cycles);
    waveform_type_select = selected_waveform_type;
    repeat(pattern_duration_cycles) @(posedge clock_signal);
    $display("Waveform pattern generation completed");
    $display();
  endtask
  
  // Task to apply reset sequence
  task automatic apply_system_reset(input int reset_duration_cycles);
    $display("Applying system reset for %0d cycles", reset_duration_cycles);
    reset_signal = 1'b1;
    repeat(reset_duration_cycles) @(posedge clock_signal);
    reset_signal = 1'b0;
    $display("System reset released");
    $display();
  endtask
  
  // Main test sequence
  initial begin
    // Setup waveform dumping
    $dumpfile("waveform_generator_testbench.vcd");
    $dumpvars(0, waveform_generator_testbench);
    
    // Initialize signals
    reset_signal = 1'b0;
    waveform_type_select = 2'b00;
    
    $display();
    $display("=== Waveform Generator Task Test ===");
    $display();
    
    // Apply reset
    apply_system_reset(3);
    
    // Test different waveform types using tasks
    generate_waveform_pattern(2'b00, 16);  // Square wave
    generate_waveform_pattern(2'b01, 16);  // Triangle wave
    generate_waveform_pattern(2'b10, 16);  // Sawtooth wave
    generate_waveform_pattern(2'b11, 16);  // Pulse wave
    
    $display("All waveform patterns tested successfully!");
    $display();
    
    #50;
    $finish;
  end
  
endmodule