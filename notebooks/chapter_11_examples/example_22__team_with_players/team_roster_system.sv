// team_roster_system.sv
package player_pkg;
  // Player class definition
  class Player;
    string name;
    int jersey_number;
    string position;
    
    function new(string n = "Unknown", int num = 0, string pos = "Bench");
      this.name = n;
      this.jersey_number = num;
      this.position = pos;
    endfunction
    
    function Player copy();
      Player new_player = new();
      new_player.name = this.name;
      new_player.jersey_number = this.jersey_number;
      new_player.position = this.position;
      return new_player;
    endfunction
    
    function void display_info();
      $display("  Player: %s, #%0d, Position: %s", 
               name, jersey_number, position);
    endfunction
  endclass
endpackage

package team_pkg;
  import player_pkg::*;
  
  // Team class containing Player objects
  class Team;
    string team_name;
    Player roster[$];  // Dynamic array of Player objects
    
    function new(string name = "Unnamed Team");
      this.team_name = name;
    endfunction
    
    function void add_player(Player p);
      roster.push_back(p);
    endfunction
    
    // Shallow copy - copies references to Player objects
    function Team shallow_copy();
      Team new_team = new();
      new_team.team_name = $sformatf("%s (Shallow Copy)", this.team_name);
      new_team.roster = this.roster;  // Shallow copy - same Player objects
      return new_team;
    endfunction
    
    // Deep copy - creates new Player objects
    function Team deep_copy();
      Team new_team = new();
      new_team.team_name = $sformatf("%s (Deep Copy)", this.team_name);
      
      // Create new Player objects for deep copy
      foreach(this.roster[i]) begin
        Player new_player = this.roster[i].copy();
        new_team.roster.push_back(new_player);
      end
      return new_team;
    endfunction
    
    function void display_roster();
      $display("\n=== %s Roster ===", team_name);
      $display("Total Players: %0d", roster.size());
      foreach(roster[i]) begin
        roster[i].display_info();
      end
    endfunction
    
    function void modify_player_name(int index, string new_name);
      if (index < roster.size()) begin
        roster[index].name = new_name;
        $display("Modified player %0d name to: %s", index, new_name);
      end
    endfunction
  endclass
endpackage

module team_roster_system;
  import player_pkg::*;
  import team_pkg::*;
  
  Team original_team;
  Team shallow_team;
  Team deep_team;
  Player p1, p2, p3;
  
  initial begin
    $display("=== Team with Players - Shallow vs Deep Copy Demo ===");
    
    // Create original team
    original_team = new("Warriors");
    
    // Create players
    p1 = new("John Smith", 10, "Forward");
    p2 = new("Mike Johnson", 23, "Guard");
    p3 = new("Tom Wilson", 7, "Center");
    
    // Add players to original team
    original_team.add_player(p1);
    original_team.add_player(p2);
    original_team.add_player(p3);
    
    // Display original team
    original_team.display_roster();
    
    // Create shallow copy
    shallow_team = original_team.shallow_copy();
    
    // Create deep copy
    deep_team = original_team.deep_copy();
    
    // Display all teams
    shallow_team.display_roster();
    deep_team.display_roster();
    
    $display("\n=== Demonstrating Shallow vs Deep Copy ===");
    $display("Modifying original team's first player name...");
    
    // Modify original team's first player
    original_team.modify_player_name(0, "MODIFIED John");
    
    $display("\nAfter modification:");
    
    // Show impact on shallow copy (affected) vs deep copy (not affected)
    original_team.display_roster();
    shallow_team.display_roster();
    deep_team.display_roster();
    
    $display("\n=== Analysis ===");
    $display("- Shallow copy shares Player objects with original");
    $display("- Deep copy has independent Player objects");
    $display("- Modifying original affects shallow copy but not deep copy");
  end
endmodule