// game_characters_testbench.sv
module game_characters_test_bench;
  import game_characters_pkg::*;
  
  // Instantiate the design module
  game_characters_module GAME_CHARACTERS_INSTANCE();
  
  // Test variables
  Character basic_char;
  Warrior warrior_char;
  Warrior enemy_warrior;
  Character char_ref;
  
  initial begin
    // Dump waves
    $dumpfile("game_characters_test_bench.vcd");
    $dumpvars(0, game_characters_test_bench);
    
    $display("=== Simple Game Characters Test ===");
    $display();
    
    // Test 1: Create basic character
    $display("--- Test 1: Basic Character ---");
    basic_char = new("Adventurer", 100);
    basic_char.display_info();
    $display("Is alive: %b", basic_char.is_alive());
    $display();
    
    // Test 2: Character takes damage and heals
    $display("--- Test 2: Character Damage and Healing ---");
    basic_char.take_damage(30);
    basic_char.heal(15);
    basic_char.display_info();
    $display();
    
    // Test 3: Create warrior using super constructor
    $display("--- Test 3: Warrior Creation ---");
    warrior_char = new("Sir Lancelot", 150, 25, 5);
    warrior_char.display_info();
    $display();
    
    // Test 4: Warrior takes damage (armor reduces damage)
    $display("--- Test 4: Warrior Armor Protection ---");
    warrior_char.take_damage(20);  // Should take 15 damage (20-5 armor)
    warrior_char.display_info();
    $display();
    
    // Test 5: Create enemy warrior for combat
    $display("--- Test 5: Warrior vs Warrior Combat ---");
    enemy_warrior = new("Dark Knight", 120, 20, 3);
    enemy_warrior.display_info();
    $display();
    
    // Test 6: Combat simulation
    $display("--- Test 6: Combat Simulation ---");
    $display("Round 1:");
    warrior_char.attack(enemy_warrior);
    $display();
    
    $display("Round 2:");
    enemy_warrior.attack(warrior_char);
    $display();
    
    $display("Round 3:");
    warrior_char.attack(enemy_warrior);
    $display();
    
    // Test 7: Character death
    $display("--- Test 7: Character Death ---");
    enemy_warrior.take_damage(100);  // Finish off enemy
    $display("Enemy is alive: %b", enemy_warrior.is_alive());
    $display();
    
    // Test 8: Attack on dead character
    $display("--- Test 8: Attack on Defeated Enemy ---");
    warrior_char.attack(enemy_warrior);
    $display();
    
    // Test 9: Healing limits
    $display("--- Test 9: Healing Limits ---");
    warrior_char.heal(200);  // Should cap at max health
    warrior_char.display_info();
    $display();
    
    // Test 10: Polymorphism test
    $display("--- Test 10: Polymorphism Test ---");
    char_ref = warrior_char;  // Base class reference to derived object
    char_ref.display_info();  // Should call warrior's display_info
    $display();
    
    $display("=== All Tests Complete ===");
    
    #1;  // Wait for a time unit
    $finish;
  end
  
endmodule