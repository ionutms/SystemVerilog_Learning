// unique_random_generator.sv
module unique_random_generator ();               // Design under test
  
  // Test class that generates unique consecutive random values
  class random_test;
    rand bit [7:0] data;
    bit [7:0] prev_value;
    
    // Function to generate values different from previous one
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

  // Design logic with random test functionality
  initial begin
    random_test rnd_gen;
    bit [7:0] value_history[5];
    
    $display();                               // Display empty line
    $display("Hello from design!");          // Display message
    $display("=== Unique Random Value Generation ===");
    
    // Create instance of random test class
    rnd_gen = new();
    
    // Generate and display 5 unique consecutive values
    for (int i = 0; i < 5; i++) begin
      rnd_gen.generate_unique_values();
      value_history[i] = rnd_gen.data;
      
      $display("Generation %0d: Value=0x%02h, Previous=0x%02h", 
               i+1, 
               rnd_gen.data, 
               rnd_gen.prev_value);
    end
    
    $display("Design random generation completed!");
  end

endmodule