// student_grade_system_testbench.sv
module student_grade_testbench;
  
  // Import both packages
  import student_pkg::*;
  import graduate_student_pkg::*;
  
  // Test variables
  Student regular_student;
  GraduateStudent grad_student;
  
  initial begin
    // Dump waves
    $dumpfile("student_grade_testbench.vcd");
    $dumpvars(0, student_grade_testbench);
    
    $display("=== Student Grade System Test ===");
    $display();
    
    // Test 1: Create regular student
    $display("Test 1: Creating regular student");
    regular_student = new("Alice Johnson", 20, 85.5);
    regular_student.display_info();
    $display();
    
    // Test 2: Create graduate student using super.new()
    $display("Test 2: Creating graduate student");
    grad_student = new("Bob Smith", 24, 82.0, 5.0, 90.0);
    grad_student.display_info();
    $display();
    
    // Test 3: Compare grade calculations
    $display("Test 3: Grade comparison");
    $display("Regular student '%s' final grade: %.2f", 
             regular_student.get_name(), 
             regular_student.calculate_final_grade());
    $display("Graduate student '%s' final grade: %.2f", 
             grad_student.get_name(), 
             grad_student.calculate_final_grade());
    $display();
    
    // Test 4: Polymorphism test
    $display("Test 4: Polymorphism test");
    begin
      Student student_ref;
      
      // Point to regular student
      student_ref = regular_student;
      $display("Via Student reference (regular):");
      student_ref.display_info();
      $display();
      
      // Point to graduate student
      student_ref = grad_student;
      $display("Via Student reference (graduate):");
      student_ref.display_info();
      $display();
    end
    
    // Test 5: Edge case - high grades
    $display("Test 5: High grade capping test");
    begin
      GraduateStudent high_achiever;
      high_achiever = new("Charlie Brown", 26, 95.0, 8.0, 95.0);
      high_achiever.display_info();
      $display();
    end
    
    $display("=== All tests completed ===");
    $finish;
  end
  
endmodule