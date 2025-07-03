// animal_sound_maker_testbench.sv
module animal_sound_testbench;
  import animal_sound_pkg::*;

  // Instantiate design under test
  animal_sound_maker ANIMAL_SOUND_INSTANCE();

  // Declare all variables at module level for Verilator compatibility
  int buddy_type;
  string buddy_name;
  int whiskers_type;
  string whiskers_name;
  int bessie_type;
  string bessie_name;
  
  // Arrays for farm animals
  int farm_animal_types[3];
  string farm_animal_names[3];
  int i;

  initial begin
    // Dump waves for debugging
    $dumpfile("animal_sound_testbench.vcd");
    $dumpvars(0, animal_sound_testbench);
    
    $display("=== Creating Animal Objects ===");
    buddy_type = ANIMAL_DOG;
    buddy_name = "Buddy";
    
    whiskers_type = ANIMAL_CAT;
    whiskers_name = "Whiskers";
    
    bessie_type = ANIMAL_COW;
    bessie_name = "Bessie";
    
    $display();
    $display("=== Individual Animal Sounds ===");
    
    // Test individual animals
    introduce(buddy_type, buddy_name);
    make_sound(buddy_type, buddy_name);
    $display();
    
    introduce(whiskers_type, whiskers_name);
    make_sound(whiskers_type, whiskers_name);
    $display();
    
    introduce(bessie_type, bessie_name);
    make_sound(bessie_type, bessie_name);
    $display();
    
    // Demonstrate polymorphism with arrays
    $display("=== Polymorphism Demo ===");
    farm_animal_types[0] = buddy_type;
    farm_animal_names[0] = buddy_name;
    farm_animal_types[1] = whiskers_type;
    farm_animal_names[1] = whiskers_name;
    farm_animal_types[2] = bessie_type;
    farm_animal_names[2] = bessie_name;
    
    $display("Farm animals making sounds:");
    for (i = 0; i < 3; i = i + 1) begin
      make_sound(farm_animal_types[i], farm_animal_names[i]);
    end
    
    $display();
    $display("=== Sound Maker Animals Test Complete ===");
    
    #10; // Wait a bit before finishing
    $finish;
  end

endmodule