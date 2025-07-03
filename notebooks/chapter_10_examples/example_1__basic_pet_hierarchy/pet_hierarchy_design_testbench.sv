// pet_hierarchy_design_testbench.sv
// Testbench for Basic Pet Hierarchy Example

module pet_hierarchy_testbench;
  
  // Instantiate the design module
  pet_hierarchy_design DESIGN_INSTANCE();
  
  // Test variables
  Animal base_animal;
  Dog my_dog;
  Cat my_cat;
  Animal animal_ref;  // Reference for polymorphism demonstration
  
  initial begin
    // Setup waveform dumping
    $dumpfile("pet_hierarchy_testbench.vcd");
    $dumpvars(0, pet_hierarchy_testbench);
    
    $display("=== Pet Hierarchy Inheritance Example ===");
    $display();
    
    // Test 1: Create base Animal
    $display("1. Testing Base Animal Class:");
    base_animal = new("Generic Pet", 5);
    base_animal.display_info();
    $display("Sound: %s", base_animal.make_sound());
    $display("Description: %s", base_animal.get_description());
    $display();
    
    // Test 2: Create Dog instance
    $display("2. Testing Dog Class (inherits from Animal):");
    my_dog = new("Buddy", 3, "Golden Retriever");
    my_dog.display_info();
    $display("Sound: %s", my_dog.make_sound());
    $display("Description: %s", my_dog.get_description());
    my_dog.wag_tail();
    $display();
    
    // Test 3: Create Cat instance
    $display("3. Testing Cat Class (inherits from Animal):");
    my_cat = new("Whiskers", 2, 1);  // Indoor cat
    my_cat.display_info();
    $display("Sound: %s", my_cat.make_sound());
    $display("Description: %s", my_cat.get_description());
    my_cat.purr();
    $display();
    
    // Test 4: Polymorphism demonstration
    $display("4. Testing Polymorphism:");
    $display("Using Animal reference to point to Dog:");
    animal_ref = my_dog;
    $display("Sound via Animal reference: %s", animal_ref.make_sound());
    $display("Description via Animal reference: %s", 
             animal_ref.get_description());
    
    $display("Using Animal reference to point to Cat:");
    animal_ref = my_cat;
    $display("Sound via Animal reference: %s", animal_ref.make_sound());
    $display("Description via Animal reference: %s", 
             animal_ref.get_description());
    $display();
    
    // Test 5: Create different pets with default constructors
    $display("5. Testing Default Constructors:");
    begin
      Dog default_dog;
      Cat default_cat;
      
      default_dog = new();
      default_cat = new();
      
      $display("Default Dog: %s", default_dog.get_description());
      $display("Default Cat: %s", default_cat.get_description());
    end
    
    $display();
    $display("=== All tests completed successfully! ===");
    
    // Small delay before finishing
    #10;
    $finish;
  end
  
endmodule