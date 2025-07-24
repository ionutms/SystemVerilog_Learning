// handle_array_management_testbench.sv
module test_bench_module;
  import data_packet_pkg::*;
  
  // Instantiate design under test
  design_module_name DESIGN_INSTANCE_NAME();
  
  // Additional testbench demonstration
  data_packet_class test_packet_array[3];
  data_packet_class reference_array[2];
  data_packet_class original_handle;
  data_packet_class mixed_array[3];
  
  initial begin
    // Dump waves
    $dumpfile("test_bench_module.vcd");
    $dumpvars(0, test_bench_module);
    #1;
    
    $display("=== Testbench Handle Array Tests ===");
    
    // Test 1: Create and populate array
    $display("\n--- Test 1: Array Creation ---");
    test_packet_array[0] = new(1001, "test_data_1");
    test_packet_array[1] = new(1002, "test_data_2");
    test_packet_array[2] = new(1003, "test_data_3");
    
    foreach(test_packet_array[i]) begin
      $display("test_packet_array[%0d]:", i);
      test_packet_array[i].display_packet_info();
    end
    
    // Test 2: Multiple handles to same object
    $display("\n--- Test 2: Multiple Handle References ---");
    reference_array[0] = test_packet_array[0]; // Same object
    reference_array[1] = test_packet_array[0]; // Same object again
    
    $display("Before modification:");
    test_packet_array[0].display_packet_info();
    
    // Modify through reference_array[0]
    reference_array[0].update_payload("modified_by_reference");
    
    $display("After modification through reference_array[0]:");
    $display("test_packet_array[0]:");
    test_packet_array[0].display_packet_info();
    $display("reference_array[1]:");
    reference_array[1].display_packet_info();
    
    // Test 3: Handle reassignment
    $display("\n--- Test 3: Handle Reassignment ---");
    original_handle = test_packet_array[1];
    $display("Original handle points to:");
    original_handle.display_packet_info();
    
    // Reassign handle to different object
    original_handle = test_packet_array[2];
    $display("After reassignment, handle points to:");
    original_handle.display_packet_info();
    $display("Original test_packet_array[1] unchanged:");
    test_packet_array[1].display_packet_info();
    
    // Test 4: Null handle in array
    $display("\n--- Test 4: Null Handle Management ---");
    mixed_array[0] = new(2001, "valid_packet");
    mixed_array[1] = null; // Null handle
    mixed_array[2] = new(2003, "another_valid");
    
    foreach(mixed_array[i]) begin
      if (mixed_array[i] != null) begin
        $display("mixed_array[%0d] is valid:", i);
        mixed_array[i].display_packet_info();
      end else begin
        $display("mixed_array[%0d] is null", i);
      end
    end
    
    $display("\nHello from testbench!");
    $display();
  end
  
endmodule