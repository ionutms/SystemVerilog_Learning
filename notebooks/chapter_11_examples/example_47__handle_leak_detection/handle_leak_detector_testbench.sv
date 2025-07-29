// handle_leak_detector_testbench.sv
module leak_detection_testbench;
  import leak_detection_pkg::*;
  
  handle_leak_detector LEAK_DETECTOR_INSTANCE();
  
  initial begin
    // Setup waveform dumping
    $dumpfile("leak_detection_testbench.vcd");
    $dumpvars(0, leak_detection_testbench);
    
    $display("=== Starting Handle Leak Detection Test ===");
    $display();
    
    // Test 1: Proper resource cleanup (no leaks)
    $display("--- Test 1: Proper Resource Management ---");
    test_proper_cleanup();
    #10;
    
    // Test 2: Resource leaks scenario
    $display("--- Test 2: Resource Leak Scenario ---");
    test_resource_leaks();
    #10;
    
    // Test 3: Mixed scenario
    $display("--- Test 3: Mixed Cleanup Scenario ---");
    test_mixed_scenario();
    #10;
    
    // Final leak detection report
    $display("--- Final System Status ---");
    leak_detector::report_status();
    
    $display();
    $display("=== Handle Leak Detection Test Complete ===");
    $finish;
  end
  
  task test_proper_cleanup();
    file_handle fh1, fh2;
    network_connection nc1;
    
    $display("Creating resources with proper cleanup...");
    
    // Create and properly cleanup file handles
    fh1 = new("config.txt");
    fh2 = new("data.log");
    
    // Create network connection
    nc1 = new("server.com", 8080);
    
    #5;
    
    // Proper cleanup
    fh1.destroy();
    fh2.destroy();
    nc1.destroy();
    
    leak_detector::report_status();
  endtask
  
  task test_resource_leaks();
    file_handle fh_leak1, fh_leak2;
    network_connection nc_leak;
    
    $display("Creating resources WITHOUT proper cleanup...");
    
    // Create resources but don't clean them up
    fh_leak1 = new("temp1.txt");
    fh_leak2 = new("temp2.txt");
    nc_leak = new("api.example.com", 443);
    
    #5;
    
    // Intentionally NOT calling destroy() to simulate leaks
    $display("Simulating program end without cleanup...");
    
    leak_detector::report_status();
  endtask
  
  task test_mixed_scenario();
    file_handle fh_good, fh_bad;
    network_connection nc_good, nc_bad;
    
    $display("Creating mixed cleanup scenario...");
    
    // Create multiple resources
    fh_good = new("good_file.txt");
    fh_bad = new("bad_file.txt");
    nc_good = new("good-server.com", 80);
    nc_bad = new("bad-server.com", 8080);
    
    #3;
    
    // Clean up only some resources
    $display("Cleaning up only some resources...");
    fh_good.destroy();
    nc_good.destroy();
    
    // fh_bad and nc_bad are leaked
    
    leak_detector::report_status();
  endtask
  
endmodule