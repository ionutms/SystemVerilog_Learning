// array_type_shortcuts_testbench.sv
module memory_controller_testbench;

  // Reuse the same type shortcuts in testbench for consistency
  typedef logic [7:0] byte_data_type;
  typedef byte_data_type memory_word_array_type [0:15];
  typedef logic [31:0] address_bus_type [0:7];
  typedef struct packed {
    logic valid;
    logic [2:0] priority_level;
    logic [3:0] channel_id;
  } control_packet_type;
  typedef control_packet_type packet_buffer_type [0:3];

  // Testbench arrays using type shortcuts
  memory_word_array_type expected_cache_data;      // Expected results
  memory_word_array_type actual_cache_data;        // Actual results
  address_bus_type reference_addresses;            // Reference addresses
  packet_buffer_type test_packet_sequence;         // Test packets

  // Instantiate design under test
  memory_controller_design MEMORY_CTRL_INSTANCE();

  initial begin
    // Configure wave dumping
    $dumpfile("memory_controller_testbench.vcd");
    $dumpvars(0, memory_controller_testbench);
    
    #1; // Wait for design initialization
    
    $display();
    $display("Testbench: Array Type Shortcuts Verification");
    $display("============================================");
    
    // Initialize testbench arrays using type shortcuts
    for (int i = 0; i < 16; i++) begin
      expected_cache_data[i] = 8'(i * 16);      // Expected cache values
      actual_cache_data[i] = 8'(i * 16);        // Simulate actual values
    end
    
    for (int j = 0; j < 8; j++) begin
      reference_addresses[j] = 32'h1000 + (j * 4); // Reference sequence
    end
    
    for (int k = 0; k < 4; k++) begin
      test_packet_sequence[k].valid = (k % 2 == 0); // Alternate validity
      test_packet_sequence[k].priority_level = 3'(7 - k); // Descending priority
      test_packet_sequence[k].channel_id = 4'(k * 2);     // Even channel IDs
    end
    
    // Verify using type shortcuts makes code cleaner
    $display("Expected cache[4:7]: %h %h %h %h",
             expected_cache_data[4], expected_cache_data[5],
             expected_cache_data[6], expected_cache_data[7]);
    $display("Reference addr[4:7]: %h %h %h %h",
             reference_addresses[4], reference_addresses[5],
             reference_addresses[6], reference_addresses[7]);
    
    // Test packet verification
    for (int p = 0; p < 4; p++) begin
      $display("Test packet[%0d] - Valid:%b Priority:%d Channel:%d", p,
               test_packet_sequence[p].valid, test_packet_sequence[p].priority_level,
               test_packet_sequence[p].channel_id);
    end
    
    $display();
    $display("Benefits of array type shortcuts:");
    $display("- Consistent type definitions across modules");
    $display("- Reduced code duplication and errors");
    $display("- Easier maintenance and modifications");
    $display("- Improved code readability");
    $display();
    
  end

endmodule