// nested_class_access_testbench.sv
module nested_class_testbench;
  import nested_class_pkg::*;
  
  // Test variables
  outer_processor_class processor1, processor2;
  outer_processor_class::inner_config_class standalone_config;
  outer_processor_class::inner_status_class status_ref;
  outer_processor_class::inner_processor_class proc_ref;
  
  initial begin
    // Dump waves
    $dumpfile("nested_class_testbench.vcd");
    $dumpvars(0, nested_class_testbench);
    
    $display("=== Nested Class Access Test ===");
    $display();
    
    // Create instances of outer class
    processor1 = new();
    processor2 = new();
    
    $display("--- Test 1: Basic Nested Class Access ---");
    processor1.demonstrate_access();
    $display();
    
    // Test accessing nested class through outer class
    $display("--- Test 2: External Access to Nested Class ---");
    standalone_config = new();
    standalone_config.set_config("external_config", 999);
    standalone_config.display_config();
    $display();
    
    // Test accessing nested class instance through outer class methods
    $display("--- Test 3: Access via Outer Class Methods ---");
    status_ref = processor2.get_status_obj();
    status_ref.set_status(8'hCC, "busy");
    status_ref.display_status();
    $display();
    
    // Demonstrate static member access
    $display("--- Test 4: Static Member Access ---");
    $display("Shared counter from processor1: %d", 
             processor1.shared_counter);
    $display("Shared counter from processor2: %d", 
             processor2.shared_counter);
    $display();
    
    // Test nested class arrays and multiple instances
    $display("--- Test 5: Multiple Nested Class Instances ---");
    test_multiple_instances();
    $display();
    
    // Common access patterns demonstration
    $display("--- Test 6: Common Access Patterns ---");
    demonstrate_access_patterns();
    
    $display("=== Test Complete ===");
    #10;
    $finish;
  end
  
  // Task to test multiple nested class instances
  task test_multiple_instances();
    outer_processor_class::inner_config_class config_list[3];
    outer_processor_class proc;
    
    proc = new();
    
    // Create multiple config instances
    for (int i = 0; i < 3; i++) begin
      config_list[i] = proc.create_config();
      config_list[i].set_config($sformatf("config_%0d", i), i * 10);
      config_list[i].display_config();
    end
    
    // Test processor with different data
    proc_ref = proc.get_processor();
    for (int i = 0; i < 5; i++) begin
      proc_ref.process_data(i * 100);
    end
    $display("Final process count: %0d", proc_ref.get_count());
  endtask
  
  // Task to demonstrate various access patterns
  task demonstrate_access_patterns();
    outer_processor_class proc;
    outer_processor_class::inner_config_class cfg;
    outer_processor_class::inner_status_class sts;
    
    proc = new();
    
    // Pattern 1: Direct access through outer class instance
    $display("Pattern 1 - Direct access through outer instance:");
    proc.config_obj.set_config("pattern1", 111);
    $display("  Config value: %0d", proc.config_obj.get_value());
    
    // Pattern 2: Get reference and use it
    $display("Pattern 2 - Via reference:");
    cfg = proc.get_config();
    cfg.set_config("pattern2", 222);
    $display("  Config value: %0d", cfg.get_value());
    
    // Pattern 3: Direct nested class instantiation
    $display("Pattern 3 - Direct instantiation:");
    cfg = new();
    cfg.set_config("pattern3", 333);
    $display("  Config value: %0d", cfg.get_value());
    
    // Pattern 4: Method chaining style access
    $display("Pattern 4 - Method chaining style:");
    sts = proc.get_status_obj();
    sts.set_status(8'hFF, "completed");
    $display("  Status flags: 0x%02x", sts.get_status());
    
    $display();
  endtask

endmodule