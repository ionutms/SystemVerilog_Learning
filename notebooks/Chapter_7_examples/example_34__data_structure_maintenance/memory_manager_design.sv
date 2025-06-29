// memory_manager_design.sv
module memory_manager_design;
  
  // Internal data structures
  logic [7:0] memory_blocks [0:15];     // Memory block array
  logic [4:0] free_block_count;         // Number of free blocks (5 bits for 0-16)
  logic [15:0] allocation_bitmap;       // Bitmap for allocated blocks
  
  // Initialize memory manager
  initial begin
    initialize_memory_structures();
    
    // Demonstrate allocation and deallocation
    $display("=== Memory Manager Data Structure Maintenance ===");
    display_memory_status();
    
    // Allocate some blocks
    allocate_memory_block(4'h2);
    allocate_memory_block(4'h5);
    allocate_memory_block(4'h8);
    
    // Deallocate a block
    deallocate_memory_block(4'h5);
    
    // Try invalid operations
    allocate_memory_block(4'h2);  // Already allocated
    deallocate_memory_block(4'hF); // Invalid address
  end
  
  // Void function: Initialize all memory data structures
  function automatic void initialize_memory_structures();
    int block_index;
    
    $display("Initializing memory data structures...");
    
    // Clear all memory blocks
    for (block_index = 0; block_index < 16; block_index++) begin
      memory_blocks[block_index] = 8'h00;
    end
    
    // Reset allocation tracking
    free_block_count = 5'd16;
    allocation_bitmap = 16'h0000;
    
    // Ensure data consistency
    validate_data_consistency();
    $display("Memory structures initialized successfully");
  endfunction
  
  // Void function: Allocate a memory block and maintain consistency
  function automatic void allocate_memory_block(input logic [3:0] block_address);
    $display("\nAllocating block %0d...", block_address);
    
    // Check if block is already allocated
    if (allocation_bitmap[block_address] == 1'b1) begin
      $display("ERROR: Block %0d already allocated!", block_address);
      return;
    end
    
    // Perform allocation
    allocation_bitmap[block_address] = 1'b1;
    memory_blocks[block_address] = 8'hAA;  // Mark as allocated
    free_block_count--;
    
    // Maintain data structure consistency
    update_allocation_tracking();
    display_memory_status();
  endfunction
  
  // Void function: Deallocate a memory block and maintain consistency  
  function automatic void deallocate_memory_block(input logic [3:0] block_address);
    $display("\nDeallocating block %0d...", block_address);
    
    // Note: block_address is 4-bit, so it's always 0-15, no need to check
    // Check if block is actually allocated
    if (allocation_bitmap[block_address] == 1'b0) begin
      $display("ERROR: Block %0d not allocated!", block_address);
      return;
    end
    
    // Perform deallocation
    allocation_bitmap[block_address] = 1'b0;
    memory_blocks[block_address] = 8'h00;  // Clear block
    free_block_count++;
    
    // Maintain data structure consistency
    update_allocation_tracking();
    display_memory_status();
  endfunction
  
  // Void function: Update internal allocation tracking structures
  function automatic void update_allocation_tracking();
    // Recalculate free block count for consistency check
    logic [4:0] calculated_free_count = 0;  // 5 bits to hold 0-16
    int block_index;
    
    for (block_index = 0; block_index < 16; block_index++) begin
      if (allocation_bitmap[block_index] == 1'b0) begin
        calculated_free_count++;
      end
    end
    
    // Verify consistency
    if (calculated_free_count != free_block_count) begin
      $display("WARNING: Inconsistent free count detected!");
      $display("  Expected: %0d, Calculated: %0d", 
               free_block_count, calculated_free_count);
      free_block_count = calculated_free_count;  // Correct it
    end
    
    validate_data_consistency();
  endfunction
  
  // Void function: Validate overall data structure consistency
  function automatic void validate_data_consistency();
    int block_index;
    automatic logic consistency_ok = 1'b1;
    
    // Check memory blocks match bitmap
    for (block_index = 0; block_index < 16; block_index++) begin
      if (allocation_bitmap[block_index] == 1'b1) begin
        if (memory_blocks[block_index] != 8'hAA) begin
          $display("ERROR: Block %0d bitmap/memory mismatch!", block_index);
          consistency_ok = 1'b0;
        end
      end else begin
        if (memory_blocks[block_index] != 8'h00) begin
          $display("ERROR: Block %0d should be cleared!", block_index);
          consistency_ok = 1'b0;
        end
      end
    end
    
    if (consistency_ok) begin
      $display("Data structure consistency: PASS");
    end else begin
      $display("Data structure consistency: FAIL");
    end
  endfunction
  
  // Void function: Display current memory manager status
  function automatic void display_memory_status();
    $display("Memory Status: Free blocks = %0d/16", free_block_count);
    $display("Allocation bitmap: 0x%04h", allocation_bitmap);
  endfunction

endmodule