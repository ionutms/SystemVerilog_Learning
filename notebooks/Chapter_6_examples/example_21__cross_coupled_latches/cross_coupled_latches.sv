// cross_coupled_latches.sv
// Cross-coupled NOR latches demonstrating race conditions in feedback systems
module cross_coupled_latches (
  input  logic set_n,    // Active-low set input
  input  logic reset_n,  // Active-low reset input
  output logic q,        // Latch output Q
  output logic q_n       // Latch output Q_bar (complement)
);

  // Cross-coupled NOR gates with propagation delays
  // These delays can cause race conditions and metastability
  
  always_comb begin
    // NOR gate 1: q_n = ~(set_n | q)
    #2 q_n = ~(set_n | q);
  end
  
  always_comb begin
    // NOR gate 2: q = ~(reset_n | q_n)  
    #2 q = ~(reset_n | q_n);
  end

  // Monitor for race conditions
  always @(set_n, reset_n) begin
    if (set_n == 0 && reset_n == 0) begin
      $display("WARNING: Race condition! Both SET and RESET active at time %0t", $time);
    end
  end

endmodule