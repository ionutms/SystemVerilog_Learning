// shape_calculator.sv
package shape_pkg;

  // Base abstract shape class
  virtual class Shape;
    pure virtual function real calculate_area();
    pure virtual function string get_name();
  endclass

  // Circle class
  class Circle extends Shape;
    real radius;
    
    function new(real r);
      radius = r;
    endfunction
    
    virtual function real calculate_area();
      return 3.14159 * radius * radius;
    endfunction
    
    virtual function string get_name();
      return "Circle";
    endfunction
  endclass

  // Rectangle class
  class Rectangle extends Shape;
    real width, height;
    
    function new(real w, real h);
      width = w;
      height = h;
    endfunction
    
    virtual function real calculate_area();
      return width * height;
    endfunction
    
    virtual function string get_name();
      return "Rectangle";
    endfunction
  endclass

  // Triangle class
  class Triangle extends Shape;
    real base, height;
    
    function new(real b, real h);
      base = b;
      height = h;
    endfunction
    
    virtual function real calculate_area();
      return 0.5 * base * height;
    endfunction
    
    virtual function string get_name();
      return "Triangle";
    endfunction
  endclass

  // Shape calculator class
  class ShapeCalculator;
    Shape shape_collection[];
    int shape_count;
    
    function new();
      shape_count = 0;
    endfunction
    
    function void add_shape(Shape s);
      shape_collection = new[shape_count + 1](shape_collection);
      shape_collection[shape_count] = s;
      shape_count++;
    endfunction
    
    function real calculate_total_area();
      real total = 0.0;
      for (int i = 0; i < shape_count; i++) begin
        total += shape_collection[i].calculate_area();
      end
      return total;
    endfunction
    
    function void display_shapes();
      $display("Shape Collection:");
      $display("================");
      for (int i = 0; i < shape_count; i++) begin
        $display("%0d. %s - Area: %.2f", i+1, 
                 shape_collection[i].get_name(),
                 shape_collection[i].calculate_area());
      end
      $display("================");
      $display("Total Area: %.2f", calculate_total_area());
    endfunction
  endclass

endpackage

module shape_calculator_design;
  import shape_pkg::*;
  
  initial begin
    ShapeCalculator calc;
    Circle circle1, circle2;
    Rectangle rect1, rect2;
    Triangle triangle1;
    
    $display();
    $display("Basic Shape Calculator Example");
    $display("==============================");
    
    // Create calculator instance
    calc = new();
    
    // Create various shapes
    circle1 = new(5.0);    // radius = 5.0
    circle2 = new(3.0);    // radius = 3.0
    rect1 = new(4.0, 6.0); // width = 4.0, height = 6.0
    rect2 = new(2.5, 8.0); // width = 2.5, height = 8.0
    triangle1 = new(6.0, 4.0);  // base = 6.0, height = 4.0
    
    // Add shapes to calculator
    calc.add_shape(circle1);
    calc.add_shape(rect1);
    calc.add_shape(triangle1);
    calc.add_shape(circle2);
    calc.add_shape(rect2);
    
    // Display all shapes and total area
    calc.display_shapes();
    
    $display();
    $display("Polymorphic area calculation completed!");
    $display();
  end
endmodule