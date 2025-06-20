// memory_type_selector_testbench.sv
module memory_type_selector_testbench;
  
  // Test different memory types by instantiating multiple design modules
  
  // SRAM instance
  memory_type_selector #(.MEMORY_TYPE("SRAM")) SRAM_INSTANCE();
  
  // DRAM instance  
  memory_type_selector #(.MEMORY_TYPE("DRAM")) DRAM_INSTANCE();
  
  // FLASH instance
  memory_type_selector #(.MEMORY_TYPE("FLASH")) FLASH_INSTANCE();
  
  // Unknown type instance (will show error)
  memory_type_selector #(.MEMORY_TYPE("ROM")) UNKNOWN_INSTANCE();

  initial begin
    // Dump waves
    $dumpfile("memory_type_selector_testbench.vcd");
    $dumpvars(0, memory_type_selector_testbench);
    
    $display();
    $display("Testing Memory Type Selector with Generate If-Else");
    $display("====================================================");
    
    #1; // Allow time for all instances to execute
    
    $display();
    $display("=== Test Complete ===");
    $display("Check output to see different memory types selected");
    
    #1;
    $finish;
  end

endmodule