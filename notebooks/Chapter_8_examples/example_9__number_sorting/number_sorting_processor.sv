// number_sorting_processor.sv
module number_sorting_processor ();               // Design under test
  
  // Queue to hold our collection of numbers
  int number_collection[$];
  int sorted_numbers[$];
  int temp_value;
  int i, j;
  int collection_size;
  
  initial begin
    $display();                                    // Display empty line
    $display("Number Sorting Processor Started!");
    
    // Initialize collection with some numbers
    number_collection.push_back(45);
    number_collection.push_back(12);
    number_collection.push_back(78);
    number_collection.push_back(23);
    number_collection.push_back(56);
    number_collection.push_back(34);
    
    $display("Original collection size: %0d", number_collection.size());
    $display("Original numbers:");
    for (i = 0; i < number_collection.size(); i++) begin
      $display("  Position %0d: %0d", i, number_collection[i]);
    end
    
    // Find maximum number manually
    temp_value = number_collection[0];
    for (i = 1; i < number_collection.size(); i++) begin
      if (number_collection[i] > temp_value) begin
        temp_value = number_collection[i];
      end
    end
    $display("Maximum number found: %0d", temp_value);
    
    // Find minimum number manually
    temp_value = number_collection[0];
    for (i = 1; i < number_collection.size(); i++) begin
      if (number_collection[i] < temp_value) begin
        temp_value = number_collection[i];
      end
    end
    $display("Minimum number found: %0d", temp_value);
    
    // Copy to sorted array for bubble sort
    sorted_numbers = number_collection;
    collection_size = sorted_numbers.size();
    
    // Bubble sort implementation (ascending order)
    for (i = 0; i < collection_size - 1; i++) begin
      for (j = 0; j < collection_size - i - 1; j++) begin
        if (sorted_numbers[j] > sorted_numbers[j + 1]) begin
          // Swap elements
          temp_value = sorted_numbers[j];
          sorted_numbers[j] = sorted_numbers[j + 1];
          sorted_numbers[j + 1] = temp_value;
        end
      end
    end
    
    $display("Sorted ascending:");
    for (i = 0; i < sorted_numbers.size(); i++) begin
      $display("  Position %0d: %0d", i, sorted_numbers[i]);
    end
    
    // Reverse the sorted array for descending order
    for (i = 0; i < collection_size / 2; i++) begin
      temp_value = sorted_numbers[i];
      sorted_numbers[i] = sorted_numbers[collection_size - 1 - i];
      sorted_numbers[collection_size - 1 - i] = temp_value;
    end
    
    $display("Sorted descending:");
    for (i = 0; i < sorted_numbers.size(); i++) begin
      $display("  Position %0d: %0d", i, sorted_numbers[i]);
    end
    
    $display("Number Sorting Processing Complete!");
    $display();                                    // Display empty line
  end
  
endmodule