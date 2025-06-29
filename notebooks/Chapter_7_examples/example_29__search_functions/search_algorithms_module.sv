// search_algorithms_module.sv
module search_algorithms_module();

  // Function: Linear search with early return for efficiency
  function automatic int linear_search_with_early_return(
    input int search_array[8],
    input int target_value
  );
    for (int array_index = 0; array_index < 8; array_index++) begin
      if (search_array[array_index] == target_value) begin
        $display("Linear search: Found %0d at index %0d", 
                 target_value, array_index);
        return array_index;  // Early return when found
      end
    end
    $display("Linear search: Value %0d not found", target_value);
    return -1;  // Return -1 if not found
  endfunction

  // Function: Binary search with early return (assumes sorted array)
  function automatic int binary_search_with_early_return(
    input int sorted_array[8],
    input int target_value
  );
    int left_boundary = 0;
    int right_boundary = 7;
    int middle_index;
    
    while (left_boundary <= right_boundary) begin
      middle_index = (left_boundary + right_boundary) / 2;
      
      if (sorted_array[middle_index] == target_value) begin
        $display("Binary search: Found %0d at index %0d", 
                 target_value, middle_index);
        return middle_index;  // Early return when found
      end
      else if (sorted_array[middle_index] < target_value) begin
        left_boundary = middle_index + 1;
      end
      else begin
        right_boundary = middle_index - 1;
      end
    end
    
    $display("Binary search: Value %0d not found", target_value);
    return -1;  // Return -1 if not found
  endfunction

  // Function: Search for first occurrence with early return
  function automatic int find_first_occurrence_with_early_return(
    input int data_array[8],
    input int search_target
  );
    for (int position = 0; position < 8; position++) begin
      if (data_array[position] == search_target) begin
        $display("First occurrence: Found %0d at position %0d", 
                 search_target, position);
        return position;  // Early return on first match
      end
    end
    $display("First occurrence: Value %0d not found", search_target);
    return -1;
  endfunction

  initial begin
    $display("=== Search Functions with Early Returns Demo ===");
    $display();
  end

endmodule