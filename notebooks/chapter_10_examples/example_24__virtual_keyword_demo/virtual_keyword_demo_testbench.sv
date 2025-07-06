// virtual_keyword_demo_testbench.sv
module virtual_keyword_testbench;
  import virtual_keyword_pkg::*;
  
  // Instantiate design under test
  virtual_keyword_demo_module DESIGN_INSTANCE();
  
  // Additional test scenarios
  base_shape_class shape_handle;
  circle_shape_class circle_obj;
  rectangle_shape_class rect_obj;
  
  initial begin
    // Setup for VCD dumping
    $dumpfile("virtual_keyword_testbench.vcd");
    $dumpvars(0, virtual_keyword_testbench);
    
    #1; // Wait for design to complete
    
    $display("\n============================================================");
    $display("TESTBENCH: Additional Virtual Keyword Tests");
    $display("============================================================");
    
    // Test 1: Dynamic type checking scenario
    test_dynamic_behavior();
    
    // Test 2: Method resolution demonstration
    test_method_resolution();
    
    // Test 3: Inheritance chain demonstration
    test_inheritance_chain();
    
    $display("\n============================================================");
    $display("TESTBENCH: All tests completed successfully!");
    $display("============================================================");
    
    #5; // Final wait
    $finish;
  end
  
  // Test dynamic behavior with different object types
  task test_dynamic_behavior();
    $display("\n--- Test 1: Dynamic Behavior ---");
    
    // Create different objects but use same handle type
    shape_handle = new();
    shape_handle.shape_type = "base";
    call_methods("Base object");
    
    circle_obj = new(2.0);
    shape_handle = circle_obj;
    call_methods("Circle object via base handle");
    
    rect_obj = new(1.5, 2.5);
    shape_handle = rect_obj;
    call_methods("Rectangle object via base handle");
  endtask
  
  // Helper task to call methods and show differences
  task call_methods(string description);
    $display("\n%s:", description);
    $display("  Non-virtual display_info(): ", $sformatf(""));
    shape_handle.display_info();
    $display("  Virtual draw_shape(): ", $sformatf(""));
    shape_handle.draw_shape();
    $display("  Virtual get_area(): %.2f", shape_handle.get_area());
    $display("  Non-virtual get_class_name(): %s", 
             shape_handle.get_class_name());
  endtask
  
  // Demonstrate method resolution rules
  task test_method_resolution();
    $display("\n--- Test 2: Method Resolution Rules ---");
    
    circle_obj = new(1.0);
    
    $display("\nDirect call (circle_obj.method()):");
    circle_obj.display_info();
    circle_obj.draw_shape();
    
    $display("\nPolymorphic call (base_handle.method()):");
    shape_handle = circle_obj;
    shape_handle.display_info();  // Uses base class (non-virtual)
    shape_handle.draw_shape();    // Uses circle class (virtual)
    
    $display("\nExplanation:");
    $display("- display_info() is non-virtual: uses handle's type");
    $display("- draw_shape() is virtual: uses object's actual type");
  endtask
  
  // Show inheritance method resolution
  task test_inheritance_chain();
    base_shape_class shapes[];
    circle_shape_class temp_circle;
    rectangle_shape_class temp_rect;
    
    $display("\n--- Test 3: Inheritance Chain ---");
    
    shapes = new[4];
    shapes[0] = new();
    shapes[0].shape_type = "base";
    
    temp_circle = new(1.0);
    shapes[1] = temp_circle;
    
    temp_rect = new(2.0, 2.0);
    shapes[2] = temp_rect;
    
    temp_circle = new(3.0);
    shapes[3] = temp_circle;
    
    $display("\nProcessing array of shapes:");
    foreach(shapes[i]) begin
      $display("\nShape[%0d] processing:", i);
      shapes[i].draw_shape();        // Virtual - calls correct version
      void'(shapes[i].get_area());   // Virtual - calls correct version
      $display("Handle type reports: %s", shapes[i].get_class_name());
    end
    
    $display("\nNote: All objects called through base_shape_class handle");
    $display("Virtual methods found correct implementation");
    $display("Non-virtual method always used base class version");
  endtask
  
endmodule