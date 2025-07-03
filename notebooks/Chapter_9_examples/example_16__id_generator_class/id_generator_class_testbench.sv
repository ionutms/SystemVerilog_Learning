// id_generator_class_testbench.sv
// Testbench for ID Generator Class demonstrating static properties

module id_generator_testbench;
  
  // Declare class handles
  id_generator_class obj1, obj2, obj3, obj4;
  
  initial begin
    // Dump waves for Verilator
    $dumpfile("id_generator_testbench.vcd");
    $dumpvars(0, id_generator_testbench);
    
    $display("=== ID Generator Class Example ===");
    $display();
    
    // Display initial statistics (should be 0 objects)
    $display("Initial state:");
    id_generator_class::display_statistics();
    $display();
    
    // Create first object
    $display("Creating first object (CPU)...");
    obj1 = new("CPU");
    obj1.display_info();
    $display("Objects created so far: %0d", 
             id_generator_class::get_total_objects());
    $display();
    
    // Create second object
    $display("Creating second object (Memory)...");
    obj2 = new("Memory");
    obj2.display_info();
    $display("Objects created so far: %0d", 
             id_generator_class::get_total_objects());
    $display();
    
    // Create third object
    $display("Creating third object (Cache)...");
    obj3 = new("Cache");
    obj3.display_info();
    $display("Next ID will be: %0d", id_generator_class::get_next_id());
    $display();
    
    // Display all object information
    $display("=== All Object Information ===");
    obj1.display_info();
    obj2.display_info();
    obj3.display_info();
    $display();
    
    // Create fourth object with default name
    $display("Creating fourth object (default name)...");
    obj4 = new();
    obj4.display_info();
    $display();
    
    // Display final statistics
    $display("Final statistics:");
    id_generator_class::display_statistics();
    $display();
    
    // Demonstrate that static properties are shared
    $display("=== Demonstrating Static Property Sharing ===");
    $display("Accessing total count from obj1: %0d", 
             obj1.get_total_objects());
    $display("Accessing total count from obj2: %0d", 
             obj2.get_total_objects());
    $display("Accessing total count from class: %0d", 
             id_generator_class::get_total_objects());
    $display("All should be the same value!");
    $display();
    
    $display("=== Example Complete ===");
    $finish;
  end
  
endmodule