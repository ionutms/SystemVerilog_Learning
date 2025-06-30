// game_board_grid_testbench.sv
module dynamic_grid_testbench;
  
  // Instantiate the game board controller
  game_board_controller BOARD_CONTROLLER();
  
  initial begin
    // Dump waves for analysis
    $dumpfile("dynamic_grid_testbench.vcd");
    $dumpvars(0, dynamic_grid_testbench);
    
    $display("Testing 2D Dynamic Grid Operations");
    $display("==================================");
    $display();
    
    // Test 1: Initialize a small 3x3 game board
    $display("Test 1: Creating initial 3x3 board");
    BOARD_CONTROLLER.initialize_board(3, 3);
    BOARD_CONTROLLER.display_board();
    
    // Test 2: Place some game pieces
    $display("Test 2: Placing game pieces");
    BOARD_CONTROLLER.place_piece(0, 0, 1);  // Player 1 piece
    BOARD_CONTROLLER.place_piece(1, 1, 2);  // Player 2 piece
    BOARD_CONTROLLER.place_piece(2, 2, 1);  // Player 1 piece
    BOARD_CONTROLLER.display_board();
    
    // Test 3: Resize to larger board (5x4)
    $display("Test 3: Expanding board to 5x4");
    BOARD_CONTROLLER.resize_board(5, 4);
    BOARD_CONTROLLER.display_board();
    
    // Test 4: Add more pieces to expanded area
    $display("Test 4: Adding pieces to new areas");
    BOARD_CONTROLLER.place_piece(3, 4, 2);  // New area
    BOARD_CONTROLLER.place_piece(0, 3, 1);  // New column
    BOARD_CONTROLLER.place_piece(3, 0, 2);  // New row
    BOARD_CONTROLLER.display_board();
    
    // Test 5: Resize to smaller board (2x2) - some data will be lost
    $display("Test 5: Shrinking board to 2x2");
    BOARD_CONTROLLER.resize_board(2, 2);
    BOARD_CONTROLLER.display_board();
    
    // Test 6: Try invalid placement
    $display("Test 6: Testing boundary checking");
    BOARD_CONTROLLER.place_piece(2, 2, 3);  // Should fail (out of bounds)
    BOARD_CONTROLLER.place_piece(1, 0, 3);  // Should succeed
    BOARD_CONTROLLER.display_board();
    
    // Test 7: Resize to different aspect ratio (6x2)
    $display("Test 7: Creating wide board (6x2)");
    BOARD_CONTROLLER.resize_board(6, 2);
    BOARD_CONTROLLER.place_piece(0, 5, 4);  // Far right
    BOARD_CONTROLLER.place_piece(1, 2, 4);  // Middle
    BOARD_CONTROLLER.display_board();
    
    $display("Dynamic grid testing completed!");
    $display();
    
    #1;  // Small delay for simulation
    $finish;
  end

endmodule