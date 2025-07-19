// transaction_copy_demo_testbench.sv - Testbench for Transaction Copy

module transaction_copy_testbench;
  import transaction_package::*;
  
  // Design instance
  transaction_copy_demo DESIGN_INSTANCE();
  
  initial begin
    // Setup VCD dumping
    $dumpfile("transaction_copy_testbench.vcd");
    $dumpvars(0, transaction_copy_testbench);
    
    // Test transaction copying
    test_basic_transaction_copy();
    test_transaction_independence();
    test_transaction_comparison();
    
    $display();
    $display("=== All Transaction Copy Tests Completed ===");
    $finish;
  end
  
  // Test basic transaction copy functionality
  task test_basic_transaction_copy();
    basic_transaction original_tx, copied_tx;
    
    $display("--- Test: Basic Transaction Copy ---");
    
    // Create original transaction
    original_tx = new(101, 250.75, "Purchase Order");
    original_tx.display("Original:  ");
    
    // Copy the transaction
    copied_tx = original_tx.copy();
    copied_tx.display("Copied:    ");
    
    // Verify they are equal
    if (original_tx.is_equal(copied_tx)) begin
      $display("✓ Copy successful - transactions are identical");
    end else begin
      $display("✗ Copy failed - transactions differ");
    end
    
    $display();
  endtask
  
  // Test that copied transactions are independent
  task test_transaction_independence();
    basic_transaction original_tx, copied_tx;
    
    $display("--- Test: Transaction Independence ---");
    
    // Create and copy transaction
    original_tx = new(202, 100.50, "Initial Payment");
    copied_tx = original_tx.copy();
    
    $display("Before modification:");
    original_tx.display("Original:  ");
    copied_tx.display("Copied:    ");
    
    // Modify original transaction
    original_tx.transaction_id = 999;
    original_tx.amount = 999.99;
    original_tx.description = "Modified Payment";
    
    $display("After modifying original:");
    original_tx.display("Original:  ");
    copied_tx.display("Copied:    ");
    
    // Verify independence
    if (!original_tx.is_equal(copied_tx)) begin
      $display("✓ Independence verified - copy unchanged");
    end else begin
      $display("✗ Independence failed - copy was affected");
    end
    
    $display();
  endtask
  
  // Test transaction comparison functionality
  task test_transaction_comparison();
    basic_transaction tx1, tx2, tx3;
    
    $display("--- Test: Transaction Comparison ---");
    
    // Create identical transactions
    tx1 = new(303, 75.25, "Service Fee");
    tx2 = new(303, 75.25, "Service Fee");
    
    // Create different transaction
    tx3 = new(404, 150.00, "Different Fee");
    
    $display("Comparing identical transactions:");
    tx1.display("TX1: ");
    tx2.display("TX2: ");
    
    if (tx1.is_equal(tx2)) begin
      $display("✓ Identical transactions correctly identified");
    end else begin
      $display("✗ Identical transactions not recognized");
    end
    
    $display("Comparing different transactions:");
    tx1.display("TX1: ");
    tx3.display("TX3: ");
    
    if (!tx1.is_equal(tx3)) begin
      $display("✓ Different transactions correctly identified");
    end else begin
      $display("✗ Different transactions incorrectly marked as equal");
    end
    
    $display();
  endtask

endmodule