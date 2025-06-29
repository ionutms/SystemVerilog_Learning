// random_number_generator.sv
module random_number_generator_module();
  
  // Module-level variable to maintain seed state
  int unsigned seed_value = 32'h1234;  // Initial seed
  
  // Function that maintains seed state between calls
  function int unsigned generate_random_number();
    // Simple LCG: next = (seed * 5 + 7) % 256
    seed_value = (seed_value * 5 + 7) % 256;
    return seed_value;
  endfunction
  
  initial begin
    $display();
    $display("Random Number Generator with Persistent State");
  end

endmodule