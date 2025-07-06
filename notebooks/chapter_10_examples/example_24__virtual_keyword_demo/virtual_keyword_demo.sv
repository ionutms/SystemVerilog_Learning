// virtual_keyword_demo.sv - Virtual keyword demonstration
package virtual_keyword_pkg;

  // Base class with both virtual and non-virtual methods
  class base_shape_class;
    string shape_type;
    
    function new(string name = "base_shape");
      shape_type = name;
    endfunction
    
    // Non-virtual method - will NOT be overridden in polymorphic calls
    function void display_info();
      $display("Base: This is a %s shape", shape_type);
    endfunction
    
    // Virtual method - CAN be overridden in polymorphic calls
    virtual function void draw_shape();
      $display("Base: Drawing generic shape");
    endfunction
    
    // Virtual method for calculating area
    virtual function real get_area();
      $display("Base: Generic area calculation");
      return 0.0;
    endfunction
    
    // Non-virtual method for identification
    function string get_class_name();
      return "base_shape_class";
    endfunction
  endclass

  // Derived class - Circle
  class circle_shape_class extends base_shape_class;
    real radius;
    
    function new(real r = 1.0);
      super.new("circle");
      radius = r;
    endfunction
    
    // Override non-virtual method (will only work with direct calls)
    function void display_info();
      $display("Circle: This is a %s with radius %.2f", shape_type, radius);
    endfunction
    
    // Override virtual method (will work with polymorphic calls)
    virtual function void draw_shape();
      $display("Circle: Drawing circle with radius %.2f", radius);
    endfunction
    
    // Override virtual method for area calculation
    virtual function real get_area();
      real area = 3.14159 * radius * radius;
      $display("Circle: Area = %.2f", area);
      return area;
    endfunction
    
    // Override non-virtual method
    function string get_class_name();
      return "circle_shape_class";
    endfunction
  endclass

  // Derived class - Rectangle
  class rectangle_shape_class extends base_shape_class;
    real width, height;
    
    function new(real w = 1.0, real h = 1.0);
      super.new("rectangle");
      width = w;
      height = h;
    endfunction
    
    // Override non-virtual method
    function void display_info();
      $display("Rectangle: This is a %s %.2fx%.2f", shape_type, width, height);
    endfunction
    
    // Override virtual method
    virtual function void draw_shape();
      $display("Rectangle: Drawing rectangle %.2fx%.2f", width, height);
    endfunction
    
    // Override virtual method for area calculation
    virtual function real get_area();
      real area = width * height;
      $display("Rectangle: Area = %.2f", area);
      return area;
    endfunction
    
    // Override non-virtual method
    function string get_class_name();
      return "rectangle_shape_class";
    endfunction
  endclass

  // Demonstration class to show polymorphism
  class shape_manager_class;
    base_shape_class shape_array[];
    circle_shape_class temp_circle;
    rectangle_shape_class temp_rect;
    
    function new();
      shape_array = new[3];
      shape_array[0] = new("generic");
      temp_circle = new(2.5);
      shape_array[1] = temp_circle;
      temp_rect = new(3.0, 4.0);
      shape_array[2] = temp_rect;
    endfunction
    
    // Demonstrate polymorphic behavior
    function void demonstrate_polymorphism();
      $display("\n=== POLYMORPHIC CALLS (using base class handle) ===");
      
      foreach(shape_array[i]) begin
        $display("\nShape %0d:", i);
        
        // Non-virtual method - always calls base class version
        $display("Non-virtual display_info():");
        shape_array[i].display_info();
        
        // Virtual method - calls appropriate derived class version
        $display("Virtual draw_shape():");
        shape_array[i].draw_shape();
        
        // Virtual method - calls appropriate derived class version
        $display("Virtual get_area():");
        void'(shape_array[i].get_area());
        
        // Non-virtual method - always calls base class version
        $display("Non-virtual get_class_name(): %s", 
                 shape_array[i].get_class_name());
      end
    endfunction
    
    // Demonstrate direct calls (non-polymorphic)
    function void demonstrate_direct_calls();
      circle_shape_class circle_handle;
      rectangle_shape_class rect_handle;
      
      $display("\n=== DIRECT CALLS (using specific class handles) ===");
      
      // Direct call to circle
      circle_handle = new(1.5);
      $display("\nDirect Circle calls:");
      circle_handle.display_info();        // Calls circle version
      circle_handle.draw_shape();          // Calls circle version
      void'(circle_handle.get_area());     // Calls circle version
      $display("Class name: %s", circle_handle.get_class_name());
      
      // Direct call to rectangle
      rect_handle = new(2.0, 3.5);
      $display("\nDirect Rectangle calls:");
      rect_handle.display_info();          // Calls rectangle version
      rect_handle.draw_shape();            // Calls rectangle version
      void'(rect_handle.get_area());       // Calls rectangle version
      $display("Class name: %s", rect_handle.get_class_name());
    endfunction
    
    // Show the difference clearly
    function void show_virtual_vs_nonvirtual();
      circle_shape_class specific_circle;
      base_shape_class generic_handle;
      
      $display("\n=== VIRTUAL vs NON-VIRTUAL COMPARISON ===");
      
      specific_circle = new(3.0);
      generic_handle = specific_circle;  // Polymorphic assignment
      
      $display("\nUsing specific circle handle:");
      specific_circle.display_info();    // Circle version
      specific_circle.draw_shape();      // Circle version
      
      $display("\nUsing base class handle (polymorphic):");
      generic_handle.display_info();     // Base version (non-virtual!)
      generic_handle.draw_shape();       // Circle version (virtual!)
      
      $display("\nKey difference:");
      $display("- Non-virtual methods use the handle's declared type");
      $display("- Virtual methods use the object's actual type");
    endfunction
  endclass

endpackage

// Design module
module virtual_keyword_demo_module;
  import virtual_keyword_pkg::*;
  
  shape_manager_class manager;
  
  initial begin
    $display("=== Virtual Keyword Demonstration ===");
    
    manager = new();
    
    // Show polymorphic behavior
    manager.demonstrate_polymorphism();
    
    // Show direct calls
    manager.demonstrate_direct_calls();
    
    // Show clear comparison
    manager.show_virtual_vs_nonvirtual();
    
    $display("\n=== Summary ===");
    $display("Virtual methods enable true polymorphism in SystemVerilog");
    $display("Non-virtual methods are resolved at compile time");
    $display("Virtual methods are resolved at runtime");
  end
endmodule