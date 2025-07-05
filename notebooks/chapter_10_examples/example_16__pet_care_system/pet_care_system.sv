// pet_care_system.sv
package pet_care_pkg;

  // Enumeration for pet types
  typedef enum {DOG, CAT, FISH} pet_type_e;

  // Simple struct-based approach for Verilator compatibility
  typedef struct {
    string name;
    int age;
    pet_type_e pet_type;
    string breed_or_info;  // breed for dog, indoor/outdoor for cat, tank size for fish
  } pet_info_t;

  // Pet care functions
  function void feed_pet(pet_info_t pet);
    case(pet.pet_type)
      DOG:  $display("  Feeding %s (Dog) with dry kibble and fresh water", pet.name);
      CAT:  $display("  Feeding %s (Cat) with wet food and treats", pet.name);
      FISH: $display("  Feeding %s (Fish) with flakes and bloodworms", pet.name);
    endcase
  endfunction

  function void care_for_pet(pet_info_t pet);
    case(pet.pet_type)
      DOG:  $display("  Walking %s, playing fetch, and brushing fur", pet.name);
      CAT:  $display("  Cleaning %s's litter box, playing with toys (%s cat)", 
                     pet.name, pet.breed_or_info);
      FISH: $display("  Cleaning %s's %s tank and checking water pH", 
                     pet.name, pet.breed_or_info);
    endcase
  endfunction

  function string get_pet_info(pet_info_t pet);
    case(pet.pet_type)
      DOG:  return $sformatf("%s is a %0d-year-old %s", 
                            pet.name, pet.age, pet.breed_or_info);
      CAT:  return $sformatf("%s is a %0d-year-old %s cat", 
                            pet.name, pet.age, pet.breed_or_info);
      FISH: return $sformatf("%s is a %0d-year-old fish in a %s tank", 
                            pet.name, pet.age, pet.breed_or_info);
    endcase
  endfunction

endpackage

// Main design module
module pet_care_system;
  import pet_care_pkg::*;
  
  // Array of pet structures for polymorphic-like behavior
  pet_info_t pet_array[6];
  
  initial begin
    $display("=== Pet Care System Initialization ===");
    
    // Create different types of pets using struct initialization
    pet_array[0] = '{"Buddy", 5, DOG, "Golden Retriever"};
    pet_array[1] = '{"Whiskers", 3, CAT, "indoor"};
    pet_array[2] = '{"Goldie", 2, FISH, "10-gallon"};
    pet_array[3] = '{"Max", 7, DOG, "German Shepherd"};
    pet_array[4] = '{"Shadow", 4, CAT, "outdoor"};
    pet_array[5] = '{"Nemo", 1, FISH, "5-gallon"};
    
    // Display all pets information
    $display("\n=== Pet Information ===");
    for(int i = 0; i < 6; i++) begin
      $display("%0d. %s", i+1, get_pet_info(pet_array[i]));
    end
    
    // Demonstrate polymorphic-like feeding routine
    $display("\n=== Daily Feeding Routine ===");
    for(int i = 0; i < 6; i++) begin
      feed_pet(pet_array[i]);
    end
    
    // Demonstrate polymorphic-like care routine
    $display("\n=== Daily Care Routine ===");
    for(int i = 0; i < 6; i++) begin
      care_for_pet(pet_array[i]);
    end
    
    $display("\n=== Pet Care System Complete ===");
  end

endmodule