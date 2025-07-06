// animal_factory_design_testbench.sv
module animal_factory_testbench;
  import animal_factory_pkg::*;
  
  // Instantiate design under test
  animal_factory_design DESIGN_INSTANCE_NAME();
  
  initial begin
    // Dump waves
    $dumpfile("animal_factory_testbench.vcd");
    $dumpvars(0, animal_factory_testbench);
    
    $display();
    $display("=== Simple Factory Pattern Demonstration ===");
    $display();
    
    // Test creating different animals using the factory
    test_animal_creation("dog");
    test_animal_creation("cat");
    test_animal_creation("bird");
    test_animal_creation("fish");
    
    // Demonstrate case insensitive creation
    $display("=== Case Insensitive Test ===");
    test_animal_creation("DOG");
    
    $display();
    $display("Factory pattern demonstration complete!");
    
    #1;  // Wait for a time unit
    $finish;
  end
  
  // Helper task to test animal creation
  task test_animal_creation(string animal_str);
    animal_type_e my_animal;
    
    $display("Creating animal: %s", animal_str);
    my_animal = create_animal(animal_str);
    
    if (is_valid_animal(my_animal)) begin
      $display("  Animal created: %s", get_animal_name(my_animal));
      $display("  Sound: %s", get_animal_sound(my_animal));
    end else begin
      $display("  Failed to create animal!");
    end
    $display();
  endtask

endmodule