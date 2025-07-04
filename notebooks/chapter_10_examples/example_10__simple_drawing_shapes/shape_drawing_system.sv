// shape_drawing_system.sv
package shape_drawing_pkg;

  // Base Shape class with virtual draw method
  virtual class Shape;
    protected string shape_name;
    protected int size;
    
    // Constructor
    function new(string name = "Shape", int s = 3);
      shape_name = name;
      size = s;
    endfunction
    
    // Virtual method to be overridden by derived classes
    pure virtual function void draw();
    
    // Get shape information
    function string get_info();
      return $sformatf("%s (size: %0d)", shape_name, size);
    endfunction
  endclass

  // Circle class - draws ASCII circle
  class Circle extends Shape;
    
    function new(int s = 3);
      super.new("Circle", s);
    endfunction
    
    // Override draw method for circle
    virtual function void draw();
      $display("Drawing %s:", get_info());
      case (size)
        1: begin
          $display("  o");
        end
        2: begin
          $display("  ##");
          $display("  ##");
        end
        3: begin
          $display("  ###");
          $display(" #   #");
          $display("  ###");
        end
        default: begin
          $display("  #####");
          $display(" #     #");
          $display("#       #");
          $display(" #     #");
          $display("  #####");
        end
      endcase
      $display();
    endfunction
  endclass

  // Square class - draws ASCII square
  class Square extends Shape;
    
    function new(int s = 3);
      super.new("Square", s);
    endfunction
    
    // Override draw method for square
    virtual function void draw();
      $display("Drawing %s:", get_info());
      for (int i = 0; i < size; i++) begin
        for (int j = 0; j < size; j++) begin
          $write("# ");
        end
        $display();
      end
      $display();
    endfunction
  endclass

  // Triangle class - draws ASCII triangle
  class Triangle extends Shape;
    
    function new(int s = 3);
      super.new("Triangle", s);
    endfunction
    
    // Override draw method for triangle
    virtual function void draw();
      $display("Drawing %s:", get_info());
      for (int i = 0; i < size; i++) begin
        // Add spaces for centering
        for (int j = 0; j < size - i - 1; j++) begin
          $write(" ");
        end
        // Draw triangle pattern
        for (int k = 0; k <= i; k++) begin
          $write("# ");
        end
        $display();
      end
      $display();
    endfunction
  endclass

  // Shape factory class to create different shapes
  class ShapeFactory;
    
    static function Shape create_shape(string shape_type, int size = 3);
      case (shape_type.tolower())
        "circle": begin
          Circle c = new(size);
          return c;
        end
        "square": begin
          Square s = new(size);
          return s;
        end
        "triangle": begin
          Triangle t = new(size);
          return t;
        end
        default: begin
          $display("Warning: Unknown shape type: %s", shape_type);
          return null;
        end
      endcase
    endfunction
  endclass

endpackage

// Design module using the shape drawing system
module shape_drawing_system;
  import shape_drawing_pkg::*;
  
  // Array of shapes for polymorphic demonstration
  Shape shapes[];
  
  initial begin
    $display("=== Simple Drawing Shapes Example ===");
    $display();
    
    // Create array of different shapes
    shapes = new[6];
    shapes[0] = ShapeFactory::create_shape("circle", 2);
    shapes[1] = ShapeFactory::create_shape("square", 3);
    shapes[2] = ShapeFactory::create_shape("triangle", 4);
    shapes[3] = ShapeFactory::create_shape("circle", 3);
    shapes[4] = ShapeFactory::create_shape("square", 2);
    shapes[5] = ShapeFactory::create_shape("triangle", 3);
    
    // Draw all shapes using polymorphism
    foreach (shapes[i]) begin
      if (shapes[i] != null) begin
        shapes[i].draw();
      end
    end
    
    $display("=== All shapes drawn successfully! ===");
    $finish(0);  // Clean exit
  end

endmodule