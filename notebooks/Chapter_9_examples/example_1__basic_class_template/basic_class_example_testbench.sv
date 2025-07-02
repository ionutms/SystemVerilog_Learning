// basic_class_example_testbench.sv
import counter_pkg::*;                      // Import all items from package

module basic_class_test_bench;              // Testbench module
  simple_counter_class my_counter;          // Class handle (object reference)
  simple_counter_class second_counter;      // Another class handle
  
  initial begin
    // Dump waves for simulation
    $dumpfile("basic_class_test_bench.vcd");
    $dumpvars(0, basic_class_test_bench);
    
    $display("=== Basic Class Template Example (Package Version) ===");
    $display();
    
    // Create first counter object
    my_counter = new("primary_counter");    // Instantiate class object
    
    // Test basic operations on first counter
    my_counter.increment();                 // Call increment method
    my_counter.increment();                 // Increment again
    my_counter.increment();                 // One more time
    
    $display("Current count: %0d", my_counter.get_count());
    $display();
    
    // Create second counter object with different name
    second_counter = new("backup_counter"); // Another object instance
    
    // Test operations on second counter
    second_counter.increment();             // This counter is independent
    $display("Second counter: %0d", second_counter.get_count());
    $display("First counter still: %0d", my_counter.get_count());
    $display();
    
    // Test reset functionality
    my_counter.reset();                     // Reset first counter
    $display("After reset: %0d", my_counter.get_count());
    
    $display();
    $display("=== Package-Based Class Example Complete ===");
    
    #1;                                     // Wait for a time unit
  end

endmodule