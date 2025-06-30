// game_board_grid.sv
module game_board_controller ();
  
  // Dynamic 2D array representing a game board
  int game_grid[][];
  int board_width, board_height;
  
  // Initialize the game board with given dimensions
  function automatic void initialize_board(int width, int height);
    board_width = width;
    board_height = height;
    
    // Allocate the 2D dynamic array
    game_grid = new[height];
    for (int row = 0; row < height; row++) begin
      game_grid[row] = new[width];
      // Initialize all cells to 0 (empty)
      for (int col = 0; col < width; col++) begin
        game_grid[row][col] = 0;
      end
    end
    
    $display("Board initialized: %0dx%0d grid", width, height);
  endfunction
  
  // Resize the board while preserving existing data
  function automatic void resize_board(int new_width, int new_height);
    int old_grid[][];
    int old_width = board_width;
    int old_height = board_height;
    
    // Save current grid
    old_grid = new[old_height];
    for (int row = 0; row < old_height; row++) begin
      old_grid[row] = new[old_width];
      for (int col = 0; col < old_width; col++) begin
        old_grid[row][col] = game_grid[row][col];
      end
    end
    
    // Create new grid
    board_width = new_width;
    board_height = new_height;
    game_grid = new[new_height];
    
    for (int row = 0; row < new_height; row++) begin
      game_grid[row] = new[new_width];
      for (int col = 0; col < new_width; col++) begin
        // Copy old data if within bounds, otherwise initialize to 0
        if (row < old_height && col < old_width) begin
          game_grid[row][col] = old_grid[row][col];
        end else begin
          game_grid[row][col] = 0;
        end
      end
    end
    
    $display("Board resized: %0dx%0d -> %0dx%0d", 
             old_width, old_height, new_width, new_height);
  endfunction
  
  // Place a piece on the board (1 = player piece)
  function automatic void place_piece(int row, int col, int piece_value);
    if (row >= 0 && row < board_height && col >= 0 && col < board_width) begin
      game_grid[row][col] = piece_value;
      $display("Placed piece %0d at position [%0d][%0d]", 
               piece_value, row, col);
    end else begin
      $display("Invalid position [%0d][%0d] for %0dx%0d board", 
               row, col, board_width, board_height);
    end
  endfunction
  
  // Display the current game board
  function automatic void display_board();
    $display("Current game board (%0dx%0d):", board_width, board_height);
    for (int row = 0; row < board_height; row++) begin
      string row_str = "";
      for (int col = 0; col < board_width; col++) begin
        row_str = {row_str, $sformatf("%2d ", game_grid[row][col])};
      end
      $display("  %s", row_str);
    end
    $display();
  endfunction
  
  initial begin
    $display("2D Dynamic Grid - Game Board Controller");
    $display("=====================================");
  end

endmodule