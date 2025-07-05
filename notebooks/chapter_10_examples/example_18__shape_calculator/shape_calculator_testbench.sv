// shape_calculator_testbench.sv
module shape_calculator_testbench;
  import shape_pkg::*;
  
  // Instantiate design under test
  shape_calculator_design DESIGN_INSTANCE();
  
  // Additional testbench verification
  initial begin
    ShapeCalculator test_calc;
    Circle test_circle;
    Rectangle test_rect;
    Triangle test_triangle;
    real expected_area, actual_area;
    
    // Dump waves
    $dumpfile("shape_calculator_testbench.vcd");
    $dumpvars(0, shape_calculator_testbench);
    
    #1; // Wait for design to complete
    
    $display("Hello from testbench!");
    $display("Running verification tests...");
    $display();
    
    // Test individual shape calculations
    test_circle = new(2.0);
    expected_area = 3.14159 * 2.0 * 2.0; // π * r²
    actual_area = test_circle.calculate_area();
    $display("Circle Test: Expected=%.2f, Actual=%.2f %s", 
             expected_area, actual_area, 
             (actual_area == expected_area) ? "PASS" : "FAIL");
    
    test_rect = new(3.0, 4.0);
    expected_area = 3.0 * 4.0; // width * height
    actual_area = test_rect.calculate_area();
    $display("Rectangle Test: Expected=%.2f, Actual=%.2f %s", 
             expected_area, actual_area, 
             (actual_area == expected_area) ? "PASS" : "FAIL");
    
    test_triangle = new(6.0, 2.0);
    expected_area = 0.5 * 6.0 * 2.0; // 0.5 * base * height
    actual_area = test_triangle.calculate_area();
    $display("Triangle Test: Expected=%.2f, Actual=%.2f %s", 
             expected_area, actual_area, 
             (actual_area == expected_area) ? "PASS" : "FAIL");
    
    $display();
    
    // Test mixed shape collection
    test_calc = new();
    test_calc.add_shape(test_circle);
    test_calc.add_shape(test_rect);
    test_calc.add_shape(test_triangle);
    
    expected_area = (3.14159 * 4.0) + 12.0 + 6.0; // Sum of all areas
    actual_area = test_calc.calculate_total_area();
    $display("Total Area Test: Expected=%.2f, Actual=%.2f %s", 
             expected_area, actual_area, 
             (actual_area == expected_area) ? "PASS" : "FAIL");
    
    $display();
    $display("Verification complete!");
    $display();
    
    #10;
    $finish;
  end
endmodule