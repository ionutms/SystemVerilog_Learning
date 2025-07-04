// game_characters.sv
package game_characters_pkg;

  // Base character class with health and name
  class Character;
    protected string name;
    protected int health;
    protected int max_health;
    
    // Constructor with name and initial health
    function new(string char_name, int initial_health);
      this.name = char_name;
      this.health = initial_health;
      this.max_health = initial_health;
    endfunction
    
    // Method to get character name
    virtual function string get_name();
      return this.name;
    endfunction
    
    // Method to get current health
    virtual function int get_health();
      return this.health;
    endfunction
    
    // Method to get max health
    virtual function int get_max_health();
      return this.max_health;
    endfunction
    
    // Method to take damage
    virtual function void take_damage(int damage);
      this.health -= damage;
      if (this.health < 0) this.health = 0;
      $display("%s takes %0d damage! Health: %0d/%0d", 
               this.name, damage, this.health, this.max_health);
    endfunction
    
    // Method to heal
    virtual function void heal(int amount);
      this.health += amount;
      if (this.health > this.max_health) this.health = this.max_health;
      $display("%s heals %0d points! Health: %0d/%0d", 
               this.name, amount, this.health, this.max_health);
    endfunction
    
    // Method to check if character is alive
    virtual function bit is_alive();
      return (this.health > 0);
    endfunction
    
    // Method to display character info
    virtual function void display_info();
      $display("Character: %s, Health: %0d/%0d", 
               this.name, this.health, this.max_health);
    endfunction
    
  endclass

  // Warrior class inheriting from Character
  class Warrior extends Character;
    protected int attack_power;
    protected int armor;
    
    // Constructor using super to initialize base class
    function new(string warrior_name, int initial_health, 
                 int warrior_attack, int warrior_armor);
      super.new(warrior_name, initial_health);  // Call parent constructor
      this.attack_power = warrior_attack;
      this.armor = warrior_armor;
    endfunction
    
    // Method to get attack power
    virtual function int get_attack_power();
      return this.attack_power;
    endfunction
    
    // Method to get armor value
    virtual function int get_armor();
      return this.armor;
    endfunction
    
    // Override take_damage to account for armor
    virtual function void take_damage(int damage);
      int actual_damage = damage - this.armor;
      if (actual_damage < 0) actual_damage = 0;
      
      this.health -= actual_damage;
      if (this.health < 0) this.health = 0;
      
      $display("%s blocks %0d damage with armor! Takes %0d damage!", 
               this.name, this.armor, actual_damage);
      $display("%s Health: %0d/%0d", this.name, this.health, 
               this.max_health);
    endfunction
    
    // Warrior-specific attack method
    virtual function void attack(Character target);
      if (target == null) begin
        $display("%s swings at nothing!", this.name);
        return;
      end
      
      $display("%s attacks %s with %0d attack power!", 
               this.name, target.get_name(), this.attack_power);
      target.take_damage(this.attack_power);
    endfunction
    
    // Override display_info to show warrior stats
    virtual function void display_info();
      $display("Warrior: %s, Health: %0d/%0d, Attack: %0d, Armor: %0d", 
               this.name, this.health, this.max_health, 
               this.attack_power, this.armor);
    endfunction
    
  endclass

endpackage

module game_characters_module;
  import game_characters_pkg::*;
  
  // Module instantiation for synthesis
  initial begin
    $display("Game Characters Module - Classes defined in package");
  end
  
endmodule