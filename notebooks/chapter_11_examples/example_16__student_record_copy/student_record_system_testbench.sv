// student_record_system_testbench.sv
module student_testbench;
  import student_pkg::*;
  
  // Instantiate design module
  student_record_module STUDENT_SYSTEM_INSTANCE();
  
  // Test variables
  Student original_student;
  Student copied_student;
  Student duplicate_student;
  
  initial begin
    // Setup VCD dumping for Verilator
    $dumpfile("student_testbench.vcd");
    $dumpvars(0, student_testbench);
    
    $display("\n=== Student Record Copy Constructor Test ===\n");
    
    // Test 1: Create original student
    $display("TEST 1: Creating original student record");
    original_student = new("Alice Johnson", 12345, 20, 3.75, 
                          "Computer Science");
    original_student.display_info();
    
    #10;
    
    // Test 2: Copy constructor - identical student
    $display("\nTEST 2: Using copy constructor");
    copied_student = original_student.copy();
    $display("Original student info:");
    original_student.display_info();
    $display("Copied student info:");
    copied_student.display_info();
    
    // Verify they are identical
    if (original_student.is_identical(copied_student)) begin
      $display("[PASS] Copy constructor created identical record");
    end else begin
      $display("[FAIL] Copy constructor failed to create identical record");
    end
    
    #10;
    
    // Test 3: Copy with new ID for duplicate records
    $display("\nTEST 3: Copy with modified ID");
    duplicate_student = original_student.copy_with_new_id(99999);
    duplicate_student.display_info();
    
    // Verify original is unchanged
    $display("Original student after copying:");
    original_student.display_info();
    
    #10;
    
    // Test 4: Modify copied student to show independence
    $display("\nTEST 4: Testing independence of copied objects");
    $display("Updating copied student's GPA...");
    copied_student.update_gpa(3.95);
    
    $display("Original student (should be unchanged):");
    original_student.display_info();
    $display("Modified copied student:");
    copied_student.display_info();
    
    // Verify they are no longer identical
    if (!original_student.is_identical(copied_student)) begin
      $display("[PASS] Copied objects are independent");
    end else begin
      $display("[FAIL] Copied objects are not independent");
    end
    
    #10;
    
    // Test 5: Multiple copies
    $display("\nTEST 5: Creating multiple copies");
    for (int i = 0; i < 3; i++) begin
      Student temp_student;
      temp_student = original_student.copy_with_new_id(50000 + i);
      $display("Copy %0d created with ID: %0d", i+1, 50000+i);
      temp_student.display_info();
      #5;
    end
    
    $display("\n=== All tests completed successfully! ===\n");
    
    #50;
    $finish;
  end
  
endmodule