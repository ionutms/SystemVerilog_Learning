// statistical_analyzer.sv
module statistical_data_processor ();        // Statistical analysis module

  // Function returning multiple statistical measures
  function automatic void calculate_statistics(
    input  real data_samples[5],              // Input data array
    output real mean_value,                   // Mean output
    output real variance_value,               // Variance output
    output real std_deviation,                // Standard deviation output
    output real min_value,                    // Minimum value output
    output real max_value                     // Maximum value output
  );
    real sum_of_values;
    real sum_of_squares;
    int  sample_count;
    
    // Initialize values
    sum_of_values = 0.0;
    sum_of_squares = 0.0;
    sample_count = 5;
    min_value = data_samples[0];
    max_value = data_samples[0];
    
    // Calculate sum and find min/max
    foreach (data_samples[i]) begin
      sum_of_values += data_samples[i];
      sum_of_squares += (data_samples[i] * data_samples[i]);
      if (data_samples[i] < min_value) min_value = data_samples[i];
      if (data_samples[i] > max_value) max_value = data_samples[i];
    end
    
    // Calculate mean
    mean_value = sum_of_values / sample_count;
    
    // Calculate variance
    variance_value = (sum_of_squares / sample_count) - 
                    (mean_value * mean_value);
    
    // Calculate standard deviation
    std_deviation = $sqrt(variance_value);
    
  endfunction

  // Function to analyze data quality
  function automatic void quality_metrics(
    input  real mean_val,
    input  real std_dev,
    output string quality_rating,
    output bit   is_consistent_data
  );
    real coefficient_of_variation;
    
    coefficient_of_variation = (std_dev / mean_val) * 100.0;
    
    if (coefficient_of_variation < 10.0) begin
      quality_rating = "EXCELLENT";
      is_consistent_data = 1'b1;
    end else if (coefficient_of_variation < 25.0) begin
      quality_rating = "GOOD";
      is_consistent_data = 1'b1;
    end else begin
      quality_rating = "POOR";
      is_consistent_data = 1'b0;
    end
    
  endfunction

  initial begin
    $display();
    $display("Statistical Data Processor Ready");
  end

endmodule