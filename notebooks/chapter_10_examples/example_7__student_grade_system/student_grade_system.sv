// student_grade_system.sv

// Base Student class package
package student_pkg;

class Student;
  protected string name;
  protected int age;
  protected real base_grade;
  
  // Constructor
  function new(string student_name, int student_age, real grade);
    this.name = student_name;
    this.age = student_age;
    this.base_grade = grade;
    $display("Student created: %s, Age: %0d", name, age);
  endfunction
  
  // Virtual method for grade calculation
  virtual function real calculate_final_grade();
    return base_grade;
  endfunction
  
  // Method to display student info
  virtual function void display_info();
    $display("Student: %s, Age: %0d, Final Grade: %.2f", 
             name, age, calculate_final_grade());
  endfunction
  
  // Getter methods
  function string get_name();
    return name;
  endfunction
  
  function int get_age();
    return age;
  endfunction
  
endclass

endpackage : student_pkg

// Graduate Student class package
package graduate_student_pkg;

// Import the base student package
import student_pkg::*;

class GraduateStudent extends Student;
  protected real research_bonus;
  protected real thesis_score;
  
  // Constructor using super.new()
  function new(string student_name, int student_age, real grade, 
               real bonus, real thesis);
    super.new(student_name, student_age, grade);
    this.research_bonus = bonus;
    this.thesis_score = thesis;
    $display("Graduate Student specialized initialization complete");
  endfunction
  
  // Override grade calculation using super method
  virtual function real calculate_final_grade();
    real base_result;
    real final_result;
    
    // Call parent method using super
    base_result = super.calculate_final_grade();
    
    // Add graduate-specific calculations
    final_result = base_result + research_bonus + (thesis_score * 0.1);
    
    // Cap at 100
    if (final_result > 100.0) final_result = 100.0;
    
    return final_result;
  endfunction
  
  // Override display method using super
  virtual function void display_info();
    $display("=== Graduate Student Info ===");
    super.display_info();
    $display("Research Bonus: %.2f, Thesis Score: %.2f", 
             research_bonus, thesis_score);
  endfunction
  
endclass

endpackage : graduate_student_pkg