// book_with_chapter.sv
package book_package;

  // Chapter class - represents a single chapter in a book
  class Chapter;
    string chapter_title;
    int chapter_number;
    int page_count;
    
    // Constructor
    function new(string title = "Untitled", int number = 1, 
                 int pages = 10);
      this.chapter_title = title;
      this.chapter_number = number;
      this.page_count = pages;
    endfunction
    
    // Display chapter information
    function void display_chapter();
      $display("    Chapter %0d: %s (%0d pages)", 
               chapter_number, chapter_title, page_count);
    endfunction
    
    // Get chapter summary
    function string get_summary();
      return $sformatf("Ch%0d: %s", chapter_number, chapter_title);
    endfunction
    
  endclass

  // Book class - contains multiple chapters
  class Book;
    string book_title;
    string author_name;
    Chapter chapters[];
    int total_chapters;
    
    // Constructor
    function new(string title = "Unknown Book", string author = "Unknown");
      this.book_title = title;
      this.author_name = author;
      this.total_chapters = 0;
      this.chapters = new[0];
    endfunction
    
    // Add a chapter to the book
    function void add_chapter(string title, int pages = 15);
      Chapter new_chapter;
      Chapter temp_chapters[];
      
      // Create new chapter
      new_chapter = new(title, total_chapters + 1, pages);
      
      // Resize array and add chapter
      temp_chapters = new[total_chapters + 1];
      for (int i = 0; i < total_chapters; i++) begin
        temp_chapters[i] = chapters[i];
      end
      temp_chapters[total_chapters] = new_chapter;
      
      chapters = temp_chapters;
      total_chapters++;
    endfunction
    
    // Display complete book information
    function void display_book();
      int total_pages = 0;
      
      $display("=== BOOK INFORMATION ===");
      $display("Title: %s", book_title);
      $display("Author: %s", author_name);
      $display("Chapters (%0d total):", total_chapters);
      
      for (int i = 0; i < total_chapters; i++) begin
        chapters[i].display_chapter();
        total_pages += chapters[i].page_count;
      end
      
      $display("Total Pages: %0d", total_pages);
      $display("========================");
    endfunction
    
    // Get book summary
    function string get_book_summary();
      return $sformatf("'%s' by %s (%0d chapters)", 
                      book_title, author_name, total_chapters);
    endfunction
    
    // Find chapter by number
    function Chapter find_chapter(int number);
      if (number >= 1 && number <= total_chapters) begin
        return chapters[number - 1];
      end else begin
        return null;
      end
    endfunction
    
  endclass

endpackage

// Design module demonstrating Book with Chapter classes
module book_design_module();
  import book_package::*;
  
  Book programming_book;
  Book novel_book;
  Chapter found_chapter;
  
  initial begin
    $display("=== Book with Chapter Class Example ===");
    $display();
    
    // Create first book about programming
    programming_book = new("SystemVerilog Fundamentals", "John Doe");
    
    // Add chapters to programming book
    programming_book.add_chapter("Introduction to SystemVerilog", 25);
    programming_book.add_chapter("Data Types and Variables", 30);
    programming_book.add_chapter("Control Structures", 22);
    programming_book.add_chapter("Classes and Objects", 35);
    
    // Display programming book
    programming_book.display_book();
    $display();
    
    // Create second book (novel)
    novel_book = new("The Digital Adventure", "Jane Smith");
    
    // Add chapters to novel
    novel_book.add_chapter("The Beginning", 12);
    novel_book.add_chapter("The Journey", 18);
    novel_book.add_chapter("The Challenge", 20);
    novel_book.add_chapter("The Resolution", 15);
    
    // Display novel book
    novel_book.display_book();
    $display();
    
    // Demonstrate chapter search
    $display("=== Chapter Search Demo ===");
    found_chapter = programming_book.find_chapter(2);
    if (found_chapter != null) begin
      $display("Found chapter: %s", found_chapter.get_summary());
    end
    
    found_chapter = novel_book.find_chapter(3);
    if (found_chapter != null) begin
      $display("Found chapter: %s", found_chapter.get_summary());
    end
    
    $display();
    $display("Book summaries:");
    $display("- %s", programming_book.get_book_summary());
    $display("- %s", novel_book.get_book_summary());
    
  end
  
endmodule