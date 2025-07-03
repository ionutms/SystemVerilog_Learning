// food_chain_classes.sv
package food_chain_pkg;

  // Base Food class
  virtual class Food;
    string name;
    string color;
    int nutritional_value;
    
    // Constructor
    function new(string n, string c, int nv);
      name = n;
      color = c;
      nutritional_value = nv;
    endfunction
    
    // Virtual method to display info
    virtual function void display_info();
      $display("Food: %s, Color: %s, Nutritional Value: %0d", 
               name, color, nutritional_value);
    endfunction
    
    // Virtual method to get food type
    virtual function string get_food_type();
      return "Generic Food";
    endfunction
  endclass

  // Fruit class derived from Food
  class Fruit extends Food;
    bit is_sweet;
    string season;
    
    // Constructor
    function new(string n, string c, int nv, bit sweet, string s);
      super.new(n, c, nv);
      is_sweet = sweet;
      season = s;
    endfunction
    
    // Override display_info method
    virtual function void display_info();
      $display("Fruit: %s, Color: %s, Nutritional Value: %0d, Sweet: %s, Season: %s",
               name, color, nutritional_value, 
               is_sweet ? "Yes" : "No", season);
    endfunction
    
    // Override get_food_type method
    virtual function string get_food_type();
      return "Fruit";
    endfunction
    
    // Fruit-specific method
    function void ripen();
      $display("%s is ripening...", name);
    endfunction
  endclass

  // Vegetable class derived from Food
  class Vegetable extends Food;
    string part_of_plant;
    bit needs_cooking;
    
    // Constructor
    function new(string n, string c, int nv, string part, bit cooking);
      super.new(n, c, nv);
      part_of_plant = part;
      needs_cooking = cooking;
    endfunction
    
    // Override display_info method
    virtual function void display_info();
      $display("Vegetable: %s, Color: %s, Nutritional Value: %0d, Part: %s, Needs Cooking: %s",
               name, color, nutritional_value, part_of_plant,
               needs_cooking ? "Yes" : "No");
    endfunction
    
    // Override get_food_type method
    virtual function string get_food_type();
      return "Vegetable";
    endfunction
    
    // Vegetable-specific method
    function void harvest();
      $display("%s is being harvested from the %s", name, part_of_plant);
    endfunction
  endclass

endpackage

module food_chain_classes();

  initial begin
    $display("Food Chain Classes - Design Module");
    $display("=====================================");
    $display("Classes defined in food_chain_pkg package");
    $display();
  end

endmodule