// super_usage_example_testbench.sv
// Chapter 10 Example 26: Proper super Usage Testbench

module super_usage_testbench;
  import super_usage_pkg::*;
  
  initial begin
    // Dump waves for debugging
    $dumpfile("super_usage_testbench.vcd");
    $dumpvars(0, super_usage_testbench);
    
    $display("=== Chapter 10 Example 26: Proper super Usage ===");
    $display();
    
    // Test 1: Create base Animal
    $display("--- Test 1: Base Animal Creation ---");
    begin
      Animal base_animal = new("Generic Animal", 5);
      base_animal.display_info();
      $display("Sound: %s", base_animal.make_sound());
      $display();
    end
    
    // Test 2: Create Dog (demonstrates proper super usage)
    $display("--- Test 2: Dog Creation (Proper super usage) ---");
    begin
      Dog my_dog = new("Rex", 3, "Golden Retriever");
      my_dog.display_info();
      $display("Sound: %s", my_dog.make_sound());
      my_dog.fetch();
      $display();
    end
    
    // Test 3: Create Cat (demonstrates different super patterns)
    $display("--- Test 3: Cat Creation (Different super patterns) ---");
    begin
      Cat my_cat = new("Luna", 2, 1);
      my_cat.display_info();
      $display("Sound: %s", my_cat.make_sound());
      my_cat.climb();
      $display();
    end
    
    // Test 4: Polymorphism with proper super usage
    $display("--- Test 4: Polymorphism Test ---");
    begin
      Animal wild_animal = new("Wild Animal", 10);
      $display("Animal 0:");
      wild_animal.display_info();
      $display("Sound: %s", wild_animal.make_sound());
      $display();
    end
    
    begin
      Dog buddy_dog = new("Buddy", 4, "Labrador");
      $display("Animal 1:");
      buddy_dog.display_info();
      $display("Sound: %s", buddy_dog.make_sound());
      $display();
    end
    
    begin
      Cat mittens_cat = new("Mittens", 1, 0);
      $display("Animal 2:");
      mittens_cat.display_info();
      $display("Sound: %s", mittens_cat.make_sound());
      $display();
    end
    
    // Test 5: Birthday method (shows super usage in overridden methods)
    $display("--- Test 5: Birthday Celebration (super in methods) ---");
    begin
      Animal base_animal = new("Birthday Animal", 4);
      $display("Base animal birthday:");
      base_animal.birthday();
      $display();
    end
    
    begin
      Dog birthday_dog = new("Birthday Dog", 2, "Poodle");
      $display("Dog birthday:");
      birthday_dog.birthday();
      $display();
    end
    
    begin
      Cat birthday_cat = new("Birthday Cat", 3, 1);
      $display("Cat birthday:");
      birthday_cat.birthday();
      $display();
    end
    
    // Test 6: Demonstrate constructor chain
    $display("--- Test 6: Constructor Chain Demonstration ---");
    $display("Creating new dog to show constructor chain:");
    begin
      Dog another_dog = new("Max", 2, "Beagle");
      another_dog.display_info();
      $display();
    end
    
    // Test 7: Show method resolution through base class reference
    $display("--- Test 7: Method Resolution ---");
    $display("Calling methods through base class reference:");
    begin
      Dog test_dog = new("Polymorphic Dog", 1, "Shepherd");
      Animal dog_as_animal = test_dog;
      dog_as_animal.display_info();  // Calls derived version
      $display("Sound: %s", dog_as_animal.make_sound());  // Calls derived
      $display();
    end
    
    // Test 8: Different constructor patterns
    $display("--- Test 8: Constructor Patterns ---");
    begin
      Animal default_animal = new();
      Dog default_dog = new();
      Cat default_cat = new();
      
      $display("Default constructors:");
      default_animal.display_info();
      default_dog.display_info();
      default_cat.display_info();
      $display();
    end
    
    $display("=== Key Points about Proper super Usage ===");
    $display("1. Always call super.new() FIRST in derived constructors");
    $display("2. Use super.method() to call parent method implementations");
    $display("3. super can be used conditionally in method overrides");
    $display("4. Store super method return values when needed");
    $display("5. Call super methods before or after derived logic as needed");
    $display();
    
    $display("=== Simulation Complete ===");
    $finish;
  end
  
endmodule