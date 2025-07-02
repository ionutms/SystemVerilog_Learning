// object_assignment_demo_testbench.sv
module object_assignment_testbench;
  object_assignment_demo DESIGN_INSTANCE();
  
  initial begin
    data_packet original_packet;
    data_packet shallow_copy_packet;
    data_packet deep_copy_packet;
    
    // Dump waves
    $dumpfile("object_assignment_testbench.vcd");
    $dumpvars(0, object_assignment_testbench);
    
    $display("=== Object Assignment Demo ===");
    $display();
    
    // Create original packet
    original_packet = new(101, "Important Data", 5);
    $display("1. Original packet created:");
    original_packet.display_packet("   ");
    $display();
    
    // Shallow copy (handle assignment)
    $display("2. Performing SHALLOW COPY (handle assignment):");
    shallow_copy_packet = original_packet;  // Same object, different handle
    $display("   shallow_copy_packet = original_packet;");
    shallow_copy_packet.display_packet("   Shallow copy: ");
    $display();
    
    // Modify original packet
    $display("3. Modifying original packet payload:");
    original_packet.payload = "Modified Data";
    $display("   original_packet.payload = \"Modified Data\";");
    $display("   Original packet after modification:");
    original_packet.display_packet("   ");
    $display("   Shallow copy packet (same object!):");
    shallow_copy_packet.display_packet("   ");
    $display("   --> Both changed because they point to same object!");
    $display();
    
    // Deep copy demonstration
    $display("4. Performing DEEP COPY (creating new object):");
    original_packet.payload = "Original Data";  // Reset for demo
    deep_copy_packet = original_packet.deep_copy();
    $display("   deep_copy_packet = original_packet.deep_copy();");
    deep_copy_packet.display_packet("   Deep copy: ");
    $display();
    
    // Modify original packet again
    $display("5. Modifying original packet priority:");
    original_packet.priority_level = 10;
    $display("   original_packet.priority_level = 10;");
    $display("   Original packet after modification:");
    original_packet.display_packet("   ");
    $display("   Deep copy packet (independent object!):");
    deep_copy_packet.display_packet("   ");
    $display("   --> Deep copy unchanged - it's a separate object!");
    $display();
    
    $display("=== Summary ===");
    $display("Shallow copy: Same object, different handle names");
    $display("Deep copy:    New object with copied values");
    $display();
    
    #1;
  end
endmodule