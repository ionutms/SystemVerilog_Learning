// counter_class_with_this_testbench.sv
module counter_class_testbench;

  // Import the Counter class from package
  import counter_pkg::*;

  // Instantiate the design under test
  counter_class_module DUT();

  initial begin
    // Dump waves for simulation
    $dumpfile("counter_class_testbench.vcd");
    $dumpvars(0, counter_class_testbench);
    
    $display("=== Testbench for Counter Class with 'this' ===");
    $display();
    
    // Wait for design to complete
    #100;
    
    $display();
    $display("=== Additional Testbench Verification ===");
    
    // Create additional counter instances to verify class functionality
    begin
      Counter test_counter1, test_counter2;
      
      // Test different initialization values
      test_counter1 = new(0, 5);
      test_counter2 = new(100, 10);
      
      $display("Test Counter 1 (start=0, step=5):");
      test_counter1.display();
      test_counter1.increment();
      test_counter1.increment();
      test_counter1.display();
      $display();
      
      $display("Test Counter 2 (start=100, step=10):");
      test_counter2.display();
      test_counter2.decrement();
      test_counter2.display();
      $display();
      
      // Verify get_count method
      $display("Counter 1 final value: %0d", test_counter1.get_count());
      $display("Counter 2 final value: %0d", test_counter2.get_count());
    end
    
    $display();
    $display("=== Testbench Complete ===");
    $finish;
  end

endmodule