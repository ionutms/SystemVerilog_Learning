// super_usage_example.sv
// Chapter 10 Example 26: Proper super Usage

package super_usage_pkg;

  // Base class - Animal
  class Animal;
    protected string name;
    protected int age;
    
    // Constructor
    function new(string animal_name = "Unknown", int animal_age = 0);
      name = animal_name;
      age = animal_age;
      $display("Animal constructor: %s, age %0d", name, age);
    endfunction
    
    // Virtual method for making sound
    virtual function string make_sound();
      return "Generic animal sound";
    endfunction
    
    // Method to display animal info
    virtual function void display_info();
      $display("Animal: %s, Age: %0d", name, age);
    endfunction
    
    // Method to celebrate birthday
    virtual function void birthday();
      age++;
      $display("%s is now %0d years old!", name, age);
    endfunction
  endclass

  // Derived class - Dog
  class Dog extends Animal;
    protected string breed;
    
    // Constructor - CORRECT super usage
    function new(string dog_name = "Buddy", int dog_age = 1, 
                 string dog_breed = "Mixed");
      super.new(dog_name, dog_age);  // Call parent constructor FIRST
      breed = dog_breed;
      $display("Dog constructor: %s is a %s", dog_name, breed);
    endfunction
    
    // Override make_sound - CORRECT super usage
    function string make_sound();
      string parent_sound = super.make_sound();  // Call parent method
      return $sformatf("%s -> Woof! Woof!", parent_sound);
    endfunction
    
    // Override display_info - CORRECT super usage
    function void display_info();
      super.display_info();  // Call parent method first
      $display("Breed: %s", breed);
    endfunction
    
    // Override birthday - CORRECT super usage
    function void birthday();
      $display("It's %s's birthday!", name);
      super.birthday();  // Call parent method
      $display("%s the %s is wagging tail!", name, breed);
    endfunction
    
    // Dog-specific method
    function void fetch();
      $display("%s is fetching the ball!", name);
    endfunction
  endclass

  // Derived class - Cat (shows different super usage patterns)
  class Cat extends Animal;
    protected bit is_indoor;
    
    // Constructor - CORRECT super usage with default parameters
    function new(string cat_name = "Whiskers", int cat_age = 2, 
                 bit indoor = 1);
      super.new(cat_name, cat_age);  // Always call super.new() first
      is_indoor = indoor;
      $display("Cat constructor: %s, indoor: %s", cat_name, 
               is_indoor ? "Yes" : "No");
    endfunction
    
    // Override make_sound - CORRECT super usage in conditional
    function string make_sound();
      if (age < 1) begin
        return "Mew mew";  // Kittens don't call parent
      end else begin
        string parent_sound = super.make_sound();
        return $sformatf("%s -> Meow! Purr!", parent_sound);
      end
    endfunction
    
    // Override display_info - CORRECT super usage with additions
    function void display_info();
      super.display_info();  // Call parent method
      $display("Indoor cat: %s", is_indoor ? "Yes" : "No");
    endfunction
    
    // Cat-specific method
    function void climb();
      $display("%s is climbing the cat tree!", name);
    endfunction
  endclass

  // Example of INCORRECT super usage (commented out for reference)
  /*
  class BadDog extends Animal;
    function new(string name = "BadDog");
      // WRONG: Setting attributes before calling super.new()
      this.name = name;
      super.new(name, 1);  // This could cause issues
    endfunction
    
    function string make_sound();
      // WRONG: Not storing super result properly
      super.make_sound();  // Return value ignored
      return "Woof!";
    endfunction
    
    function void display_info();
      // WRONG: Not calling super at all
      $display("Bad dog: %s", name);  // Missing parent info
    endfunction
  endclass
  */

endpackage