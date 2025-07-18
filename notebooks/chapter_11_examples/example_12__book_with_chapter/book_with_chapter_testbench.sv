// book_with_chapter_testbench.sv
module book_testbench_module;
  import book_package::*;
  
  // Instantiate design under test
  book_design_module BOOK_DESIGN_INSTANCE();
  
  // Testbench variables
  Book test_book;
  Chapter test_chapter;
  Book book_a, book_b;
  
  initial begin
    // Dump waves for Verilator
    $dumpfile("book_testbench_module.vcd");
    $dumpvars(0, book_testbench_module);
    
    #1; // Wait for design to initialize
    
    $display("=== TESTBENCH: Book Class Functionality Tests ===");
    $display();
    
    // Test 1: Create empty book
    $display("TEST 1: Creating empty book");
    test_book = new();
    $display("Empty book created: %s", test_book.get_book_summary());
    $display();
    
    // Test 2: Add chapters and verify
    $display("TEST 2: Adding chapters");
    test_book.book_title = "Test Book";
    test_book.author_name = "Test Author";
    
    test_book.add_chapter("First Chapter", 20);
    test_book.add_chapter("Second Chapter", 25);
    test_book.add_chapter("Third Chapter", 18);
    
    $display("After adding chapters:");
    test_book.display_book();
    $display();
    
    // Test 3: Chapter search functionality
    $display("TEST 3: Chapter search");
    test_chapter = test_book.find_chapter(2);
    if (test_chapter != null) begin
      $display("Found chapter 2: %s", test_chapter.get_summary());
    end else begin
      $display("Chapter 2 not found");
    end
    
    test_chapter = test_book.find_chapter(5);
    if (test_chapter == null) begin
      $display("Chapter 5 correctly not found (out of range)");
    end else begin
      $display("Chapter 5 should not exist");
    end
    $display();
    
    // Test 4: Individual chapter functionality
    $display("TEST 4: Individual chapter tests");
    test_chapter = new("Standalone Chapter", 99, 42);
    $display("Standalone chapter created:");
    test_chapter.display_chapter();
    $display("Summary: %s", test_chapter.get_summary());
    $display();
    
    // Test 5: Multiple books comparison
    $display("TEST 5: Multiple books");
    
    book_a = new("Book A", "Author A");
    book_b = new("Book B", "Author B");
    
    book_a.add_chapter("A1", 10);
    book_a.add_chapter("A2", 15);
    
    book_b.add_chapter("B1", 12);
    book_b.add_chapter("B2", 18);
    book_b.add_chapter("B3", 20);
    
    $display("Comparison:");
    $display("Book A: %s", book_a.get_book_summary());
    $display("Book B: %s", book_b.get_book_summary());
    $display();
    
    $display("=== TESTBENCH COMPLETED ===");
    $display();
    
  end
  
endmodule