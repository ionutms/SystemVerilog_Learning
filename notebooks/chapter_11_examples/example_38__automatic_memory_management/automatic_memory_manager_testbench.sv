// automatic_memory_manager_testbench.sv
module memory_management_testbench;
  import memory_pkg::*;
  
  automatic_memory_manager MEMORY_MANAGER_INSTANCE();
  
  initial begin
    // Dump waves
    $dumpfile("memory_management_testbench.vcd");
    $dumpvars(0, memory_management_testbench);
    
    $display("=== Automatic Memory Management Simulation ===");
    $display("(SystemVerilog doesn't have true GC - simulating behavior)");
    $display();
    
    // Test 1: Manual memory management with tracking
    $display("Test 1: Object lifecycle with cleanup tracking");
    begin
      managed_data obj1, obj2, obj3;
      
      obj1 = new(100);
      obj2 = new(200);
      obj3 = new(300);
      
      managed_data::show_memory_stats();
      
      $display("Accessing objects before cleanup:");
      $display("obj1 value: %0d", obj1.get_value());
      $display("obj2 value: %0d", obj2.get_value());
      
      // Simulate automatic cleanup when references go out of scope
      $display("Simulating automatic cleanup...");
      obj1.cleanup();
      obj2.cleanup();
      
      managed_data::show_memory_stats();
      
      // Try to access cleaned object
      $display("Trying to access cleaned object:");
      void'(obj1.get_value());  // Should show warning
      
      obj3.cleanup();  // Clean remaining object
      managed_data::show_memory_stats();
    end
    $display();
    
    // Test 2: Smart container with automatic cleanup
    $display("Test 2: Smart container automatic cleanup");
    begin
      smart_container container;
      container = new();
      
      container.add_object(10);
      container.add_object(20);
      container.add_object(30);
      
      container.display_active_objects();
      managed_data::show_memory_stats();
      
      // Simulate container going out of scope - auto cleanup
      container.auto_cleanup();
      container.display_active_objects();
      managed_data::show_memory_stats();
    end
    $display();
    
    // Test 3: RAII-style resource management
    $display("Test 3: RAII-style resource management");
    begin
      resource_manager mgr1, mgr2;
      mgr1 = new("DatabaseManager");
      mgr2 = new("FileManager");
      
      // Acquire resources
      void'(mgr1.acquire_resource(1001));
      void'(mgr1.acquire_resource(1002));
      void'(mgr2.acquire_resource(2001));
      
      managed_data::show_memory_stats();
      
      // Simulate managers going out of scope
      $display("Simulating scope exit - automatic resource cleanup:");
      mgr1.release_all_resources();
      mgr2.release_all_resources();
      
      managed_data::show_memory_stats();
    end
    $display();
    
    // Test 4: Scope-based cleanup simulation
    $display("Test 4: Scope-based cleanup simulation");
    begin
      managed_data outer_ref;
      
      begin : inner_scope
        managed_data inner_obj1, inner_obj2;
        inner_obj1 = new(500);
        inner_obj2 = new(600);
        outer_ref = inner_obj1;  // Keep reference outside scope
        
        $display("Inside inner scope:");
        managed_data::show_memory_stats();
        
        // Simulate end of scope - cleanup local objects
        $display("Simulating end of inner scope:");
        inner_obj2.cleanup();  // inner_obj1 kept alive by outer_ref
      end : inner_scope
      
      $display("After inner scope exit:");
      managed_data::show_memory_stats();
      $display("outer_ref still valid: %0b, value: %0d", 
               outer_ref.is_object_valid(), outer_ref.get_value());
      
      // Final cleanup
      outer_ref.cleanup();
      $display("After final cleanup:");
      managed_data::show_memory_stats();
    end
    $display();
    
    // Test 5: Batch cleanup demonstration
    $display("Test 5: Simulating automatic batch cleanup");
    begin
      managed_data batch_objects[];
      batch_objects = new[5];
      
      // Create batch of objects
      for (int i = 0; i < 5; i++) begin
        batch_objects[i] = new(i * 100);
      end
      
      $display("Created batch of objects:");
      managed_data::show_memory_stats();
      
      // Simulate automatic cleanup when array goes out of scope
      $display("Simulating batch cleanup (like array destructor):");
      foreach(batch_objects[i]) begin
        if(batch_objects[i] != null) begin
          batch_objects[i].cleanup();
        end
      end
      batch_objects.delete();
      
      managed_data::show_memory_stats();
    end
    $display();
    
    $display("=== Memory Management Simulation Complete ===");
    $display("Note: In real automatic GC, cleanup would be implicit");
    
    #10;
    $finish;
  end

endmodule