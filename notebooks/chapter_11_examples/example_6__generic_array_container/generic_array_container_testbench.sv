// generic_array_container_testbench.sv
module generic_array_container_testbench;
  
  import generic_container_pkg::*;
  
  // Test containers for different data types
  generic_array_container #(int) int_container;
  generic_array_container #(string) string_container;
  generic_array_container #(person_t) person_container;
  
  // Variables for testing
  person_t alice, bob, charlie, retrieved_person;
  int dummy;
  
  initial begin
    // Dump waves
    $dumpfile("generic_array_container_testbench.vcd");
    $dumpvars(0, generic_array_container_testbench);
    
    $display("=== Generic Array Container Test ===");
    $display();
    
    // Test 1: Integer container
    $display("--- Test 1: Integer Container ---");
    int_container = new(3); // Small initial capacity for testing resize
    
    // Add integers
    for (int i = 1; i <= 5; i++) begin
      int_container.add(i * 10);
      $display("Added: %0d", i * 10);
    end
    
    int_container.display();
    
    // Test get method
    $display("Getting element at index 2: %0d", int_container.get(2));
    $display("Container size: %0d", int_container.get_size());
    $display();
    
    // Test 2: String container
    $display("--- Test 2: String Container ---");
    string_container = new(2);
    
    string_container.add("Hello");
    string_container.add("World");
    string_container.add("SystemVerilog");
    string_container.add("Generic");
    string_container.add("Container");
    
    string_container.display();
    $display("First string: %s", string_container.get(0));
    $display("Last string: %s", 
             string_container.get(string_container.get_size()-1));
    $display();
    
    // Test 3: Custom struct container
    $display("--- Test 3: Person Struct Container ---");
    person_container = new(2);
    
    alice = '{"Alice", 25};
    bob = '{"Bob", 30};
    charlie = '{"Charlie", 35};
    
    person_container.add(alice);
    person_container.add(bob);
    person_container.add(charlie);
    
    person_container.display();
    
    retrieved_person = person_container.get(1);
    $display("Retrieved person: name=%s, age=%0d", 
             retrieved_person.name, retrieved_person.age);
    $display();
    
    // Test 4: Error handling
    $display("--- Test 4: Error Handling ---");
    $display("Attempting to access invalid index...");
    dummy = int_container.get(100); // Should generate error
    $display();
    
    // Test 5: Container operations
    $display("--- Test 5: Container Operations ---");
    $display("String container empty? %s", 
             string_container.is_empty() ? "Yes" : "No");
    
    string_container.clear();
    $display("After clear, string container empty? %s", 
             string_container.is_empty() ? "Yes" : "No");
    $display("String container size: %0d", string_container.get_size());
    
    $display();
    $display("=== Test Complete ===");
    
    #1;
    $finish;
  end
  
endmodule