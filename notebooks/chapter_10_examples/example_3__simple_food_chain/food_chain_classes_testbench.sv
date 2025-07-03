// food_chain_classes_testbench.sv
module food_chain_testbench;

  // Import the food chain package
  import food_chain_pkg::*;

  // Instantiate design under test
  food_chain_classes FOOD_CHAIN_INSTANCE();

  // Declare all class handles and variables at module level
  Fruit apple, banana, orange;
  Vegetable carrot, spinach, potato;
  Food food_handle;
  food_chain_pkg::Fruit scoped_apple;
  int total_nutrition;

  // Task to create and initialize all food objects
  task create_food_objects();
    apple = new("Apple", "Red", 95, 1, "Fall");
    banana = new("Banana", "Yellow", 105, 1, "Year-round");
    orange = new("Orange", "Orange", 85, 1, "Winter");
    carrot = new("Carrot", "Orange", 25, "Root", 0);
    spinach = new("Spinach", "Green", 15, "Leaf", 0);
    potato = new("Potato", "Brown", 160, "Root", 1);
    scoped_apple = new("Scoped Apple", "Green", 80, 1, "Summer");
  endtask

  // Task to display fruit information
  task display_fruits();
    $display("Fruits Information:");
    $display("------------------");
    apple.display_info();
    banana.display_info();
    orange.display_info();
    $display();
  endtask

  // Task to display vegetable information
  task display_vegetables();
    $display("Vegetables Information:");
    $display("----------------------");
    carrot.display_info();
    spinach.display_info();
    potato.display_info();
    $display();
  endtask

  // Task to demonstrate fruit operations
  task demonstrate_fruit_operations();
    $display("Fruit Operations:");
    $display("----------------");
    apple.ripen();
    banana.ripen();
    orange.ripen();
    $display();
  endtask

  // Task to demonstrate vegetable operations
  task demonstrate_vegetable_operations();
    $display("Vegetable Operations:");
    $display("--------------------");
    carrot.harvest();
    spinach.harvest();
    potato.harvest();
    $display();
  endtask

  // Task to calculate and display nutritional information
  task display_nutrition_summary();
    $display("Nutritional Summary:");
    $display("-------------------");
    
    total_nutrition = 0;
    total_nutrition += apple.nutritional_value;
    $display("Apple: %0d calories", apple.nutritional_value);
    
    total_nutrition += banana.nutritional_value;
    $display("Banana: %0d calories", banana.nutritional_value);
    
    total_nutrition += orange.nutritional_value;
    $display("Orange: %0d calories", orange.nutritional_value);
    
    total_nutrition += carrot.nutritional_value;
    $display("Carrot: %0d calories", carrot.nutritional_value);
    
    total_nutrition += spinach.nutritional_value;
    $display("Spinach: %0d calories", spinach.nutritional_value);
    
    total_nutrition += potato.nutritional_value;
    $display("Potato: %0d calories", potato.nutritional_value);
    
    $display("Total Calories: %0d", total_nutrition);
    $display();
  endtask

  // Task to test polymorphism
  task test_polymorphism();
    $display("Polymorphism Test:");
    $display("-----------------");
    
    food_handle = apple;
    $display("Base handle pointing to apple:");
    $display("Type: %s", food_handle.get_food_type());
    food_handle.display_info();
    $display();
    
    food_handle = carrot;
    $display("Base handle pointing to carrot:");
    $display("Type: %s", food_handle.get_food_type());
    food_handle.display_info();
    $display();
  endtask

  // Task to test package scope
  task test_package_scope();
    $display("Package Scope Test:");
    $display("------------------");
    scoped_apple.display_info();
    $display();
  endtask

  // Main test sequence
  initial begin
    // Dump waves
    $dumpfile("food_chain_testbench.vcd");
    $dumpvars(0, food_chain_testbench);
    
    $display("Food Chain Inheritance Example");
    $display("==============================");
    $display();
    
    // Create all food objects
    create_food_objects();
    
    // Display information
    display_fruits();
    display_vegetables();
    
    // Demonstrate operations
    demonstrate_fruit_operations();
    demonstrate_vegetable_operations();
    
    // Show nutritional summary
    display_nutrition_summary();
    
    // Test polymorphism
    test_polymorphism();
    
    // Test package scope
    test_package_scope();
    
    $display("Food Chain Example Complete!");
    $display("============================");
    
    #1;  // Wait for a time unit
  end

endmodule