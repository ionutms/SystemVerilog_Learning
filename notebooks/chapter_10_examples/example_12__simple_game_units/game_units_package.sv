// game_units_package.sv
package game_units_pkg;

  // Base Game Unit class with virtual attack method
  virtual class GameUnit;
    protected string unit_name;
    protected int health;
    protected int damage;
    
    function new(string name = "Unknown", int hp = 100, int dmg = 10);
      this.unit_name = name;
      this.health = hp;
      this.damage = dmg;
    endfunction
    
    // Virtual attack method to be overridden by derived classes
    virtual function void attack();
      $display("%s performs a basic attack for %0d damage!", 
               unit_name, damage);
    endfunction
    
    // Get unit information
    function string get_info();
      return $sformatf("%s (HP: %0d, DMG: %0d)", 
                       unit_name, health, damage);
    endfunction
    
    // Take damage
    function void take_damage(int dmg);
      health -= dmg;
      if (health <= 0) begin
        health = 0;
        $display("%s has been defeated!", unit_name);
      end else begin
        $display("%s takes %0d damage! Health: %0d", 
                 unit_name, dmg, health);
      end
    endfunction
    
  endclass

  // Archer class - ranged attacks with precision
  class Archer extends GameUnit;
    
    function new(string name = "Archer");
      super.new(name, 80, 15);  // Lower health, higher damage
    endfunction
    
    // Override attack method
    virtual function void attack();
      $display("%s draws bow and fires a precise arrow for %0d damage!", 
               unit_name, damage);
      $display("  *Swoosh* -> Direct hit!");
    endfunction
    
  endclass

  // Knight class - melee attacks with defense
  class Knight extends GameUnit;
    
    function new(string name = "Knight");
      super.new(name, 120, 12);  // Higher health, moderate damage
    endfunction
    
    // Override attack method
    virtual function void attack();
      $display("%s raises sword and strikes with %0d damage!", 
               unit_name, damage);
      $display("  *Clang* -> Steel meets steel!");
    endfunction
    
  endclass

  // Wizard class - magical attacks with special effects
  class Wizard extends GameUnit;
    
    function new(string name = "Wizard");
      super.new(name, 70, 20);  // Lowest health, highest damage
    endfunction
    
    // Override attack method
    virtual function void attack();
      $display("%s casts a spell dealing %0d magical damage!", 
               unit_name, damage);
      $display("  *Zap* -> Arcane energy crackles!");
    endfunction
    
  endclass

endpackage