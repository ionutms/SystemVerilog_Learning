// data_validator.sv
module data_validator ();               // Data validation processor design under test
    logic [7:0] data_stream[100];
    logic [7:0] valid_data[$];
    
    initial begin
        $display("Data Validator: Starting data validation process...");
        
        // Initialize test data with fixed seed approach
        for (int i = 0; i < 100; i++) begin
            data_stream[i] = 8'((i * 17 + 42) % 256);  // Generate pseudo-random pattern
        end

        $display();
        $display("Data Validator: Test data initialized, beginning validation...");
        
        // Process data with validation
        foreach (data_stream[i]) begin
            // Skip invalid data (value 0 or 255)
            if (data_stream[i] == 0 || data_stream[i] == 255) begin
                $display("Data Validator: Skipping invalid data at index %0d: %0d", 
                        i, data_stream[i]);
                continue;
            end
            
            // Break on error pattern (redundant check since 255 is already filtered above)
            if (data_stream[i] == 8'hFF) begin
                $display("Data Validator: Error pattern detected at index %0d", i);
                break;
            end
            
            // Store valid data
            valid_data.push_back(data_stream[i]);
            $display("Data Validator: Valid data stored at index %0d: %0d", i, data_stream[i]);
        end
        
        $display("Data Validator: Processing completed!");
        $display("Data Validator: Processed %0d valid data items out of 100 total", valid_data.size());
        
        // Display first few valid items for verification
        $display("Data Validator: First 10 valid items:");
        for (int i = 0; i < 10 && i < valid_data.size(); i++) begin
            $display("  valid_data[%0d] = %0d", i, valid_data[i]);
        end

        $display();

    end
endmodule