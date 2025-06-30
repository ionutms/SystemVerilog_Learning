// dynamic_array_processor.sv
module dynamic_array_processor;              // Design under test
  
  // Dynamic array declarations
  int dynamic_numbers[];                      // Integer dynamic array
  string dynamic_words[];                     // String dynamic array
  
  initial begin
    $display();                               // Display empty line
    $display("=== Dynamic Array Processor ===");
    
    // Allocate and initialize integer array
    dynamic_numbers = new[5];                 // Allocate 5 elements
    dynamic_numbers[0] = 10;
    dynamic_numbers[1] = 20;
    dynamic_numbers[2] = 30;
    dynamic_numbers[3] = 40;
    dynamic_numbers[4] = 50;
    
    $display("Integer array size: %0d", dynamic_numbers.size());
    $display("Integer array contents: %p", dynamic_numbers);
    
    // Allocate and initialize string array
    dynamic_words = new[3];                   // Allocate 3 elements
    dynamic_words[0] = "Hello";
    dynamic_words[1] = "Dynamic";
    dynamic_words[2] = "Arrays";
    
    $display("String array size: %0d", dynamic_words.size());
    $display("String array contents: %p", dynamic_words);
    
    // Resize operations
    dynamic_numbers = new[8](dynamic_numbers); // Resize to 8, keep data
    dynamic_numbers[5] = 60;
    dynamic_numbers[6] = 70;
    dynamic_numbers[7] = 80;
    
    $display("After resize - Integer array size: %0d", 
             dynamic_numbers.size());
    $display("After resize - Integer array: %p", dynamic_numbers);
    
    $display("=== Design Processing Complete ===");
  end
  
endmodule