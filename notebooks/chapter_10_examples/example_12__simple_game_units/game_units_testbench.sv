// game_units_testbench.sv
module game_units_testbench;
  import game_units_pkg::*;
  
  // Testbench variables
  GameUnit test_units[];
  Archer test_archer;
  Knight test_knight;
  Wizard test_wizard;
  
  // Instantiate design under test
  game_units_design DUT();
  
  initial begin
    // Dump waves for debugging
    $dumpfile("game_units_testbench.vcd");
    $dumpvars(0, game_units_testbench);
    
    #1;  // Wait for design to complete
    
    $display("=== Testbench: Additional Unit Tests ===");
    $display();
    
    // Test individual unit creation and methods
    test_archer = new("Robin Hood");
    test_knight = new("Sir Lancelot");
    test_wizard = new("Merlin");
    
    $display("Testing individual unit attacks:");
    $display("Archer:");
    test_archer.attack();
    $display();
    
    $display("Knight:");
    test_knight.attack();
    $display();
    
    $display("Wizard:");
    test_wizard.attack();
    $display();
    
    // Test polymorphic array behavior
    test_units = new[3];
    test_units[0] = test_archer;
    test_units[1] = test_knight;
    test_units[2] = test_wizard;
    
    $display("Testing polymorphic behavior:");
    foreach (test_units[i]) begin
      $display("Unit %0d attack:", i+1);
      test_units[i].attack();
    end
    $display();
    
    // Test damage system with different scenarios
    $display("Testing damage system:");
    $display("Before damage: %s", test_knight.get_info());
    test_knight.take_damage(30);
    $display("After 30 damage: %s", test_knight.get_info());
    test_knight.take_damage(100);  // Should defeat the knight
    $display("After 100 damage: %s", test_knight.get_info());
    $display();
    
    $display("=== All Tests Complete ===");
    $finish;
  end
  
endmodule