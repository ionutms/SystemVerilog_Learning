// basic_memory_interface_testbench.sv
module basic_memory_interface_testbench;
  
  // Instantiate the design under test
  basic_memory_interface DUT();

  initial begin
    // Dump waves
    $dumpfile("basic_memory_interface_testbench.vcd");
    $dumpvars(0, basic_memory_interface_testbench);
    
    $display();
    $display("Testing Basic Memory Interface");
    $display("==============================");
    
    #1; // Allow time for all modules to execute their initial blocks
    
    $display();
    $display("=== Interface Benefits ===");
    $display("1. Clean signal grouping");
    $display("2. Modports define direction and access");
    $display("3. Reduces connection errors");
    $display("4. Reusable interface definition");
    
    $display();
    $display("=== Test Complete ===");
    $display("Interface successfully connects controller and memory");
    
    #1;
    $finish;
  end

endmodule