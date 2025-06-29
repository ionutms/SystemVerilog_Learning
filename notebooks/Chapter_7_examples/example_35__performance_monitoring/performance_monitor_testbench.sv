// performance_monitor_testbench.sv
module performance_monitor_testbench;

  // Clock and reset signals
  logic clk;
  logic reset_n;
  
  // CPU activity signals
  logic instruction_valid;
  logic cache_hit;
  logic cache_miss;
  logic pipeline_stall;

  // Instantiate the performance monitor
  cpu_performance_monitor PERFORMANCE_MONITOR_INSTANCE (
    .clk(clk),
    .reset_n(reset_n),
    .instruction_valid(instruction_valid),
    .cache_hit(cache_hit),
    .cache_miss(cache_miss),
    .pipeline_stall(pipeline_stall)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns period, 100MHz
  end

  // Void function to simulate instruction execution
  function void simulate_instruction_execution();
    instruction_valid = 1;
    cache_hit = ($random % 10) < 8;  // 80% cache hit rate
    cache_miss = !cache_hit;
    pipeline_stall = ($random % 10) < 2;  // 20% stall rate
  endfunction

  // Void function to simulate idle cycle
  function void simulate_idle_cycle();
    instruction_valid = 0;
    cache_hit = 0;
    cache_miss = 0;
    pipeline_stall = 0;
  endfunction

  // Void function to reset performance monitor
  function void reset_performance_monitor();
    $display("Resetting CPU Performance Monitor...");
    reset_n = 0;
    instruction_valid = 0;
    cache_hit = 0;
    cache_miss = 0;
    pipeline_stall = 0;
    #20;
    reset_n = 1;
    #10;
  endfunction

  // Test sequence
  initial begin
    // Setup waveform dumping
    $dumpfile("performance_monitor_testbench.vcd");
    $dumpvars(0, performance_monitor_testbench);
    
    $display("Starting CPU Performance Monitor Test");
    $display();

    // Initialize and reset
    reset_performance_monitor();

    // Simulate 50 cycles of CPU activity
    $display("Simulating 50 cycles of CPU activity...");
    repeat(50) begin
      @(posedge clk);
      if (($random % 10) < 8) begin
        simulate_instruction_execution();
      end else begin
        simulate_idle_cycle();
      end
    end

    // Wait a few cycles and display intermediate results
    repeat(5) @(posedge clk);
    $display();
    $display("Intermediate Performance Results:");
    PERFORMANCE_MONITOR_INSTANCE.display_performance_summary();
    $display();

    // Continue simulation for another 30 cycles
    $display("Continuing simulation for 30 more cycles...");
    repeat(30) begin
      @(posedge clk);
      simulate_instruction_execution();
    end

    // Final performance summary
    repeat(5) @(posedge clk);
    $display();
    $display("Final Performance Results:");
    PERFORMANCE_MONITOR_INSTANCE.display_performance_summary();
    $display();

    $display("CPU Performance Monitor Test Complete");
    $finish;
  end

endmodule