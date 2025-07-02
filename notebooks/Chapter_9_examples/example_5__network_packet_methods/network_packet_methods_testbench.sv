// network_packet_methods_testbench.sv
// Chapter 9 Example 5: Network Packet Methods Testbench
// Tests different method types in network packet classes

module network_packet_methods_testbench;
  
  // Test handles
  network_packet_base packet_array[];
  tcp_packet         tcp_test_pkt;
  int                test_count = 0;
  
  // Test task for constructor method
  task test_constructor_method();
    network_packet_base pkt1, pkt2, pkt3;
    
    $display("\n=== Testing Constructor Method ===");
    
    // Test default constructor
    pkt1 = new();
    test_count++;
    
    // Test parameterized constructor
    pkt2 = new(32'hDEADBEEF, 32'hCAFEBABE);
    test_count++;
    
    // Test another constructor call
    pkt3 = new(32'h12345678, 32'h87654321);
    test_count++;
    
    $display("Constructor test completed. Packets created: %0d", test_count);
  endtask
  
  // Test function methods (pure functions, no time delay)
  task test_function_methods();
    network_packet_base test_pkt;
    bit [15:0] checksum1, checksum2;
    
    $display("\n=== Testing Function Methods ===");
    
    test_pkt = new(32'h11111111, 32'h22222222);
    test_pkt.packet_id = 8'hAB;
    test_pkt.packet_size = 16'h1234;
    
    // Call function method multiple times
    checksum1 = test_pkt.calculate_checksum();
    checksum2 = test_pkt.calculate_checksum();
    
    $display("Function method results:");
    $display("  Checksum 1: 0x%04h", checksum1);
    $display("  Checksum 2: 0x%04h", checksum2);
    $display("  Results match: %s", (checksum1 == checksum2) ? "PASS" : "FAIL");
  endtask
  
  // Test virtual methods (can be overridden)
  task test_virtual_methods();
    network_packet_base base_handle;
    tcp_packet         tcp_handle;
    
    $display("\n=== Testing Virtual Methods ===");
    
    // Create base packet
    base_handle = new();
    $display("Base packet type: %s", base_handle.get_packet_type());
    
    // Create TCP packet  
    tcp_handle = new();
    $display("TCP packet type:  %s", tcp_handle.get_packet_type());
    
    // Polymorphism test - base handle pointing to TCP object
    base_handle = tcp_handle;
    $display("Polymorphic call:  %s", base_handle.get_packet_type());
  endtask
  
  // Test static methods (class-level methods)
  task test_static_methods();
    int initial_count, final_count;
    network_packet_base temp_pkt1, temp_pkt2;
    
    $display("\n=== Testing Static Methods ===");
    
    initial_count = network_packet_base::get_total_packet_count();
    $display("Initial packet count: %0d", initial_count);
    
    // Create more packets
    temp_pkt1 = new();
    temp_pkt2 = new();
    
    final_count = network_packet_base::get_total_packet_count();
    $display("Final packet count: %0d", final_count);
    $display("Packets created in test: %0d", final_count - initial_count);
  endtask
  
  // Test task methods (can consume simulation time)
  task test_task_methods();
    tcp_packet test_tcp;
    realtime start_time, end_time;
    
    $display("\n=== Testing Task Methods ===");
    
    test_tcp = new(32'hAABBCCDD, 32'hEEFF1122);
    if (test_tcp.randomize() == 0) $display("Warning: TCP test packet randomization failed");
    
    start_time = $realtime;
    test_tcp.display_packet_info();  // This task has #1ns delay
    end_time = $realtime;
    
    $display("Task execution time: %0t", end_time - start_time);
  endtask
  
  // Main test sequence
  initial begin
    // Dump waves for debugging
    $dumpfile("network_packet_methods_testbench.vcd");
    $dumpvars(0, network_packet_methods_testbench);
    
    $display("=== Network Packet Methods Testbench ===");
    $display("Testing various method types in SystemVerilog classes\n");
    
    // Run individual tests
    test_constructor_method();
    test_function_methods();
    test_virtual_methods();
    test_static_methods();
    test_task_methods();
    
    $display("\n=== All Tests Completed ===");
    $display("Final packet count: %0d", 
             network_packet_base::get_total_packet_count());
    
    #10ns;  // Allow time for any pending operations
    $finish;
  end
  
endmodule