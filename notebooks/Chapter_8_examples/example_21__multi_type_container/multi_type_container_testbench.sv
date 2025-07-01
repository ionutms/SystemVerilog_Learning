// multi_type_container_testbench.sv
module multi_type_container_testbench;

  // Instantiate the multi-type container
  multi_type_container CONTAINER_INSTANCE();

  initial begin
    // Dump waves
    $dumpfile("multi_type_container_testbench.vcd");
    $dumpvars(0, multi_type_container_testbench);
    
    $display("=== Multi-Type Container Example ===");
    $display();

    // Test storing different types of data
    $display("--- Testing Integer Storage ---");
    CONTAINER_INSTANCE.store_integer(42);
    CONTAINER_INSTANCE.display_container();
    $display("Type: %s", CONTAINER_INSTANCE.get_container_type());
    $display();

    $display("--- Testing String Storage ---");
    CONTAINER_INSTANCE.store_string("Hello SystemVerilog!");
    CONTAINER_INSTANCE.display_container();
    $display("Type: %s", CONTAINER_INSTANCE.get_container_type());
    $display();

    $display("--- Testing Float Storage ---");
    CONTAINER_INSTANCE.store_float(3.14159);
    CONTAINER_INSTANCE.display_container();
    $display("Type: %s", CONTAINER_INSTANCE.get_container_type());
    $display();

    $display("--- Testing Type Safety ---");
    CONTAINER_INSTANCE.store_integer(-100);
    $display("After storing new integer:");
    CONTAINER_INSTANCE.display_container();
    $display("Type: %s", CONTAINER_INSTANCE.get_container_type());
    $display();

    $display("--- Testing Container State Management ---");
    $display("Is container empty? %s", 
             CONTAINER_INSTANCE.is_empty() ? "Yes" : "No");
    
    CONTAINER_INSTANCE.clear_container();
    CONTAINER_INSTANCE.display_container();
    $display("Is container empty? %s", 
             CONTAINER_INSTANCE.is_empty() ? "Yes" : "No");
    $display();

    $display("--- Final Test ---");
    CONTAINER_INSTANCE.store_string("Final test complete!");
    CONTAINER_INSTANCE.display_container();
    $display("Type: %s", CONTAINER_INSTANCE.get_container_type());
    $display();

    $display("=== Test Complete ===");
    
    #1; // Small delay
    $finish;
  end

endmodule