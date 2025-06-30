// dynamic_array_processor_testbench.sv
module dynamic_array_testbench;              // Testbench module
  
  // Instantiate design under test
  dynamic_array_processor PROCESSOR_INSTANCE();
  
  // Testbench dynamic arrays for verification
  int verification_array[];
  bit test_results[];
  
  initial begin
    // Dump waves
    $dumpfile("dynamic_array_testbench.vcd"); // Specify the VCD file
    $dumpvars(0, dynamic_array_testbench);    // Dump all variables
    
    #1;                                       // Wait for design to complete
    
    $display();                               // Display empty line
    $display("=== Testbench Verification ===");
    
    // Create verification array with different operations
    verification_array = new[4];             // Allocate 4 elements
    verification_array = '{100, 200, 300, 400}; // Initialize with literal
    
    // Display verification array size and contents
    $display("Verification array: %p", verification_array);
    
    // Test dynamic allocation and deallocation
    test_results = new[3];                    // Allocate test results
    test_results[0] = (verification_array.size() == 4);
    test_results[1] = (verification_array[0] == 100);
    test_results[2] = (verification_array[3] == 400);
    
    $display("Test results: %p", test_results);
    
    // Demonstrate delete operation
    verification_array.delete();             // Delete all elements
    $display("After delete - size: %0d", verification_array.size());
    
    $display("=== Testbench Verification Complete ===");
    $display();                               // Display empty line
    
    #10;                                      // Final delay
    $finish;                                  // End simulation
  end
  
endmodule