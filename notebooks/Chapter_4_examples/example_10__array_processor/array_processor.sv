// array_processor.sv
module array_processor ();                    // Design under test
  
  // Array processing class with various operations
  class array_operations;
    logic [7:0] data_array[16];
    logic [7:0] sum;
    logic [7:0] avg;
    logic [7:0] min_val;
    logic [7:0] max_val;
    integer array_size;
    
    function new();
      array_size = 16;
      initialize_array();
    endfunction
    
    // Function to initialize array with pattern
    function void initialize_array();
      foreach (data_array[i]) begin
        data_array[i] = 8'(i * 2 + 1);  // Odd numbers: 1, 3, 5, 7, ...
      end
    endfunction
    
    // Function to calculate sum of array elements
    function void calculate_sum();
      sum = 0;
      foreach (data_array[i]) begin
        sum += data_array[i];
      end
    endfunction
    
    // Function to calculate average
    function void calculate_average();
      calculate_sum();
      avg = 8'(sum / array_size);
    endfunction
    
    // Function to find minimum and maximum values
    function void find_min_max();
      min_val = data_array[0];
      max_val = data_array[0];
      
      foreach (data_array[i]) begin
        if (data_array[i] < min_val) min_val = data_array[i];
        if (data_array[i] > max_val) max_val = data_array[i];
      end
    endfunction
    
    // Function to display array contents
    function void display_array();
      $display("Array contents:");
      foreach (data_array[i]) begin
        $display("  data_array[%0d] = %0d (0x%02h)", i, data_array[i], data_array[i]);
      end
    endfunction
    
    // Function to display statistics
    function void display_statistics();
      $display("Array Statistics:");
      $display("  Size: %0d elements", array_size);
      $display("  Sum:  %0d", sum);
      $display("  Avg:  %0d", avg);
      $display("  Min:  %0d", min_val);
      $display("  Max:  %0d", max_val);
    endfunction
  endclass

  // Design logic with array processing functionality
  initial begin
    array_operations arr_proc;
    
    $display();                               // Display empty line
    $display("Hello from design!");          // Display message
    $display("=== Array Processing Operations ===");
    
    // Create instance of array operations class
    arr_proc = new();
    
    // Display initial array
    arr_proc.display_array();
    $display();
    
    // Perform array operations
    arr_proc.calculate_sum();
    arr_proc.calculate_average();
    arr_proc.find_min_max();
    
    // Display results
    arr_proc.display_statistics();
    
    $display("Design array processing completed!");
  end

endmodule