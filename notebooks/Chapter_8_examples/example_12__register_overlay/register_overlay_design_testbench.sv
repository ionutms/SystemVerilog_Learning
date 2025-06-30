// register_overlay_design_testbench.sv
module register_overlay_testbench;

  // Instantiate design under test
  register_overlay_processor OVERLAY_PROCESSOR_INSTANCE();

  // Additional testbench-specific union for testing
  typedef union packed {
    logic [31:0] complete_word;
    logic [1:0][15:0] word_halves;
    logic [3:0][7:0] individual_bytes;
    struct packed {
      logic [7:0] flags;
      logic [7:0] control_bits;
      logic [15:0] data_payload;
    } register_fields;
  } test_register_t;

  test_register_t configuration_register;

  initial begin
    // Setup waveform dumping
    $dumpfile("register_overlay_testbench.vcd");
    $dumpvars(0, register_overlay_testbench);
    
    #1; // Wait for design initialization
    
    $display("=== Testbench Register Overlay Tests ===");
    
    // Test 1: Build register from individual components
    configuration_register.register_fields.flags = 8'b11010011;
    configuration_register.register_fields.control_bits = 8'b01010101;
    configuration_register.register_fields.data_payload = 16'h1234;
    
    $display("Test 1 - Building from fields:");
    $display("  Flags: 0b%08b", 
             configuration_register.register_fields.flags);
    $display("  Control: 0b%08b", 
             configuration_register.register_fields.control_bits);
    $display("  Payload: 0x%04X", 
             configuration_register.register_fields.data_payload);
    $display("  Complete Word: 0x%08X", 
             configuration_register.complete_word);
    
    #5;
    
    // Test 2: Modify bytes and check word
    configuration_register.individual_bytes[3] = 8'hFF;
    configuration_register.individual_bytes[2] = 8'h00;
    configuration_register.individual_bytes[1] = 8'hAA;
    configuration_register.individual_bytes[0] = 8'h55;
    
    $display();
    $display("Test 2 - Byte-level modifications:");
    $display("  Word after byte changes: 0x%08X", 
             configuration_register.complete_word);
    $display("  Upper half: 0x%04X", 
             configuration_register.word_halves[1]);
    $display("  Lower half: 0x%04X", 
             configuration_register.word_halves[0]);
    
    #5;
    
    // Test 3: Word-level assignment, check individual parts
    configuration_register.complete_word = 32'h87654321;
    
    $display();
    $display("Test 3 - Word assignment breakdown:");
    $display("  Full word: 0x%08X", 
             configuration_register.complete_word);
    $display("  Flags field: 0x%02X", 
             configuration_register.register_fields.flags);
    $display("  Control field: 0x%02X", 
             configuration_register.register_fields.control_bits);
    $display("  Data field: 0x%04X", 
             configuration_register.register_fields.data_payload);
    
    $display();
    $display("Hello from register overlay testbench!");
    $display();

  end

endmodule