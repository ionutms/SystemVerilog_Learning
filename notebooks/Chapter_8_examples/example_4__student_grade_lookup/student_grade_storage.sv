// student_grade_storage.sv
module student_grade_manager ();
  // String-indexed associative array for student grades
  int student_grades[string];
  
  // Task to add or update student grade
  task add_student_grade(input string student_name, input int grade);
    student_grades[student_name] = grade;
    $display("Added/Updated: %s = %0d", student_name, grade);
  endtask
  
  // Function to lookup student grade
  function int lookup_student_grade(input string student_name);
    if (student_grades.exists(student_name) == 1) begin
      return student_grades[student_name];
    end else begin
      $display("Student '%s' not found in database", student_name);
      return -1;  // Return -1 for not found
    end
  endfunction
  
  // Task to display all students and grades
  task display_all_grades();
    string student_name;
    $display("\n=== All Student Grades ===");
    if (student_grades.first(student_name) == 1) begin
      do begin
        $display("%-15s: %0d", student_name, student_grades[student_name]);
      end while (student_grades.next(student_name) == 1);
    end else begin
      $display("No students in database");
    end
    $display("========================\n");
  endtask
  
  // Task to remove student from database
  task remove_student(input string student_name);
    if (student_grades.exists(student_name) == 1) begin
      student_grades.delete(student_name);
      $display("Removed student: %s", student_name);
    end else begin
      $display("Cannot remove - Student '%s' not found", student_name);
    end
  endtask
  
  // Function to get total number of students
  function int get_student_count();
    return student_grades.size();
  endfunction

endmodule