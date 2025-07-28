// data_processor_testbench.sv
module template_method_testbench;
  import data_processor_pkg::*;
  
  data_processor_module DESIGN_INSTANCE();
  
  // Test data
  int test_data[5];
  int working_data[5];
  
  // Create instances of different processors
  doubler_processor  doubler;
  squarer_processor  squarer;
  adder_processor    adder;
  base_data_processor processor_queue[$];
  
  initial begin
    // Dump waves
    $dumpfile("template_method_testbench.vcd");
    $dumpvars(0, template_method_testbench);
    
    $display("\n=== Template Method Pattern Demonstration ===");
    
    // Initialize test data
    test_data[0] = 1;
    test_data[1] = 2;
    test_data[2] = 3;
    test_data[3] = 4;
    test_data[4] = 5;
    
    // Initialize processors
    doubler = new();
    squarer = new();
    adder = new();
    
    // Add to queue (polymorphism)
    processor_queue.push_back(doubler);
    processor_queue.push_back(squarer);
    processor_queue.push_back(adder);
    
    // Process data with each processor using template method
    foreach (processor_queue[i]) begin
      $display("\n--- Processing with %s ---", 
               processor_queue[i].processor_name);
      
      // Copy original data for each processor
      working_data = test_data;
      $write("Original data: ");
      foreach (working_data[j]) $write("%0d ", working_data[j]);
      $display("");
      
      // Call template method - same interface, different behavior
      processor_queue[i].process_data(working_data);
    end
    
    $display("\n=== Demonstrating Template Method Structure ===");
    $display("1. Base class defines algorithm skeleton in process_data()");
    $display("2. Common steps (validate_input) implemented in base class");
    $display("3. Variable steps (transform_data, store_results) are pure");
    $display("4. Each derived class implements specific transformation");
    $display("5. Same algorithm flow, different implementations");
    
    #10;
    $finish;
  end

endmodule