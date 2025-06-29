// random_number_generator_testbench.sv
module random_generator_testbench;
  
  // Instantiate the random number generator module
  random_number_generator_module RNG_INSTANCE();
  
  int unsigned random_value;
  
  initial begin
    // Dump waves for simulation
    $dumpfile("random_generator_testbench.vcd");
    $dumpvars(0, random_generator_testbench);
    
    $display();
    $display("Testing Static Function Random Generator");
    
    // Generate 5 random numbers to show static state persistence
    repeat(5) begin
      #1;
      random_value = RNG_INSTANCE.generate_random_number();
      $display("Random number: %0d", random_value);
    end
    
    $display();
    $display("Static function maintains seed between calls");
    
    #5;
    $finish;
  end

endmodule