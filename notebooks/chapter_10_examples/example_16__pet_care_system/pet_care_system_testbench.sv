// pet_care_system_testbench.sv
module pet_care_testbench;
  import pet_care_pkg::*;
  
  // Instantiate the design under test
  pet_care_system PET_CARE_INSTANCE();
  
  // Additional test pets
  pet_info_t test_pets[3];
  pet_info_t mixed_pets[4];
  
  initial begin
    // Setup VCD dumping for waveform analysis
    $dumpfile("pet_care_testbench.vcd");
    $dumpvars(0, pet_care_testbench);
    
    #10;  // Wait for design to initialize
    
    $display("\n=== Testbench: Additional Pet Care Scenarios ===");
    
    // Test scenario 1: Creating pets with different parameters
    test_pets[0] = '{"Rex", 2, DOG, "Labrador"};
    test_pets[1] = '{"Mittens", 6, CAT, "indoor"};
    test_pets[2] = '{"Bubbles", 3, FISH, "20-gallon"};
    
    $display("\n--- Test Scenario 1: New Pet Registration ---");
    for(int i = 0; i < 3; i++) begin
      $display("Registering: %s", get_pet_info(test_pets[i]));
    end
    
    // Test scenario 2: Special care routine for older pets
    $display("\n--- Test Scenario 2: Senior Pet Care ---");
    for(int i = 0; i < 3; i++) begin
      if(test_pets[i].age >= 5) begin
        $display("Senior pet detected: %s", get_pet_info(test_pets[i]));
        $display("  Providing extra care and health monitoring");
        care_for_pet(test_pets[i]);
      end
    end
    
    // Test scenario 3: Feeding schedule verification
    $display("\n--- Test Scenario 3: Feeding Schedule ---");
    $display("Morning feeding routine:");
    for(int i = 0; i < 3; i++) begin
      feed_pet(test_pets[i]);
    end
    
    #5;  // Small delay
    
    // Test scenario 4: Pet type verification
    $display("\n--- Test Scenario 4: Pet Type Analysis ---");
    for(int i = 0; i < 3; i++) begin
      case(test_pets[i].pet_type)
        DOG:  $display("%s is a canine companion", test_pets[i].name);
        CAT:  $display("%s is a feline friend", test_pets[i].name);
        FISH: $display("%s is an aquatic pet", test_pets[i].name);
      endcase
    end
    
    // Test scenario 5: Demonstrate function-based polymorphism
    $display("\n--- Test Scenario 5: Function-Based Care System ---");
    mixed_pets[0] = '{"Spot", 3, DOG, "Beagle"};
    mixed_pets[1] = '{"Fluffy", 2, CAT, "indoor"};
    mixed_pets[2] = '{"Splash", 1, FISH, "15-gallon"};
    mixed_pets[3] = '{"Tiger", 8, CAT, "outdoor"};
    
    $display("Processing mixed pet group:");
    for(int i = 0; i < 4; i++) begin
      $display("Pet %0d: %s", i+1, get_pet_info(mixed_pets[i]));
      feed_pet(mixed_pets[i]);
      care_for_pet(mixed_pets[i]);
      $display("");
    end
    
    #10;  // Final delay
    
    $display("=== Testbench: Pet Care System Verification Complete ===");
    $display("All polymorphic-like function calls executed successfully!");
    
  end

endmodule