// computer_system_testbench.sv
module computer_system_testbench;
  import computer_components_pkg::*;
  
  // Instantiate design under test
  computer_system_module COMPUTER_SYSTEM_INSTANCE();
  
  // Test variables
  computer_class my_computer;
  computer_class office_computer;
  
  initial begin
    // Setup waveform dumping
    $dumpfile("computer_system_testbench.vcd");
    $dumpvars(0, computer_system_testbench);
    
    $display("=== Computer System Testbench ===");
    $display("Testing nested class composition\n");
    
    // Test 1: Create a high-end computer
    $display("TEST 1: Creating high-end computer");
    my_computer = new("Gaming Rig Pro");
    
    // Test 2: Boot the computer
    $display("\nTEST 2: Booting the computer");
    my_computer.boot_system();
    
    // Test 3: Run some applications
    $display("\nTEST 3: Running applications");
    my_computer.run_application("Video Editor", 4096, 50);
    my_computer.run_application("Game Engine", 8192, 100);
    my_computer.run_application("Web Browser", 1024, 2);
    
    // Test 4: Display system information
    $display("\nTEST 4: System information");
    my_computer.display_system_info();
    
    // Test 5: Try to overload the system
    $display("\nTEST 5: Stress testing - overloading system");
    my_computer.run_application("Heavy CAD", 16384, 500);
    
    // Test 6: Create a second computer (office computer)
    $display("\nTEST 6: Creating office computer");
    office_computer = new("Office Desktop");
    office_computer.boot_system();
    office_computer.run_application("Word Processor", 512, 5);
    office_computer.run_application("Spreadsheet", 256, 3);
    
    // Test 7: Compare both computers
    $display("\nTEST 7: Comparing computers");
    $display("--- Gaming Computer ---");
    my_computer.display_system_info();
    $display("--- Office Computer ---");
    office_computer.display_system_info();
    
    // Test 8: Shutdown computers
    $display("\nTEST 8: Shutting down computers");
    my_computer.shutdown();
    office_computer.shutdown();
    
    // Test 9: Test individual component access
    $display("\nTEST 9: Direct component access");
    $display("Accessing nested CPU directly:");
    my_computer.cpu.execute_instruction("Direct CPU command");
    my_computer.cpu.display_info();
    
    $display("Accessing nested RAM directly:");
    void'(my_computer.ram.allocate_memory(100));
    my_computer.ram.display_info();
    
    $display("Accessing nested Storage directly:");
    void'(my_computer.storage.store_data("direct_file.txt", 1));
    my_computer.storage.display_info();
    
    $display("\n=== All tests completed ===");
    
    #10; // Wait before finishing
    $finish;
  end
  
  // Monitor system activity
  initial begin
    $display("Monitor: Testbench started at time %0t", $time);
    #1000;
    $display("Monitor: Long-running simulation timeout at time %0t", $time);
    $finish;
  end
endmodule