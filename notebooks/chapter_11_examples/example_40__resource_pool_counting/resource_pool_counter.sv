// resource_pool_counter.sv
package resource_pool_pkg;

  // Simple resource class with reference counting
  class managed_resource;
    int resource_id;
    int ref_count;
    bit in_use;
    
    function new(int id);
      this.resource_id = id;
      this.ref_count = 0;
      this.in_use = 0;
    endfunction
    
    function void acquire();
      this.ref_count++;
      this.in_use = 1;
      $display("Resource %0d acquired, ref_count: %0d", 
               resource_id, ref_count);
    endfunction
    
    function void release_ref();
      if (ref_count > 0) begin
        ref_count--;
        $display("Resource %0d released, ref_count: %0d", 
                 resource_id, ref_count);
        if (ref_count == 0) begin
          in_use = 0;
          $display("Resource %0d returned to pool", resource_id);
        end
      end else begin
        $display("Warning: Resource %0d already at zero refs", resource_id);
      end
    endfunction
  endclass

  // Resource pool with counting management
  class resource_pool;
    managed_resource pool[$];
    int pool_size;
    int next_id;
    
    function new(int size = 4);
      this.pool_size = size;
      this.next_id = 1;
      
      // Initialize pool with resources
      for (int i = 0; i < size; i++) begin
        managed_resource res = new(next_id++);
        pool.push_back(res);
      end
      $display("Resource pool initialized with %0d resources", size);
    endfunction
    
    function managed_resource get_resource();
      // Find available resource (not in use)
      foreach (pool[i]) begin
        if (!pool[i].in_use) begin
          pool[i].acquire();
          return pool[i];
        end
      end
      
      $display("Warning: No available resources in pool");
      return null;
    endfunction
    
    function void return_resource(ref managed_resource res);
      if (res != null) begin
        res.release_ref();
        res = null;  // Clear reference
      end
    endfunction
    
    function void show_pool_status();
      $display("\n=== Pool Status ===");
      foreach (pool[i]) begin
        $display("Resource %0d: in_use=%0b, ref_count=%0d", 
                 pool[i].resource_id, pool[i].in_use, pool[i].ref_count);
      end
      $display("==================\n");
    endfunction
  endclass

endpackage

module resource_pool_counter_design;
  import resource_pool_pkg::*;
  
  resource_pool pool;
  managed_resource res1, res2, res3, res4;
  
  initial begin
    $display("=== Resource Pool with Counting Demo ===\n");
    
    // Create resource pool
    pool = new(3);
    pool.show_pool_status();
    
    // Acquire some resources
    $display("--- Acquiring resources ---");
    res1 = pool.get_resource();
    res2 = pool.get_resource();
    res3 = pool.get_resource();
    pool.show_pool_status();
    
    // Try to acquire when pool is empty
    $display("--- Trying to acquire from empty pool ---");
    res4 = pool.get_resource();
    
    // Simulate multiple references to same resource
    $display("\n--- Multiple references to resource 1 ---");
    if (res1 != null) begin
      res1.acquire();  // Second reference
      res1.acquire();  // Third reference
    end
    pool.show_pool_status();
    
    // Release references gradually
    $display("--- Releasing references ---");
    pool.return_resource(res2);
    pool.show_pool_status();
    
    if (res1 != null) begin
      res1.release_ref();  // Still has 2 refs
      res1.release_ref();  // Still has 1 ref
      pool.return_resource(res1);  // Now back to pool
    end
    pool.show_pool_status();
    
    pool.return_resource(res3);
    pool.show_pool_status();
    
    $display("=== Demo Complete ===");
  end

endmodule