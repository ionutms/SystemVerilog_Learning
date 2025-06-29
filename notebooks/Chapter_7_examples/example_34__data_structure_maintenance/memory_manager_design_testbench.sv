// memory_manager_design_testbench.sv
module memory_manager_testbench;

  // Instantiate the design under test
  memory_manager_design MEMORY_MANAGER_INSTANCE();

  initial begin
    // Setup waveform dumping
    $dumpfile("memory_manager_testbench.vcd");
    $dumpvars(0, memory_manager_testbench);
    
    $display("=== Chapter 7 Example 34: Data Structure Maintenance ===");
    $display("Testing void functions for memory manager consistency");
    $display();
    
    // Wait for design to complete its operations
    #100;
    
    $display();
    $display("=== Additional Testbench Operations ===");
    
    // Test bulk allocation scenario
    test_bulk_memory_operations();
    
    // Test consistency recovery
    test_consistency_recovery();
    
    #10;
    $display();
    $display("Testbench completed successfully!");
    $finish;
  end

  // Task: Test bulk memory operations
  task test_bulk_memory_operations();
    int operation_count;
    
    $display("\n--- Testing Bulk Operations ---");
    
    // Simulate multiple allocations
    for (operation_count = 10; operation_count < 16; operation_count++) begin
      MEMORY_MANAGER_INSTANCE.allocate_memory_block(operation_count[3:0]);
      #1;
    end
    
    // Simulate some deallocations
    for (operation_count = 12; operation_count < 15; operation_count++) begin
      MEMORY_MANAGER_INSTANCE.deallocate_memory_block(operation_count[3:0]);
      #1;
    end
    
    $display("Bulk operations completed");
  endtask

  // Task: Test consistency recovery mechanisms
  task test_consistency_recovery();
    $display("\n--- Testing Consistency Recovery ---");
    
    // Force an inconsistency (simulate corruption)
    $display("Simulating data corruption...");
    force MEMORY_MANAGER_INSTANCE.free_block_count = 5'd20;  // Invalid value
    
    #1;
    
    // Trigger consistency check through allocation
    MEMORY_MANAGER_INSTANCE.allocate_memory_block(4'h1);
    
    // Release the force
    release MEMORY_MANAGER_INSTANCE.free_block_count;
    
    $display("Consistency recovery test completed");
  endtask

endmodule