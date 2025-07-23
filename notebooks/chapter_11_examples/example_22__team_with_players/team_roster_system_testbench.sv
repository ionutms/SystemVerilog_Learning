// team_roster_system_testbench.sv
module team_roster_testbench;
  import player_pkg::*;
  import team_pkg::*;
  
  // Instantiate design under test
  team_roster_system DESIGN_INSTANCE();
  
  // Additional test scenarios
  Team test_team;
  Team copied_team;
  Player test_players[$];
  
  initial begin
    // Dump waves for analysis
    $dumpfile("team_roster_testbench.vcd");
    $dumpvars(0, team_roster_testbench);
    
    #1; // Wait for design to complete
    
    $display("\n============================================================");
    $display("=== TESTBENCH: Additional Team Copy Tests ===");
    $display("============================================================");
    
    // Test 1: Empty team copying
    test_team = new("Empty Team");
    copied_team = test_team.shallow_copy();
    
    $display("\nTest 1: Empty team shallow copy");
    test_team.display_roster();
    copied_team.display_roster();
    
    // Test 2: Single player team
    test_team = new("Solo Team");
    begin
      Player solo_player = new("Solo Player", 99, "All Positions");
      test_players.push_back(solo_player);
      test_team.add_player(test_players[0]);
    end
    
    copied_team = test_team.deep_copy();
    
    $display("\nTest 2: Single player deep copy");
    test_team.display_roster();
    copied_team.display_roster();
    
    // Test 3: Modify copied team
    $display("\nTest 3: Modifying deep copy (should not affect original)");
    copied_team.modify_player_name(0, "Independent Player");
    
    $display("Original after deep copy modification:");
    test_team.display_roster();
    $display("Deep copy after modification:");
    copied_team.display_roster();
    
    // Test 4: Performance comparison simulation
    $display("\n============================================================");
    $display("=== Performance Notes ===");
    $display("- Shallow copy: O(1) - only copies references");
    $display("- Deep copy: O(n) - creates new objects for each player");
    $display("- Memory usage: Deep copy uses more memory");
    $display("- Use shallow when you want shared state");
    $display("- Use deep when you want independent copies");
    
    $display("\n============================================================");
    $display("=== Testbench completed successfully! ===");
    $display("============================================================");
    
    #1; // Final wait
  end
endmodule