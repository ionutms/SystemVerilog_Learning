// basic_handle_demo_testbench.sv
module test_bench_module;
  // Class handle declarations at module level
  handle_demo_pkg::BasicObject handle_a;
  handle_demo_pkg::BasicObject handle_b;
  
  // Instantiate design under test
  basic_handle_demo_module DESIGN_INSTANCE_NAME();
  
  initial begin
    // Dump waves
    $dumpfile("test_bench_module.vcd");
    $dumpvars(0, test_bench_module);
    
    #1; // Wait for design to complete
    
    $display();
    $display("=== Additional Handle Tests from Testbench ===");
    $display();
    
    // Additional demonstration: Creating separate objects
    
    handle_a = new("object_A", 100);
    handle_b = new("object_B", 200);
    
    $display("Created two separate objects:");
    handle_a.display();
    handle_b.display();
    $display();
    
    // Now assign one handle to another
    $display("Before assignment: handle_a points to object_A");
    handle_a.display();
    
    handle_a = handle_b; // Now both point to object_B
    
    $display("After assignment (handle_a = handle_b):");
    $display("handle_a now points to:");
    handle_a.display();
    $display("handle_b still points to:");
    handle_b.display();
    $display("Both handles reference same object? %s",
             (handle_a === handle_b) ? "YES" : "NO");
    
    $display();
    $display("=== Handle Demo Complete ===");
    
    #10;
    $finish;
  end

endmodule : test_bench_module