// array_sorting_design.sv
module array_sorting_engine();
  
  // Task to sort integer array in ascending order using bubble sort
  // Uses pass by reference (ref keyword) to modify array in-place
  task automatic sort_ascending_numbers(ref int unsorted_data_array[8]);
    int temp_swap_value;
    
    $display("Starting ascending sort of 8 elements");
    
    // Bubble sort implementation
    for (int outer_pass = 0; outer_pass < 7; outer_pass++) begin
      for (int inner_index = 0; inner_index < 7 - outer_pass; 
           inner_index++) begin
        if (unsorted_data_array[inner_index] > 
            unsorted_data_array[inner_index + 1]) begin
          // Swap elements
          temp_swap_value = unsorted_data_array[inner_index];
          unsorted_data_array[inner_index] = 
            unsorted_data_array[inner_index + 1];
          unsorted_data_array[inner_index + 1] = temp_swap_value;
        end
      end
    end
    $display("Ascending sort completed successfully");
  endtask

  // Task to sort integer array in descending order
  // Uses pass by reference to modify original array
  task automatic sort_descending_numbers(ref int unsorted_data_array[6]);
    int temp_swap_value;
    
    $display("Starting descending sort of 6 elements");
    
    // Bubble sort for descending order
    for (int outer_pass = 0; outer_pass < 5; outer_pass++) begin
      for (int inner_index = 0; inner_index < 5 - outer_pass; 
           inner_index++) begin
        if (unsorted_data_array[inner_index] < 
            unsorted_data_array[inner_index + 1]) begin
          // Swap elements
          temp_swap_value = unsorted_data_array[inner_index];
          unsorted_data_array[inner_index] = 
            unsorted_data_array[inner_index + 1];
          unsorted_data_array[inner_index + 1] = temp_swap_value;
        end
      end
    end
    $display("Descending sort completed successfully");
  endtask

  // Utility task to display 8-element array contents
  task display_array_8_contents(input int data_array[8], 
                                input string array_description);
    $write("%s: [", array_description);
    for (int element_index = 0; element_index < 8; element_index++) begin
      if (element_index > 0) $write(", ");
      $write("%0d", data_array[element_index]);
    end
    $display("]");
  endtask

  // Utility task to display 6-element array contents
  task display_array_6_contents(input int data_array[6], 
                                input string array_description);
    $write("%s: [", array_description);
    for (int element_index = 0; element_index < 6; element_index++) begin
      if (element_index > 0) $write(", ");
      $write("%0d", data_array[element_index]);
    end
    $display("]");
  endtask

  initial begin
    $display();
    $display("=== Array Sorting Tasks Demonstration ===");
  end

endmodule