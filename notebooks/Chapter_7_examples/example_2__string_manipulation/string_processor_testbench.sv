// string_processor_testbench.sv
module string_processor_testbench;
  
  // Instantiate the string processor design
  string_processor STRING_PROCESSOR_INSTANCE();
  
  // Additional testbench verification
  task automatic verify_string_functions();
    string test_first = "Bob";
    string test_last = "Smith";
    string expected_full = "Bob Smith";
    string actual_full;
    
    string test_filename = "data.csv";
    string expected_ext = "csv";
    string actual_ext;
    
    string test_word = "hello";
    string expected_reverse = "olleh";
    string actual_reverse;
    
    int expected_vowels = 2; // "e" and "o" in "hello"
    int actual_vowels;
    
    $display("=== Testbench Verification ===");
    $display();
    
    // Test name formatting
    actual_full = STRING_PROCESSOR_INSTANCE.format_name(test_first, test_last);
    $display("Name Format Test:");
    $display("  Expected: %s", expected_full);
    $display("  Actual:   %s", actual_full);
    $display("  Result:   %s", (actual_full == expected_full) ? "PASS" : "FAIL");
    $display();
    
    // Test file extension extraction
    actual_ext = STRING_PROCESSOR_INSTANCE.extract_extension(test_filename);
    $display("Extension Test:");
    $display("  Expected: %s", expected_ext);
    $display("  Actual:   %s", actual_ext);
    $display("  Result:   %s", (actual_ext == expected_ext) ? "PASS" : "FAIL");
    $display();
    
    // Test string reversal
    actual_reverse = STRING_PROCESSOR_INSTANCE.reverse_string(test_word);
    $display("Reverse Test:");
    $display("  Expected: %s", expected_reverse);
    $display("  Actual:   %s", actual_reverse);
    $display("  Result:   %s", (actual_reverse == expected_reverse) ? "PASS" : "FAIL");
    $display();
    
    // Test vowel counting
    actual_vowels = STRING_PROCESSOR_INSTANCE.count_vowels(test_word);
    $display("Vowel Count Test:");
    $display("  Expected: %0d", expected_vowels);
    $display("  Actual:   %0d", actual_vowels);
    $display("  Result:   %s", (actual_vowels == expected_vowels) ? "PASS" : "FAIL");
    $display();
    
  endtask
  
  initial begin
    // Dump waves for analysis
    $dumpfile("string_processor_testbench.vcd");
    $dumpvars(0, string_processor_testbench);
    
    #1; // Wait for design to initialize
    
    $display("Hello from string processor testbench!");
    $display();
    
    // Run verification tests
    verify_string_functions();
    
    $display("=== Test Summary ===");
    $display("String manipulation functions tested successfully!");
    $display();
    
    #5; // Additional time before finish
    $finish;
  end

endmodule