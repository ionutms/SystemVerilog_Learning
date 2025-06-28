// statistical_analyzer_testbench.sv
module statistical_analyzer_testbench;       // Statistical analyzer testbench

  // Instantiate the statistical data processor
  statistical_data_processor STATS_PROCESSOR_INSTANCE();

  // Test data and result variables
  real sample_data_set[5];                   // Input data samples
  real calculated_mean;                      // Mean result
  real calculated_variance;                  // Variance result  
  real calculated_std_dev;                   // Standard deviation result
  real minimum_sample;                       // Minimum value result
  real maximum_sample;                       // Maximum value result
  string data_quality;                       // Quality assessment
  bit data_consistency_flag;                 // Consistency indicator

  initial begin
    // Configure wave dumping
    $dumpfile("statistical_analyzer_testbench.vcd");
    $dumpvars(0, statistical_analyzer_testbench);
    
    $display();
    $display("=== Statistical Analysis Functions Test ===");
    $display();
    
    // Test Case 1: Consistent data set
    sample_data_set = '{10.5, 10.2, 10.8, 10.1, 10.4};
    
    $display("Test Case 1: Analyzing consistent data samples");
    $display("Input samples: %0.1f, %0.1f, %0.1f, %0.1f, %0.1f",
             sample_data_set[0], sample_data_set[1], sample_data_set[2],
             sample_data_set[3], sample_data_set[4]);
    
    // Call statistical analysis function
    STATS_PROCESSOR_INSTANCE.calculate_statistics(
      sample_data_set,
      calculated_mean,
      calculated_variance,
      calculated_std_dev,
      minimum_sample,
      maximum_sample
    );
    
    // Display statistical results
    $display("  Mean value:        %0.3f", calculated_mean);
    $display("  Variance:          %0.6f", calculated_variance);
    $display("  Standard deviation: %0.6f", calculated_std_dev);
    $display("  Minimum sample:    %0.1f", minimum_sample);
    $display("  Maximum sample:    %0.1f", maximum_sample);
    
    // Assess data quality
    STATS_PROCESSOR_INSTANCE.quality_metrics(
      calculated_mean,
      calculated_std_dev,
      data_quality,
      data_consistency_flag
    );
    
    $display("  Quality rating:    %s", data_quality);
    $display("  Data consistent:   %s", 
             data_consistency_flag ? "YES" : "NO");
    $display();
    
    #5;  // Wait between test cases
    
    // Test Case 2: Variable data set
    sample_data_set = '{5.0, 15.0, 8.0, 20.0, 12.0};
    
    $display("Test Case 2: Analyzing variable data samples");
    $display("Input samples: %0.1f, %0.1f, %0.1f, %0.1f, %0.1f",
             sample_data_set[0], sample_data_set[1], sample_data_set[2],
             sample_data_set[3], sample_data_set[4]);
    
    // Rerun analysis with new data
    STATS_PROCESSOR_INSTANCE.calculate_statistics(
      sample_data_set,
      calculated_mean,
      calculated_variance,
      calculated_std_dev,
      minimum_sample,
      maximum_sample
    );
    
    $display("  Mean value:        %0.3f", calculated_mean);
    $display("  Variance:          %0.6f", calculated_variance);
    $display("  Standard deviation: %0.6f", calculated_std_dev);
    $display("  Minimum sample:    %0.1f", minimum_sample);
    $display("  Maximum sample:    %0.1f", maximum_sample);
    
    STATS_PROCESSOR_INSTANCE.quality_metrics(
      calculated_mean,
      calculated_std_dev,
      data_quality,
      data_consistency_flag
    );
    
    $display("  Quality rating:    %s", data_quality);
    $display("  Data consistent:   %s", 
             data_consistency_flag ? "YES" : "NO");
    $display();
    
    $display("Statistical analysis testing completed!");
    $display();
    
  end

endmodule