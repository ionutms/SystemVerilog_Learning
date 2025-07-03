// animal_sound_maker.sv
package animal_sound_pkg;

  // Animal type constants
  parameter int ANIMAL_DOG = 0;
  parameter int ANIMAL_CAT = 1;
  parameter int ANIMAL_COW = 2;
  parameter int ANIMAL_GENERIC = 3;

  // Function to make sound based on animal type
  function automatic void make_sound(int animal_type, string name);
    case (animal_type)
      ANIMAL_DOG: $display("%s says: Woof!", name);
      ANIMAL_CAT: $display("%s says: Meow!", name);
      ANIMAL_COW: $display("%s says: Moo!", name);
      ANIMAL_GENERIC: $display("%s makes a generic animal sound", name);
      default: $display("%s makes an unknown sound", name);
    endcase
  endfunction

  // Function to introduce animal
  function automatic void introduce(int animal_type, string name);
    string type_str;
    case (animal_type)
      ANIMAL_DOG: type_str = "Dog";
      ANIMAL_CAT: type_str = "Cat";
      ANIMAL_COW: type_str = "Cow";
      ANIMAL_GENERIC: type_str = "Animal";
      default: type_str = "Unknown";
    endcase
    $display("I am %s, a %s", name, type_str);
  endfunction

  // Function to get animal type string
  function automatic string get_type_string(int animal_type);
    case (animal_type)
      ANIMAL_DOG: return "Dog";
      ANIMAL_CAT: return "Cat";
      ANIMAL_COW: return "Cow";
      ANIMAL_GENERIC: return "Animal";
      default: return "Unknown";
    endcase
  endfunction

endpackage

module animal_sound_maker();
  import animal_sound_pkg::*;

  initial begin
    $display("=== Animal Sound Maker Demo ===");
    $display();
  end

endmodule