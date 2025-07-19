// message_copy_system_testbench.sv
// Testbench for simple message copy system demonstrating copy constructors

module message_copy_testbench;
  import message_copy_pkg::*;

  // Test variables
  simple_message_class test_messages[$];
  simple_message_class msg1, msg2, msg3, msg4;
  int test_count = 0;
  int pass_count = 0;

  // Instantiate the design under test
  message_copy_system MESSAGE_COPY_INSTANCE();

  initial begin
    // Dump waves for Verilator
    $dumpfile("message_copy_testbench.vcd");
    $dumpvars(0, message_copy_testbench);

    $display("\n=== Message Copy System Testbench ===\n");
    
    // Test 1: Basic message creation and copy
    test_message_creation_and_copy();
    
    #20; // Wait between tests
    
    // Test 2: Multiple copies from same original
    test_multiple_copies();
    
    #20; // Wait between tests
    
    // Test 3: Copy chain (copy of copy)
    test_copy_chain();
    
    #20; // Wait between tests
    
    // Test 4: Message queue with copies
    test_message_queue();
    
    // Final results
    $display("\n=== Testbench Results ===");
    $display("Tests run: %0d", test_count);
    $display("Tests passed: %0d", pass_count);
    if (pass_count == test_count) begin
      $display("All tests PASSED!");
    end else begin
      $display("Some tests FAILED!");
    end
    $display("=== Testbench Complete ===\n");
    
    $finish;
  end

  // Test 1: Basic message creation and copy functionality
  task automatic test_message_creation_and_copy();
    $display("TEST 1: Basic message creation and copy");
    test_count++;
    
    // Create original message
    msg1 = new("Test message for copying");
    
    // Create copy
    msg2 = msg1.copy();
    
    // Verify content matches
    if (msg1.get_content() == msg2.get_content()) begin
      $display("PASS: Content matches between original and copy");
      pass_count++;
    end else begin
      $display("FAIL: Content mismatch between original and copy");
    end
    
    // Verify different IDs
    if (msg1.get_id() != msg2.get_id()) begin
      $display("PASS: Original and copy have different IDs");
    end else begin
      $display("FAIL: Original and copy have same ID");
    end
    
    $display("");
  endtask

  // Test 2: Multiple copies from same original
  task automatic test_multiple_copies();
    simple_message_class copy1, copy2, deep_copy1;
    
    $display("TEST 2: Multiple copies from same original");
    test_count++;
    
    // Create original
    msg3 = new("Original for multiple copies");
    
    // Create multiple copies
    copy1 = msg3.copy();
    copy2 = msg3.copy();
    deep_copy1 = msg3.deep_copy();
    
    // Verify all have same content as original
    if (msg3.get_content() == copy1.get_content() && 
        msg3.get_content() == copy2.get_content()) begin
      $display("PASS: All shallow copies have same content as original");
      pass_count++;
    end else begin
      $display("FAIL: Shallow copies don't match original content");
    end
    
    // Verify deep copy has modified content
    if (deep_copy1.get_content() != msg3.get_content()) begin
      $display("PASS: Deep copy has different content than original");
    end else begin
      $display("FAIL: Deep copy content matches original");
    end
    
    $display("");
  endtask

  // Test 3: Copy chain (copy of copy)
  task automatic test_copy_chain();
    simple_message_class chain1, chain2, chain3;
    
    $display("TEST 3: Copy chain (copy of copy)");
    test_count++;
    
    // Create chain of copies
    msg4 = new("Chain original message");
    chain1 = msg4.copy();
    chain2 = chain1.copy();
    chain3 = chain2.deep_copy();
    
    // Verify content propagation through chain
    if (msg4.get_content() == chain1.get_content() && 
        chain1.get_content() == chain2.get_content()) begin
      $display("PASS: Content preserved through copy chain");
      pass_count++;
    end else begin
      $display("FAIL: Content not preserved through copy chain");
    end
    
    // Display chain information
    $display("Copy chain timestamps:");
    $display("  Original: %0d", msg4.get_timestamp());
    $display("  Chain1:   %0d", chain1.get_timestamp());
    $display("  Chain2:   %0d", chain2.get_timestamp());
    $display("  Chain3:   %0d", chain3.get_timestamp());
    
    $display("");
  endtask

  // Test 4: Message queue with copies
  task automatic test_message_queue();
    simple_message_class temp_msg;
    
    $display("TEST 4: Message queue with copies");
    test_count++;
    
    // Create messages and add to queue
    for (int i = 0; i < 3; i++) begin
      temp_msg = new($sformatf("Message %0d", i+1));
      test_messages.push_back(temp_msg.copy());
      #2; // Small delay between messages
    end
    
    // Verify queue contents
    if (test_messages.size() == 3) begin
      $display("PASS: Queue contains expected number of messages");
      pass_count++;
    end else begin
      $display("FAIL: Queue size mismatch");
    end
    
    // Display queue contents
    $display("Message queue contents:");
    for (int i = 0; i < test_messages.size(); i++) begin
      $display("  [%0d] ID:%0d, Content:'%s', Time:%0d", 
               i, test_messages[i].get_id(), 
               test_messages[i].get_content(),
               test_messages[i].get_timestamp());
    end
    
    $display("");
  endtask

endmodule