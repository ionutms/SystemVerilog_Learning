// matrix_processor.sv
module matrix_processor ();               // Matrix operations design under test
    logic [7:0] matrix[4][4];
    logic [7:0] row_sum[4];
    
    initial begin
        $display();
        $display("Matrix Processor: Starting operations...");
        
        // Initialize matrix
        foreach (matrix[i]) begin
            foreach (matrix[i][j]) begin
                matrix[i][j] = 8'(i + j);
            end
        end
        
        // Calculate row sums
        foreach (row_sum[i]) begin
            row_sum[i] = 0;
            foreach (matrix[i][j]) begin
                row_sum[i] += matrix[i][j];
            end
        end
        
        // Display results
        $display("Matrix values and row sums:");
        foreach (row_sum[i]) begin
            $display("Row %0d sum = %0d", i, row_sum[i]);
        end
        
        $display("Matrix Processor: Operations completed.");
    end
endmodule