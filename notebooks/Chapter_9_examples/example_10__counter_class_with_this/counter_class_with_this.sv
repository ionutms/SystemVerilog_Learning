// counter_class_with_this.sv

// Package containing the Counter class
package counter_pkg;

  // Counter class demonstrating 'this' keyword usage
  class Counter;
    int count;        // Class property
    int step;         // Class property

    // Constructor with parameter names matching property names
    function new(int count = 0, int step = 1);
      this.count = count;    // Use 'this' to distinguish property from parameter
      this.step = step;      // Use 'this' to distinguish property from parameter
    endfunction

    // Method to increment counter
    function void increment();
      this.count += this.step;
    endfunction

    // Method to decrement counter
    function void decrement();
      this.count -= this.step;
    endfunction

    // Method to set count value
    function void set_count(int count);
      this.count = count;    // Use 'this' to resolve naming conflict
    endfunction

    // Method to set step value
    function void set_step(int step);
      this.step = step;      // Use 'this' to resolve naming conflict
    endfunction

    // Method to get current count
    function int get_count();
      return this.count;
    endfunction

    // Method to display counter state
    function void display();
      $display("Counter: count=%0d, step=%0d", this.count, this.step);
    endfunction

  endclass

endpackage

// Module using the Counter class
module counter_class_module();

  // Import the Counter class from package
  import counter_pkg::*;

  // Test the Counter class
  initial begin
    Counter my_counter;
    
    $display("=== Counter Class with 'this' Keyword Example ===");
    $display();
    
    // Create counter instance
    my_counter = new(5, 2);
    $display("Initial counter:");
    my_counter.display();
    $display();
    
    // Test increment
    my_counter.increment();
    $display("After increment:");
    my_counter.display();
    $display();
    
    // Test decrement
    my_counter.decrement();
    $display("After decrement:");
    my_counter.display();
    $display();
    
    // Test set methods with naming conflicts
    my_counter.set_count(10);
    my_counter.set_step(3);
    $display("After setting count=10, step=3:");
    my_counter.display();
    $display();
    
    // Test multiple increments
    my_counter.increment();
    my_counter.increment();
    $display("After two increments:");
    my_counter.display();
    $display();
    
    $display("Final count value: %0d", my_counter.get_count());
  end

endmodule