// game_units_design.sv
`include "game_units_package.sv"

module game_units_design();
  import game_units_pkg::*;
  
  // Declare unit handles
  GameUnit battle_units[];
  Archer archer_hero;
  Knight knight_hero;
  Wizard wizard_hero;
  
  initial begin
    $display("=== Game Units Battle System ===");
    $display();
    
    // Create different unit types
    archer_hero = new("Legolas");
    knight_hero = new("Sir Galahad");
    wizard_hero = new("Gandalf");
    
    // Create array of units for polymorphic behavior
    battle_units = new[3];
    battle_units[0] = archer_hero;
    battle_units[1] = knight_hero;
    battle_units[2] = wizard_hero;
    
    // Display unit information
    $display("Battle Participants:");
    foreach (battle_units[i]) begin
      $display("  %0d. %s", i+1, battle_units[i].get_info());
    end
    $display();
    
    // Demonstrate polymorphic attack behavior
    $display("=== Battle Begins! ===");
    foreach (battle_units[i]) begin
      $display("Turn %0d:", i+1);
      battle_units[i].attack();  // Calls overridden method
      $display();
    end
    
    // Demonstrate damage system
    $display("=== Damage Demo ===");
    $display("Knight takes damage from Wizard's spell:");
    knight_hero.take_damage(20);
    $display();
    
    $display("Archer takes critical damage:");
    archer_hero.take_damage(85);
    $display();
    
    $display("Final Status:");
    foreach (battle_units[i]) begin
      $display("  %s", battle_units[i].get_info());
    end
    
  end
  
endmodule