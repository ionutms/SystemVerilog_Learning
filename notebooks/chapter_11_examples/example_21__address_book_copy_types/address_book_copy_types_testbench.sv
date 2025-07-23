// address_book_copy_types_testbench.sv
module address_book_copy_types_testbench;
  import address_book_pkg::*;
  
  Person original_person;
  Person shallow_copy_person;
  Person deep_copy_person;

  initial begin
    // Dump waves for verilator
    $dumpfile("address_book_copy_types_testbench.vcd");
    $dumpvars(0, address_book_copy_types_testbench);
    
    $display("=== Address Book Copy Types Demo ===");
    $display();
    
    // Create original person with address
    original_person = new("Alice Smith", 25);
    original_person.home_address.street = "123 Main St";
    original_person.home_address.city = "Springfield"; 
    original_person.home_address.zip_code = 12345;
    
    $display("1. Original Person:");
    original_person.display("   ");
    $display();
    
    // Create shallow copy
    shallow_copy_person = original_person.shallow_copy();
    shallow_copy_person.name = "Alice Jones";  // Change name
    shallow_copy_person.age = 26;              // Change age
    
    // Create deep copy  
    deep_copy_person = original_person.deep_copy();
    deep_copy_person.name = "Alice Brown";     // Change name
    deep_copy_person.age = 27;                 // Change age
    
    $display("2. After creating copies (no address changes yet):");
    $display("   Original:");
    original_person.display("     ");
    $display("   Shallow Copy:");
    shallow_copy_person.display("     ");
    $display("   Deep Copy:");
    deep_copy_person.display("     ");
    $display();
    
    // Now modify the address in shallow copy
    $display("3. Modifying address via shallow copy...");
    shallow_copy_person.home_address.street = "456 Oak Ave";
    shallow_copy_person.home_address.city = "Riverside";
    shallow_copy_person.home_address.zip_code = 67890;
    
    $display("   After shallow copy address change:");
    $display("   Original (AFFECTED by shallow copy!):");
    original_person.display("     ");
    $display("   Shallow Copy:");
    shallow_copy_person.display("     ");
    $display("   Deep Copy (UNAFFECTED):");
    deep_copy_person.display("     ");
    $display();
    
    // Modify address in deep copy
    $display("4. Modifying address via deep copy...");
    deep_copy_person.home_address.street = "789 Pine Rd";
    deep_copy_person.home_address.city = "Hilltown";
    deep_copy_person.home_address.zip_code = 54321;
    
    $display("   After deep copy address change:");
    $display("   Original (UNAFFECTED by deep copy):");
    original_person.display("     ");
    $display("   Shallow Copy (UNAFFECTED by deep copy):");
    shallow_copy_person.display("     ");
    $display("   Deep Copy:");
    deep_copy_person.display("     ");
    $display();
    
    $display("=== Summary ===");
    $display("Shallow Copy: Shares address object - changes affect original");
    $display("Deep Copy:    Creates new address object - independent changes");
    
    #1;  // Wait for verilator
    $finish;
  end

endmodule