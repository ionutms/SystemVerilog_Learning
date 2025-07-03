// object_comparison_design_testbench.sv
module object_comparison_testbench;
  
  // Instantiate design under test
  object_comparison_module COMPARISON_INSTANCE();
  
  initial begin
    // Dump waves
    $dumpfile("object_comparison_testbench.vcd");
    $dumpvars(0, object_comparison_testbench);
    
    #1;  // Wait for design to complete
    
    $display("=== Testbench Additional Tests ===");
    $display();
    
    // Additional test with null comparison
    begin
      student_record test_student, null_student;
      
      test_student = new("Charlie", 19, 78);
      null_student = null;
      
      $display("Testing null comparison:");
      test_student.display();
      $display("Test student == null: %s", 
               test_student.is_equal(null_student) ? "TRUE" : "FALSE");
      $display("Test student older than null: %s", 
               test_student.is_older_than(null_student) ? "TRUE" : "FALSE");
      $display();
    end
    
    $display("Object comparison testbench completed!");
    $display();
    
    #10;  // Additional wait time
    $finish;
  end
  
endmodule