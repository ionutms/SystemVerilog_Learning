// generic_counter_testbench.sv
`include "generic_counter.sv"

module generic_counter_testbench;
  
  // Import the counter package
  import counter_pkg::*;
  
  // Declare counter instances with different parameters
  generic_counter #(.WIDTH(4), .INCREMENT(1)) counter_4bit_inc1;
  generic_counter #(.WIDTH(8), .INCREMENT(3)) counter_8bit_inc3;
  generic_counter #(.WIDTH(6), .INCREMENT(7)) counter_6bit_inc7;
  
  initial begin
    // Set up waveform dumping
    $dumpfile("generic_counter_testbench.vcd");
    $dumpvars(0, generic_counter_testbench);
    
    $display("=== Generic Counter Test Starting ===");
    $display();
    
    // Create counter instances
    counter_4bit_inc1 = new();
    counter_8bit_inc3 = new();
    counter_6bit_inc7 = new();
    
    $display();
    $display("=== Testing 4-bit Counter (increment=1) ===");
    test_4bit_counter();
    
    $display();
    $display("=== Testing 8-bit Counter (increment=3) ===");
    test_8bit_counter();
    
    $display();
    $display("=== Testing 6-bit Counter (increment=7) ===");
    test_6bit_counter();
    
    $display();
    $display("=== All Tests Complete ===");
    $finish;
  end
  
  // Task to test 4-bit counter
  task test_4bit_counter();
    $display("Testing 4-bit counter basic functionality:");
    
    // Display initial status
    counter_4bit_inc1.display_status();
    
    // Increment several times
    for (int i = 0; i < 5; i++) begin
      counter_4bit_inc1.increment();
      $display("After increment %0d: count = %0d, overflow = %0b", 
               i+1, counter_4bit_inc1.get_count(), 
               counter_4bit_inc1.get_overflow_flag());
    end
    
    // Reset and verify
    counter_4bit_inc1.reset();
    counter_4bit_inc1.display_status();
    
  endtask
  
  // Task to test 8-bit counter
  task test_8bit_counter();
    $display("Testing 8-bit counter basic functionality:");
    
    // Display initial status
    counter_8bit_inc3.display_status();
    
    // Increment several times
    for (int i = 0; i < 5; i++) begin
      counter_8bit_inc3.increment();
      $display("After increment %0d: count = %0d, overflow = %0b", 
               i+1, counter_8bit_inc3.get_count(), 
               counter_8bit_inc3.get_overflow_flag());
    end
    
    // Reset and verify
    counter_8bit_inc3.reset();
    counter_8bit_inc3.display_status();
    
  endtask
  
  // Task to test 6-bit counter overflow behavior
  task test_6bit_counter();
    int max_val;
    int increment_count;
    
    $display("Testing 6-bit counter overflow behavior:");
    
    /* verilator lint_off WIDTHEXPAND */
    max_val = int'(counter_6bit_inc7.get_max_value());
    /* verilator lint_on WIDTHEXPAND */
    increment_count = 0;
    
    // Increment until overflow occurs
    while (!counter_6bit_inc7.get_overflow_flag() && increment_count < 20) begin
      counter_6bit_inc7.increment();
      increment_count++;
      $display("Increment %0d: count = %0d (max = %0d)", 
               increment_count, counter_6bit_inc7.get_count(), max_val);
    end
    
    // Continue a few more increments to show wrap-around behavior
    if (counter_6bit_inc7.get_overflow_flag()) begin
      $display("Overflow detected! Continuing to show wrap-around...");
      for (int i = 0; i < 3; i++) begin
        counter_6bit_inc7.increment();
        $display("After overflow increment %0d: count = %0d", 
                 i+1, counter_6bit_inc7.get_count());
      end
    end
    
    counter_6bit_inc7.display_status();
    
  endtask

endmodule