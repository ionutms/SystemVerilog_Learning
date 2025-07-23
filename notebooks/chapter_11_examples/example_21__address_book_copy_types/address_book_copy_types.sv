// address_book_copy_types.sv
package address_book_pkg;

  // Address class - holds address information
  class Address;
    string street;
    string city;
    int zip_code;
    
    function new(string street = "", string city = "", int zip_code = 0);
      this.street = street;
      this.city = city;
      this.zip_code = zip_code;
    endfunction
    
    function void display(string prefix = "");
      $display("%sAddress: %s, %s %0d", prefix, street, city, zip_code);
    endfunction
    
    // Deep copy method
    function Address copy();
      Address new_addr = new();
      new_addr.street = this.street;
      new_addr.city = this.city;
      new_addr.zip_code = this.zip_code;
      return new_addr;
    endfunction
    
  endclass

  // Person class - contains an Address object
  class Person;
    string name;
    int age;
    Address home_address;
    
    function new(string name = "", int age = 0);
      this.name = name;
      this.age = age;
      this.home_address = new();
    endfunction
    
    function void display(string prefix = "");
      $display("%sPerson: %s (age %0d)", prefix, name, age);
      home_address.display({prefix, "  "});
    endfunction
    
    // Shallow copy - shares the same Address object
    function Person shallow_copy();
      Person new_person = new();
      new_person.name = this.name;
      new_person.age = this.age;
      new_person.home_address = this.home_address; // Same reference!
      return new_person;
    endfunction
    
    // Deep copy - creates new Address object
    function Person deep_copy();
      Person new_person = new();
      new_person.name = this.name;
      new_person.age = this.age;
      new_person.home_address = this.home_address.copy(); // New object!
      return new_person;
    endfunction
    
  endclass

endpackage