// pet_hierarchy_design.sv
// Basic Pet Hierarchy Example - Chapter 10 Example 1

// Base Animal class
class Animal;
  string name;
  int age;
  
  // Constructor
  function new(string pet_name = "Unknown", int pet_age = 0);
    this.name = pet_name;
    this.age = pet_age;
  endfunction
  
  // Virtual method for making sound (to be overridden)
  virtual function string make_sound();
    return "Some generic animal sound";
  endfunction
  
  // Method to display pet information
  function void display_info();
    $display("Pet Name: %s, Age: %d years", name, age);
  endfunction
  
  // Method to get pet description
  virtual function string get_description();
    return $sformatf("%s is %d years old", name, age);
  endfunction
endclass

// Dog class inheriting from Animal
class Dog extends Animal;
  string breed;
  
  // Constructor
  function new(string pet_name = "Buddy", int pet_age = 0, 
               string dog_breed = "Mixed");
    super.new(pet_name, pet_age);  // Call parent constructor
    this.breed = dog_breed;
  endfunction
  
  // Override make_sound method
  function string make_sound();
    return "Woof! Woof!";
  endfunction
  
  // Override get_description method
  function string get_description();
    return $sformatf("%s is a %d-year-old %s", name, age, breed);
  endfunction
  
  // Dog-specific method
  function void wag_tail();
    $display("%s is wagging tail happily!", name);
  endfunction
endclass

// Cat class inheriting from Animal
class Cat extends Animal;
  bit is_indoor;
  
  // Constructor  
  function new(string pet_name = "Whiskers", int pet_age = 0, 
               bit indoor = 1);
    super.new(pet_name, pet_age);  // Call parent constructor
    this.is_indoor = indoor;
  endfunction
  
  // Override make_sound method
  function string make_sound();
    return "Meow! Meow!";
  endfunction
  
  // Override get_description method
  function string get_description();
    string location = is_indoor ? "indoor" : "outdoor";
    return $sformatf("%s is a %d-year-old %s cat", name, age, location);
  endfunction
  
  // Cat-specific method
  function void purr();
    $display("%s is purring contentedly!", name);
  endfunction
endclass

// Top-level module for design
module pet_hierarchy_design;
  // This module serves as a container for the class definitions
  // The actual testing will be done in the testbench
endmodule