// matrix_adder_design.sv
module matrix_adder_processor #(
  parameter MATRIX_SIZE = 4,
  parameter DATA_WIDTH  = 8
)(
  input  logic                                    clock_signal,
  input  logic                                    reset_signal,
  input  logic                                    start_operation,
  input  logic [DATA_WIDTH-1:0]                  matrix_a_input 
                                                  [MATRIX_SIZE-1:0]
                                                  [MATRIX_SIZE-1:0],
  input  logic [DATA_WIDTH-1:0]                  matrix_b_input 
                                                  [MATRIX_SIZE-1:0]
                                                  [MATRIX_SIZE-1:0],
  output logic [DATA_WIDTH-1:0]                  matrix_result_output 
                                                  [MATRIX_SIZE-1:0]
                                                  [MATRIX_SIZE-1:0],
  output logic                                    operation_complete
);

  // Internal matrix storage
  logic [DATA_WIDTH-1:0] matrix_a_storage [MATRIX_SIZE-1:0]
                                          [MATRIX_SIZE-1:0];
  logic [DATA_WIDTH-1:0] matrix_b_storage [MATRIX_SIZE-1:0]
                                          [MATRIX_SIZE-1:0];
  logic [DATA_WIDTH-1:0] result_storage   [MATRIX_SIZE-1:0]
                                          [MATRIX_SIZE-1:0];

  // Control signals
  logic operation_in_progress;
  logic [3:0] row_counter;
  logic [3:0] column_counter;

  // Matrix addition function
  function automatic void perform_matrix_addition();
    for (int row_index = 0; row_index < MATRIX_SIZE; row_index++) begin
      for (int col_index = 0; col_index < MATRIX_SIZE; col_index++) begin
        result_storage[row_index][col_index] = 
          matrix_a_storage[row_index][col_index] + 
          matrix_b_storage[row_index][col_index];
      end
    end
  endfunction

  // Sequential logic for matrix operations
  always_ff @(posedge clock_signal or posedge reset_signal) begin
    if (reset_signal) begin
      operation_complete <= 1'b0;
      operation_in_progress <= 1'b0;
      row_counter <= 4'b0;
      column_counter <= 4'b0;
      
      // Clear result matrix
      for (int i = 0; i < MATRIX_SIZE; i++) begin
        for (int j = 0; j < MATRIX_SIZE; j++) begin
          result_storage[i][j] <= '0;
        end
      end
      
    end else begin
      if (start_operation && !operation_in_progress) begin
        // Load input matrices and start operation
        matrix_a_storage <= matrix_a_input;
        matrix_b_storage <= matrix_b_input;
        operation_in_progress <= 1'b1;
        operation_complete <= 1'b0;
        
      end else if (operation_in_progress && !operation_complete) begin
        // Perform matrix addition in the next cycle after loading
        perform_matrix_addition();
        operation_complete <= 1'b1;
        operation_in_progress <= 1'b0;
        
      end else if (operation_complete) begin
        operation_complete <= 1'b0;
      end
    end
  end

  // Output assignment
  assign matrix_result_output = result_storage;

  // Display function for debugging
  function automatic void display_matrix_operation();
    $display("Matrix A:");
    for (int row = 0; row < MATRIX_SIZE; row++) begin
      $write("  ");
      for (int col = 0; col < MATRIX_SIZE; col++) begin
        $write("%3d ", matrix_a_storage[row][col]);
      end
      $display();
    end
    
    $display("Matrix B:");
    for (int row = 0; row < MATRIX_SIZE; row++) begin
      $write("  ");
      for (int col = 0; col < MATRIX_SIZE; col++) begin
        $write("%3d ", matrix_b_storage[row][col]);
      end
      $display();
    end
    
    $display("Result Matrix (A + B):");
    for (int row = 0; row < MATRIX_SIZE; row++) begin
      $write("  ");
      for (int col = 0; col < MATRIX_SIZE; col++) begin
        $write("%3d ", result_storage[row][col]);
      end
      $display();
    end
    $display();
  endfunction

endmodule