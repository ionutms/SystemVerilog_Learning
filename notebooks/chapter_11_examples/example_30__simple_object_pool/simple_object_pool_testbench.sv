// simple_object_pool_testbench.sv
module object_pool_test_bench;
  import object_pool_pkg::*;
  
  simple_object_pool pool;
  int handles[$];
  data_packet pkt_ref;
  
  initial begin
    // Dump waves
    $dumpfile("object_pool_test_bench.vcd");
    $dumpvars(0, object_pool_test_bench);
    
    $display("=== Simple Object Pool Test ===");
    $display();
    
    // Create object pool with 5 objects
    pool = new(5);
    pool.print_status();
    $display();
    
    // Test 1: Allocate several objects
    $display("--- Test 1: Allocating objects ---");
    for (int i = 0; i < 3; i++) begin
      int handle = pool.get_object();
      if (handle != 0) begin
        handles.push_back(handle);
        
        // Get reference and modify the object
        pkt_ref = pool.get_object_ref(handle);
        if (pkt_ref != null) begin
          pkt_ref.payload = $sformatf("Data_%0d", i);
          pkt_ref.timestamp = 32'($time + i * 10);
          $display("Modified: %s", pkt_ref.to_string());
        end
      end
    end
    pool.print_status();
    $display();
    
    // Test 2: Return some objects
    $display("--- Test 2: Returning objects ---");
    for (int i = 0; i < 2; i++) begin
      if (handles.size() > 0) begin
        int handle = handles.pop_front();
        if (!pool.return_object(handle)) begin
          $error("Failed to return object with handle %0d", handle);
        end
      end
    end
    pool.print_status();
    $display();
    
    // Test 3: Allocate more objects (should reuse returned ones)
    $display("--- Test 3: Re-allocating objects ---");
    for (int i = 0; i < 4; i++) begin
      int handle = pool.get_object();
      if (handle != 0) begin
        pkt_ref = pool.get_object_ref(handle);
        if (pkt_ref != null) begin
          pkt_ref.payload = $sformatf("Reused_%0d", i);
          pkt_ref.timestamp = 32'($time + i * 5);
          $display("Reused: %s", pkt_ref.to_string());
        end
        handles.push_back(handle);
      end
    end
    pool.print_status();
    $display();
    
    // Test 4: Try to exhaust the pool
    $display("--- Test 4: Pool exhaustion test ---");
    for (int i = 0; i < 3; i++) begin
      int handle = pool.get_object();
      if (handle == 0) begin
        $display("Pool exhausted as expected on attempt %0d", i + 1);
        break;
      end else begin
        $display("Unexpected allocation succeeded (handle=%0d)", handle);
        handles.push_back(handle);
      end
    end
    pool.print_status();
    $display();
    
    // Test 5: Invalid handle test
    $display("--- Test 5: Invalid handle test ---");
    if (!pool.return_object(999)) begin
      $display("Invalid handle correctly rejected");
    end
    
    pkt_ref = pool.get_object_ref(888);
    if (pkt_ref == null) begin
      $display("Invalid handle access correctly rejected");
    end
    $display();
    
    // Clean up - return all allocated objects
    $display("--- Cleanup: Returning all objects ---");
    while (handles.size() > 0) begin
      int handle = handles.pop_front();
      bit success = pool.return_object(handle);
      if (!success) begin
        $error("Failed to return object with handle %0d", handle);
      end
    end
    pool.print_status();
    
    $display();
    $display("=== Object Pool Test Complete ===");
    #10 $finish;
  end

endmodule