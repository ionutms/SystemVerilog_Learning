// generic_data_container_testbench.sv
// Testbench for generic data storage container

module data_container_testbench;

  // Instantiate the design under test
  data_container_module CONTAINER_INSTANCE();

  // Additional test scenarios
  initial begin
    // Dump waves for debugging
    $dumpfile("data_container_testbench.vcd");
    $dumpvars(0, data_container_testbench);
    
    $display("\n=== Testbench: Additional Storage Operations ===");
    
    // Wait for initial operations to complete
    #100;
    
    // Test storage of additional data types
    CONTAINER_INSTANCE.store_string("project_id", "SV_Example_23");
    #5 CONTAINER_INSTANCE.store_bits("status_flags", 32'b10101010);
    #5 CONTAINER_INSTANCE.store_real("frequency", 100.5);
    
    // Display updated storage
    #10 CONTAINER_INSTANCE.display_storage();
    
    // Test storage limit (array is size 10)
    $display("\n=== Testing Storage Limit ===");
    CONTAINER_INSTANCE.store_integer("overflow_test", 999);
    CONTAINER_INSTANCE.store_integer("overflow_test2", 1000);
    
    #10 $display("\nTotal items stored: %0d", 
                 CONTAINER_INSTANCE.storage_count);
    
    #10 $finish;
  end

  // Monitor storage operations
  initial begin
    $monitor("Time %0t: Storage count = %0d", 
             $time, CONTAINER_INSTANCE.storage_count);
  end

endmodule