// performance_monitor.sv
module cpu_performance_monitor (
  input  logic clk,
  input  logic reset_n,
  input  logic instruction_valid,
  input  logic cache_hit,
  input  logic cache_miss,
  input  logic pipeline_stall
);

  // Performance counters
  int unsigned total_cycles_count;
  int unsigned instruction_count;
  int unsigned cache_hit_count;
  int unsigned cache_miss_count;
  int unsigned pipeline_stall_count;
  
  // Performance metrics
  real instructions_per_cycle;
  real cache_hit_rate;
  real pipeline_efficiency;

  // Void function to update cycle counter
  function void update_cycle_counter();
    if (reset_n) begin
      total_cycles_count <= total_cycles_count + 1;
    end
  endfunction

  // Void function to update instruction metrics
  function void update_instruction_metrics();
    if (reset_n && instruction_valid) begin
      instruction_count <= instruction_count + 1;
    end
  endfunction

  // Void function to update cache performance metrics
  function void update_cache_metrics();
    if (reset_n) begin
      if (cache_hit) cache_hit_count <= cache_hit_count + 1;
      if (cache_miss) cache_miss_count <= cache_miss_count + 1;
    end
  endfunction

  // Void function to update pipeline performance metrics
  function void update_pipeline_metrics();
    if (reset_n && pipeline_stall) begin
      pipeline_stall_count <= pipeline_stall_count + 1;
    end
  endfunction

  // Void function to calculate derived performance metrics
  function void calculate_performance_ratios();
    if (total_cycles_count > 0) begin
      instructions_per_cycle <= real'(instruction_count) / 
                               real'(total_cycles_count);
      pipeline_efficiency <= 1.0 - (real'(pipeline_stall_count) / 
                                    real'(total_cycles_count));
    end
    
    if ((cache_hit_count + cache_miss_count) > 0) begin
      cache_hit_rate <= real'(cache_hit_count) / 
                       real'(cache_hit_count + cache_miss_count);
    end
  endfunction

  // Void function to display performance summary
  function void display_performance_summary();
    $display("=== CPU Performance Monitor Summary ===");
    $display("Total Cycles: %0d", total_cycles_count);
    $display("Instructions: %0d", instruction_count);
    $display("Cache Hits: %0d", cache_hit_count);
    $display("Cache Misses: %0d", cache_miss_count);
    $display("Pipeline Stalls: %0d", pipeline_stall_count);
    $display("Instructions per Cycle: %0.3f", instructions_per_cycle);
    $display("Cache Hit Rate: %0.1f%%", cache_hit_rate * 100.0);
    $display("Pipeline Efficiency: %0.1f%%", pipeline_efficiency * 100.0);
    $display("=====================================");
  endfunction

  // Initialize counters on reset
  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      total_cycles_count <= 0;
      instruction_count <= 0;
      cache_hit_count <= 0;
      cache_miss_count <= 0;
      pipeline_stall_count <= 0;
      instructions_per_cycle <= 0.0;
      cache_hit_rate <= 0.0;
      pipeline_efficiency <= 0.0;
    end else begin
      // Call void functions to update metrics
      update_cycle_counter();
      update_instruction_metrics();
      update_cache_metrics();
      update_pipeline_metrics();
      calculate_performance_ratios();
    end
  end

endmodule