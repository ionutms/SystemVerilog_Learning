// student_record_system.sv
package student_pkg;

  class Student;
    // Student record data members
    string student_name;
    int    student_id;
    int    student_age;
    real   student_gpa;
    string student_major;
    
    // Default constructor
    function new(string name = "Unknown", 
                 int id = 0, 
                 int age = 18, 
                 real gpa = 0.0, 
                 string major = "Undeclared");
      this.student_name  = name;
      this.student_id    = id;
      this.student_age   = age;
      this.student_gpa   = gpa;
      this.student_major = major;
      $display("[INFO] Created student: %s (ID: %0d)", name, id);
    endfunction
    
    // Copy constructor - creates identical student record
    function Student copy();
      Student copied_student;
      copied_student = new(this.student_name, 
                          this.student_id, 
                          this.student_age, 
                          this.student_gpa, 
                          this.student_major);
      $display("[COPY] Copied student record for: %s", this.student_name);
      return copied_student;
    endfunction
    
    // Deep copy with modified ID for duplicate records
    function Student copy_with_new_id(int new_id);
      Student copied_student;
      copied_student = new(this.student_name, 
                          new_id, 
                          this.student_age, 
                          this.student_gpa, 
                          this.student_major);
      $display("[COPY] Created duplicate record with new ID: %0d", new_id);
      return copied_student;
    endfunction
    
    // Display student information
    function void display_info();
      $display("=====================================");
      $display("Student Name:  %s", student_name);
      $display("Student ID:    %0d", student_id);
      $display("Student Age:   %0d", student_age);
      $display("Student GPA:   %.2f", student_gpa);
      $display("Student Major: %s", student_major);
      $display("=====================================");
    endfunction
    
    // Update GPA
    function void update_gpa(real new_gpa);
      student_gpa = new_gpa;
      $display("[UPDATE] Updated GPA for %s to %.2f", 
               student_name, new_gpa);
    endfunction
    
    // Check if two students are identical
    function bit is_identical(Student other);
      return (this.student_name == other.student_name &&
              this.student_id == other.student_id &&
              this.student_age == other.student_age &&
              this.student_gpa == other.student_gpa &&
              this.student_major == other.student_major);
    endfunction
    
  endclass

endpackage

module student_record_module;
  import student_pkg::*;
  
  initial $display("Student Record System Design Module Loaded");
  
endmodule