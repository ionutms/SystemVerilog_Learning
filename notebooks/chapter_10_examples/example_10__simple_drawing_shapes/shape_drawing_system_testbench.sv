// shape_drawing_system_testbench.sv
module shape_drawing_testbench;
  import shape_drawing_pkg::*;
  
  // Instantiate design under test
  shape_drawing_system DESIGN_INSTANCE();
  
  // Additional testbench functionality
  Shape test_shape;
  Circle test_circle;
  Square test_square;
  Triangle test_triangle;
  
  initial begin
    // Setup VCD dumping
    $dumpfile("shape_drawing_testbench.vcd");
    $dumpvars(0, shape_drawing_testbench);
    
    #10; // Wait for design to complete
    
    $display("=== Testbench: Individual Shape Testing ===");
    $display();
    
    // Test individual shape creation and drawing
    $display("--- Testing Circle Creation ---");
    test_circle = new(1);
    test_circle.draw();
    
    $display("--- Testing Square Creation ---");
    test_square = new(4);
    test_square.draw();
    
    $display("--- Testing Triangle Creation ---");
    test_triangle = new(5);
    test_triangle.draw();
    
    // Test polymorphic behavior
    $display("--- Testing Polymorphic Behavior ---");
    test_shape = ShapeFactory::create_shape("circle", 3);
    if (test_shape != null) begin
      $display("Shape info: %s", test_shape.get_info());
      test_shape.draw();
    end
    
    test_shape = ShapeFactory::create_shape("square", 2);
    if (test_shape != null) begin
      $display("Shape info: %s", test_shape.get_info());
      test_shape.draw();
    end
    
    test_shape = ShapeFactory::create_shape("triangle", 3);
    if (test_shape != null) begin
      $display("Shape info: %s", test_shape.get_info());
      test_shape.draw();
    end
    
    // Test error handling
    $display("--- Testing Error Handling ---");
    test_shape = ShapeFactory::create_shape("pentagon", 3);
    if (test_shape == null) begin
      $display("Successfully handled unknown shape type");
    end
    
    $display();
    $display("=== Testbench completed successfully! ===");
    $display();
    
    #10; // Small delay before finish
    $finish(0);  // Clean exit
  end

endmodule