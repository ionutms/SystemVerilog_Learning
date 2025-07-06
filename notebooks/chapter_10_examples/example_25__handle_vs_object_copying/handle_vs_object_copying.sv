// handle_vs_object_copying.sv
// Demonstrates the difference between handle copying and object copying

package vehicle_package;

  // Simple vehicle class to demonstrate copying concepts
  class vehicle_class;
    string brand;
    int speed;
    
    function new(string init_brand = "Unknown", int init_speed = 0);
      this.brand = init_brand;
      this.speed = init_speed;
    endfunction
    
    function void display(string prefix = "");
      $display("%sVehicle: %s, Speed: %0d", prefix, brand, speed);
    endfunction
    
    function void set_speed(int new_speed);
      this.speed = new_speed;
    endfunction
    
    function void set_brand(string new_brand);
      this.brand = new_brand;
    endfunction
    
    // Deep copy method - creates a new object with same values
    function vehicle_class deep_copy();
      vehicle_class new_vehicle;
      new_vehicle = new(this.brand, this.speed);
      return new_vehicle;
    endfunction
    
  endclass

endpackage

module handle_vs_object_copying_module;
  
  import vehicle_package::*;
  
  initial begin
    vehicle_class original_vehicle;
    vehicle_class handle_copy;
    vehicle_class object_copy;
    
    $display("=== Handle vs Object Copying Example ===");
    $display();
    
    // Create original vehicle
    original_vehicle = new("Toyota", 60);
    $display("1. Created original vehicle:");
    original_vehicle.display("   ");
    $display();
    
    // Handle copying - both variables point to same object
    $display("2. Handle copying (shallow copy):");
    handle_copy = original_vehicle;  // Just copying the handle/reference
    $display("   Original vehicle:");
    original_vehicle.display("   ");
    $display("   Handle copy:");
    handle_copy.display("   ");
    $display();
    
    // Modify through handle copy
    $display("3. Modifying speed through handle copy:");
    handle_copy.set_speed(80);
    $display("   Original vehicle (affected!):");
    original_vehicle.display("   ");
    $display("   Handle copy:");
    handle_copy.display("   ");
    $display("   -> Both changed because they reference same object");
    $display();
    
    // Object copying - creates independent copy
    $display("4. Object copying (deep copy):");
    object_copy = original_vehicle.deep_copy();
    $display("   Original vehicle:");
    original_vehicle.display("   ");
    $display("   Object copy:");
    object_copy.display("   ");
    $display();
    
    // Modify original after object copy
    $display("5. Modifying original after object copy:");
    original_vehicle.set_brand("Honda");
    original_vehicle.set_speed(100);
    $display("   Original vehicle (modified):");
    original_vehicle.display("   ");
    $display("   Handle copy (also modified - same object!):");
    handle_copy.display("   ");
    $display("   Object copy (unchanged - independent object!):");
    object_copy.display("   ");
    $display();
    
    // Modify object copy
    $display("6. Modifying object copy:");
    object_copy.set_brand("Ford");
    object_copy.set_speed(45);
    $display("   Original vehicle (unchanged):");
    original_vehicle.display("   ");
    $display("   Object copy (modified independently):");
    object_copy.display("   ");
    $display();
    
    $display("=== Key Takeaways ===");
    $display("- Handle copying: Creates another reference to same object");
    $display("- Object copying: Creates independent object with same values");
    $display("- Changes through handle copies affect the original object");
    $display("- Changes to deep copies don't affect the original object");
    
  end

endmodule