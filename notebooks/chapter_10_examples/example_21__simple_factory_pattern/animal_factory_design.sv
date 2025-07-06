// animal_factory_design.sv
package animal_factory_pkg;

  // Simple factory pattern using basic types
  typedef enum {ANIMAL_DOG, ANIMAL_CAT, ANIMAL_BIRD, ANIMAL_UNKNOWN} animal_type_e;
  
  // Factory function - creates animal type from string
  function animal_type_e create_animal(string animal_type_str);
    case (animal_type_str.tolower())
      "dog":  return ANIMAL_DOG;
      "cat":  return ANIMAL_CAT;
      "bird": return ANIMAL_BIRD;
      default: begin
        $display("Unknown animal type: %s", animal_type_str);
        return ANIMAL_UNKNOWN;
      end
    endcase
  endfunction
  
  // Get animal name from type
  function string get_animal_name(animal_type_e animal_type);
    case (animal_type)
      ANIMAL_DOG:  return "Dog";
      ANIMAL_CAT:  return "Cat";
      ANIMAL_BIRD: return "Bird";
      default:     return "Unknown";
    endcase
  endfunction
  
  // Get animal sound from type
  function string get_animal_sound(animal_type_e animal_type);
    case (animal_type)
      ANIMAL_DOG:  return "Woof!";
      ANIMAL_CAT:  return "Meow!";
      ANIMAL_BIRD: return "Tweet!";
      default:     return "Silence...";
    endcase
  endfunction
  
  // Check if animal is valid
  function bit is_valid_animal(animal_type_e animal_type);
    return (animal_type != ANIMAL_UNKNOWN);
  endfunction

endpackage

module animal_factory_design;
  import animal_factory_pkg::*;
  
  initial begin
    $display("Animal Factory Design Module Loaded");
  end
endmodule