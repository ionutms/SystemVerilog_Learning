// resource_manager_testbench.sv
module resource_manager_testbench;

  // Import the resource tracking package
  import resource_pkg::*;

  // Import the design module
  resource_manager_module RESOURCE_MANAGER_INSTANCE();

  // Test task to demonstrate resource tracking
  task run_resource_test();
    // Create some resource instances using automatic variables
    automatic ResourceTracker memory_pool;
    automatic ResourceTracker file_handle;
    automatic ResourceTracker network_socket;
    automatic ResourceTracker database_conn;
    
    $display("Creating resources...");
    memory_pool = new("Memory Pool");
    file_handle = new("File Handle");
    network_socket = new("Network Socket");
    
    $display();
    ResourceTracker::print_stats();
    $display();
    
    // Display individual resource info
    $display("Individual resource information:");
    memory_pool.display_info();
    file_handle.display_info();
    network_socket.display_info();
    
    $display();
    $display("Cleaning up resources...");
    memory_pool.cleanup();
    file_handle.cleanup();
    
    $display();
    ResourceTracker::print_stats();
    
    $display();
    $display("Creating additional resource...");
    database_conn = new("Database Connection");
    
    $display();
    ResourceTracker::print_stats();
    
    $display();
    $display("Final cleanup...");
    network_socket.cleanup();
    database_conn.cleanup();
    
    $display();
    ResourceTracker::print_stats();
    
  endtask

  initial begin
    // Dump waves for verilator
    $dumpfile("resource_manager_testbench.vcd");
    $dumpvars(0, resource_manager_testbench);
    
    $display("=== Resource Tracking Example ===");
    $display();
    
    // Run the test
    run_resource_test();
    
    $display();
    $display("=== Resource Tracking Complete ===");
    
    #1;  // Wait for a time unit
  end

endmodule