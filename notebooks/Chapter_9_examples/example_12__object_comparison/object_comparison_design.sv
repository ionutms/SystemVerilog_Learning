// object_comparison_design.sv
class student_record;
  string name;
  int age;
  int grade;
  
  function new(string n = "Unknown", int a = 0, int g = 0);
    this.name = n;
    this.age = a;
    this.grade = g;
  endfunction
  
  // Method to compare current object with another using 'this'
  function bit is_equal(student_record other);
    if (other == null) return 0;
    
    return (this.name == other.name && 
            this.age == other.age && 
            this.grade == other.grade);
  endfunction
  
  // Method to check if current student is older than another
  function bit is_older_than(student_record other);
    if (other == null) return 0;
    
    return (this.age > other.age);
  endfunction
  
  // Method to display student info
  function void display();
    $display("Student: %s, Age: %0d, Grade: %0d", 
             this.name, this.age, this.grade);
  endfunction
  
endclass

module object_comparison_module();
  student_record student1, student2, student3;
  
  initial begin
    $display("=== Object Comparison Example ===");
    $display();
    
    // Create student objects
    student1 = new("Alice", 20, 85);
    student2 = new("Bob", 22, 90);
    student3 = new("Alice", 20, 85);  // Same as student1
    
    // Display students
    $display("Created students:");
    student1.display();
    student2.display();
    student3.display();
    $display();
    
    // Compare students using 'this'
    $display("Comparison results:");
    $display("Student1 == Student2: %s", 
             student1.is_equal(student2) ? "TRUE" : "FALSE");
    $display("Student1 == Student3: %s", 
             student1.is_equal(student3) ? "TRUE" : "FALSE");
    $display();
    
    // Age comparison using 'this'
    $display("Age comparison results:");
    $display("Student1 older than Student2: %s", 
             student1.is_older_than(student2) ? "TRUE" : "FALSE");
    $display("Student2 older than Student1: %s", 
             student2.is_older_than(student1) ? "TRUE" : "FALSE");
    $display();
  end
  
endmodule