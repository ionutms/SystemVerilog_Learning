// cross_coupled_latches_testbench.sv
module cross_coupled_latches_testbench;

  // Testbench signals
  logic set_n, reset_n;
  logic q, q_n;
  
  // Instantiate the cross-coupled latches
  cross_coupled_latches LATCH_INSTANCE (
    .set_n(set_n),
    .reset_n(reset_n),
    .q(q),
    .q_n(q_n)
  );

  initial begin
    // Dump waves for analysis
    $dumpfile("cross_coupled_latches_testbench.vcd");
    $dumpvars(0, cross_coupled_latches_testbench);
    
    $display("Cross-Coupled Latches Race Condition Demo");
    $display("==========================================");
    
    // Initialize - both inputs inactive (high)
    set_n = 1'b1;
    reset_n = 1'b1;
    #10;
    $display("Initial state: SET_N=%b, RESET_N=%b, Q=%b, Q_N=%b", set_n, reset_n, q, q_n);
    
    // Test normal SET operation
    $display("\n--- Testing SET operation ---");
    set_n = 1'b0;  // Activate SET
    #10;
    $display("After SET: SET_N=%b, RESET_N=%b, Q=%b, Q_N=%b", set_n, reset_n, q, q_n);
    
    set_n = 1'b1;  // Deactivate SET
    #10;
    $display("SET released: SET_N=%b, RESET_N=%b, Q=%b, Q_N=%b", set_n, reset_n, q, q_n);
    
    // Test normal RESET operation
    $display("\n--- Testing RESET operation ---");
    reset_n = 1'b0;  // Activate RESET
    #10;
    $display("After RESET: SET_N=%b, RESET_N=%b, Q=%b, Q_N=%b", set_n, reset_n, q, q_n);
    
    reset_n = 1'b1;  // Deactivate RESET
    #10;
    $display("RESET released: SET_N=%b, RESET_N=%b, Q=%b, Q_N=%b", set_n, reset_n, q, q_n);
    
    // Demonstrate RACE CONDITION - both inputs active simultaneously
    $display("\n--- RACE CONDITION TEST ---");
    $display("Activating both SET and RESET simultaneously...");
    set_n = 1'b0;
    reset_n = 1'b0;
    #15;
    $display("Both active: SET_N=%b, RESET_N=%b, Q=%b, Q_N=%b", set_n, reset_n, q, q_n);
    
    // Release both at slightly different times to show unpredictable behavior
    $display("Releasing SET first...");
    set_n = 1'b1;
    #3;
    $display("SET released: SET_N=%b, RESET_N=%b, Q=%b, Q_N=%b", set_n, reset_n, q, q_n);
    
    reset_n = 1'b1;
    #10;
    $display("Both released: SET_N=%b, RESET_N=%b, Q=%b, Q_N=%b", set_n, reset_n, q, q_n);
    
    // Try the race condition again, but release RESET first this time
    $display("\n--- Second RACE CONDITION TEST ---");
    $display("Again activating both SET and RESET...");
    set_n = 1'b0;
    reset_n = 1'b0;
    #15;
    $display("Both active: SET_N=%b, RESET_N=%b, Q=%b, Q_N=%b", set_n, reset_n, q, q_n);
    
    $display("Releasing RESET first this time...");
    reset_n = 1'b1;
    #3;
    $display("RESET released: SET_N=%b, RESET_N=%b, Q=%b, Q_N=%b", set_n, reset_n, q, q_n);
    
    set_n = 1'b1;
    #10;
    $display("Both released: SET_N=%b, RESET_N=%b, Q=%b, Q_N=%b", set_n, reset_n, q, q_n);
    
    $display("\n==========================================");
    $display("Simulation complete - Check VCD for timing details");
    $display("Notice how race conditions create unpredictable states!");
    
    $finish;
  end

endmodule