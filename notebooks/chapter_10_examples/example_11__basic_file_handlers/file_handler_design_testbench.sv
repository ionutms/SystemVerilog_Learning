// file_handler_design_testbench.sv
module file_handler_testbench;
  
  // Instantiate design under test
  file_handler_design DESIGN_INSTANCE();
  
  // Test file processing tasks
  task test_file_processing();
    $display("=== Testbench Additional Tests ===");
    $display("\nTesting individual file handlers:");
    $display("---------------------------------");
    
    // Test text file processing
    $display("Testing text file handler:");
    DESIGN_INSTANCE.process_text_file("readme.txt");
    $display();
    
    // Test image file processing
    $display("Testing image file handler:");
    DESIGN_INSTANCE.process_image_file("screenshot.png");
    $display();
    
    // Test video file processing
    $display("Testing video file handler:");
    DESIGN_INSTANCE.process_video_file("tutorial.avi");
    $display();
    
    // Test file handler function with different types
    $display("Testing file handler function:");
    DESIGN_INSTANCE.process_file("config.txt", "text");
    $display();
    DESIGN_INSTANCE.process_file("banner.gif", "image");
    $display();
    DESIGN_INSTANCE.process_file("demo.mov", "video");
    $display();
    
    // Test unknown file type
    $display("Testing unknown file type:");
    DESIGN_INSTANCE.process_file("data.bin", "binary");
    $display();
  endtask
  
  initial begin
    // Setup waveform dumping
    $dumpfile("file_handler_testbench.vcd");
    $dumpvars(0, file_handler_testbench);
    
    #1; // Wait for design to initialize
    
    // Run additional tests
    test_file_processing();
    
    $display("Testbench completed successfully!");
    $display();
    
    #10; // Final delay
    $finish;
  end

endmodule