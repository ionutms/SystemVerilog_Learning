// student_grade_storage_testbench.sv
module grade_lookup_testbench;
  // Instantiate the student grade manager
  student_grade_manager GRADE_MANAGER_INSTANCE();
  
  int found_grade;
  
  initial begin
    // Dump waves
    $dumpfile("grade_lookup_testbench.vcd");
    $dumpvars(0, grade_lookup_testbench);
    
    $display("=== Student Grade Lookup System Test ===\n");
    
    // Test 1: Add students and grades
    $display("Test 1: Adding student grades");
    GRADE_MANAGER_INSTANCE.add_student_grade("Alice Johnson", 95);
    GRADE_MANAGER_INSTANCE.add_student_grade("Bob Smith", 87);
    GRADE_MANAGER_INSTANCE.add_student_grade("Carol Williams", 92);
    GRADE_MANAGER_INSTANCE.add_student_grade("David Brown", 78);
    GRADE_MANAGER_INSTANCE.add_student_grade("Emma Davis", 89);
    $display();
    
    // Test 2: Display all grades
    $display("Test 2: Display all student grades");
    GRADE_MANAGER_INSTANCE.display_all_grades();
    
    // Test 3: Lookup existing students
    $display("Test 3: Looking up existing students");
    found_grade = GRADE_MANAGER_INSTANCE.lookup_student_grade("Alice Johnson");
    $display("Alice Johnson's grade: %0d", found_grade);
    
    found_grade = GRADE_MANAGER_INSTANCE.lookup_student_grade("David Brown");
    $display("David Brown's grade: %0d", found_grade);
    $display();
    
    // Test 4: Lookup non-existing student
    $display("Test 4: Looking up non-existing student");
    found_grade = GRADE_MANAGER_INSTANCE.lookup_student_grade("John Doe");
    $display();
    
    // Test 5: Update existing student grade
    $display("Test 5: Updating existing student grade");
    GRADE_MANAGER_INSTANCE.add_student_grade("Bob Smith", 91);
    found_grade = GRADE_MANAGER_INSTANCE.lookup_student_grade("Bob Smith");
    $display("Bob Smith's updated grade: %0d", found_grade);
    $display();
    
    // Test 6: Check student count
    $display("Test 6: Total student count");
    $display("Number of students: %0d", 
             GRADE_MANAGER_INSTANCE.get_student_count());
    $display();
    
    // Test 7: Remove a student
    $display("Test 7: Removing a student");
    GRADE_MANAGER_INSTANCE.remove_student("Carol Williams");
    $display("After removal - Number of students: %0d",
             GRADE_MANAGER_INSTANCE.get_student_count());
    $display();
    
    // Test 8: Try to remove non-existing student
    $display("Test 8: Trying to remove non-existing student");
    GRADE_MANAGER_INSTANCE.remove_student("Jane Doe");
    $display();
    
    // Test 9: Final display of all grades
    $display("Test 9: Final state of student database");
    GRADE_MANAGER_INSTANCE.display_all_grades();
    
    $display("=== Test Complete ===");
    #1;
  end

endmodule