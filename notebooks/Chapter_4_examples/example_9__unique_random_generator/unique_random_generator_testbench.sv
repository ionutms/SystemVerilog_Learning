// unique_random_generator_testbench.sv
module unique_random_generator_testbench;  // Testbench module
  unique_random_generator UNIQUE_RANDOM_GENERATOR();  // Instantiate design under test

  // Additional testbench-specific random testing
  class random_test;
    rand bit [7:0] data;
    bit [7:0] prev_value;
    
    function void generate_unique_values();
      int success;
      do begin
        success = randomize();
        if (success == 0) begin
          $error("Randomization failed!");
          break;
        end
      end while (data == prev_value);
      prev_value = data;
    endfunction
  endclass

  initial begin
    random_test tb_rnd_gen;
    
    // Dump waves
    $dumpfile("unique_random_generator_testbench.vcd");       // Specify the VCD file
    $dumpvars(0, unique_random_generator_testbench);          // Dump all variables in the test module
    #1;                                       // Wait for a time unit
    $display("Hello from testbench!");        // Display message
    $display();                               // Display empty line
    
    // Testbench-specific random value testing
    $display("=== Testbench Random Value Verification ===");
    tb_rnd_gen = new();
    
    // Test multiple generations to verify uniqueness
    for (int i = 0; i < 8; i++) begin
      tb_rnd_gen.generate_unique_values();
      $display("TB Test %0d: Generated=0x%02h, Previous=0x%02h, Unique=%s", 
               i+1,
               tb_rnd_gen.data,
               tb_rnd_gen.prev_value,
               (i == 0) ? "N/A" : "YES");
      #5; // Small delay between generations
    end
    
    $display("Testbench verification completed!");
    #10;
    $finish;
  end

endmodule