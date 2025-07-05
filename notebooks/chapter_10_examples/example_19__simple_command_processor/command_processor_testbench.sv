// command_processor_testbench.sv
import command_processor_pkg::*;

module command_processor_testbench;
  
  // Instantiate design under test
  command_processor_module DUT();
  
  // Test environment
  command_processor test_processor;
  
  // Test command instances
  save_command single_save, batch_save, poly_save;
  load_command batch_load, poly_load;
  delete_command batch_delete, poly_delete;
  base_command poly_commands[$];
  
  initial begin
    // Dump waves for verilator
    $dumpfile("command_processor_testbench.vcd");
    $dumpvars(0, command_processor_testbench);
    
    $display("=== Command Processor Testbench ===");
    $display();
    
    // Wait for design to complete
    #1;
    
    $display("--- Testbench Additional Tests ---");
    
    // Create separate processor for testbench
    test_processor = new();
    
    // Test 1: Empty queue execution
    $display("Test 1: Execute empty queue");
    test_processor.execute_all();
    $display();
    
    // Test 2: Single command test
    $display("Test 2: Single command execution");
    single_save = new("single_test.txt");
    test_processor.add_command(single_save);
    test_processor.execute_all();
    test_processor.clear_queue();
    $display();
    
    // Test 3: Mixed command types
    $display("Test 3: Mixed command batch");
    batch_load = new("batch_input.csv");
    batch_delete = new("old_data.tmp");
    batch_save = new("processed_output.json");
    
    test_processor.add_command(batch_load);
    test_processor.add_command(batch_delete);
    test_processor.add_command(batch_save);
    
    $display("Queue size before execution: %0d", 
             test_processor.get_queue_size());
    test_processor.execute_all();
    $display("Queue size after execution: %0d", 
             test_processor.get_queue_size());
    $display();
    
    // Test 4: Polymorphism demonstration
    $display("Test 4: Polymorphism with base class handle");
    poly_save = new("poly_save.bin");
    poly_load = new("poly_load.hex");
    poly_delete = new("poly_temp.cache");
    
    // Store different command types in base class queue
    poly_commands.push_back(poly_save);
    poly_commands.push_back(poly_load);
    poly_commands.push_back(poly_delete);
    
    $display("Executing commands through base class handles:");
    foreach (poly_commands[i]) begin
      $display("Command %0d: %s", i+1, poly_commands[i].get_name());
      poly_commands[i].execute();
    end
    $display();
    
    #10;
    
    $display("=== All Tests Complete ===");
    $display();
    
    $finish;
  end

endmodule