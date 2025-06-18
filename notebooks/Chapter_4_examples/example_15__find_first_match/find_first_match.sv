// find_first_match.sv
module array_searcher ();               // Array search processor design under test
    logic [7:0] test_array[50];
    logic [7:0] search_targets[5];
    int search_results[5];
    
    // Function to find first match in array
    function int find_first_match(logic [7:0] array[], logic [7:0] target);
        foreach (array[i]) begin
            if (array[i] == target) begin
                return i;  // Found match, return index
            end
            
            // Skip processing for special values (undefined/don't care)
            if (array[i] === 8'bxxxxxxxx) begin
                $display("Array Searcher: Skipping undefined value at index %0d", i);
                continue;
            end
            
            // Additional processing could go here for logging
            // $display("Array Searcher: Checking index %0d, value %0d", i, array[i]);
        end
        
        return -1; // Not found
    endfunction
    
    initial begin
        $display("Array Searcher: Starting array search demonstration...");
        $display();
        
        // Initialize test array with sample data
        for (int i = 0; i < 50; i++) begin
            if (i == 15 || i == 25) begin
                test_array[i] = 8'bxxxxxxxx;  // Insert undefined values
            end else begin
                test_array[i] = 8'((i * 7 + 13) % 128);  // Generate test pattern
            end
        end
        
        // Define search targets
        search_targets[0] = 8'd20;
        search_targets[1] = 8'd50;
        search_targets[2] = 8'd99;
        search_targets[3] = 8'd0;
        search_targets[4] = 8'd127;
        
        $display("Array Searcher: Test array initialized with 50 elements");
        $display("Array Searcher: Undefined values inserted at indices 15 and 25");
        $display();
        
        // Display first 10 array elements for reference
        $display("Array Searcher: First 10 array elements:");
        for (int i = 0; i < 10; i++) begin
            if (test_array[i] === 8'bxxxxxxxx) begin
                $display("  test_array[%0d] = XX (undefined)", i);
            end else begin
                $display("  test_array[%0d] = %0d", i, test_array[i]);
            end
        end
        $display();
        
        // Perform searches
        $display("Array Searcher: Performing searches...");
        foreach (search_targets[j]) begin
            search_results[j] = find_first_match(test_array, search_targets[j]);
            
            if (search_results[j] >= 0) begin
                $display("Array Searcher: Target %0d found at index %0d", 
                        search_targets[j], search_results[j]);
            end else begin
                $display("Array Searcher: Target %0d not found in array", 
                        search_targets[j]);
            end
        end
        
        $display();
        $display("Array Searcher: Search operations completed!");
        
        // Summary of results
        $display("Array Searcher: Search Results Summary:");
        foreach (search_targets[k]) begin
            $display("  Target %0d: %s", 
                    search_targets[k], 
                    (search_results[k] >= 0) ? $sformatf("Found at index %0d", search_results[k]) : "Not found");
        end
        
        $display();
    end
endmodule