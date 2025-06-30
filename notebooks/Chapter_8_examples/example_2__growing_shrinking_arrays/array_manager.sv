// array_manager.sv
module array_manager();               // Dynamic array manager module
  
  // Dynamic arrays for demonstration
  int data_storage[];                 // Main data storage array
  string name_list[];                 // Array of names
  
  // Task to grow array and add new elements
  task automatic grow_data_array(int new_size, int fill_value);
    int old_size = data_storage.size();
    data_storage = new[new_size](data_storage);  // Grow array
    
    // Fill new elements with fill_value
    for (int i = old_size; i < new_size; i++) begin
      data_storage[i] = fill_value;
    end
    
    $display("Array grown from %0d to %0d elements", old_size, new_size);
  endtask
  
  // Task to shrink array by removing elements from the end
  task automatic shrink_data_array(int new_size);
    int old_size = data_storage.size();
    if (new_size < old_size) begin
      data_storage = new[new_size](data_storage);  // Shrink array
      $display("Array shrunk from %0d to %0d elements", old_size, new_size);
    end else begin
      $display("Cannot shrink: new size %0d >= current size %0d", 
               new_size, old_size);
    end
  endtask
  
  // Task to display current array contents
  task automatic display_array_contents();
    $display("Current array size: %0d", data_storage.size());
    if (data_storage.size() > 0) begin
      $write("Contents: ");
      foreach (data_storage[i]) begin
        $write("%0d ", data_storage[i]);
      end
      $display();
    end else begin
      $display("Array is empty");
    end
  endtask
  
  // Task to manage name list array
  task automatic manage_name_list();
    // Start with small array
    name_list = new[2];
    name_list[0] = "Alice";
    name_list[1] = "Bob";
    $display("Initial name list: %p", name_list);
    
    // Grow to add more names
    name_list = new[4](name_list);
    name_list[2] = "Charlie";
    name_list[3] = "Diana";
    $display("Expanded name list: %p", name_list);
    
    // Shrink back to 3 names
    name_list = new[3](name_list);
    $display("Trimmed name list: %p", name_list);
  endtask

endmodule