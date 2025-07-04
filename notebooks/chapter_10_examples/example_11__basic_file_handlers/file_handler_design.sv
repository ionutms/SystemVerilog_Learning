// file_handler_design.sv

module file_handler_design();
  
  // File processing tasks for different file types
  task process_text_file(string filename);
    $display("Processing text file: %s", filename);
    $display("  - Counting words and lines");
    $display("  - Checking spelling");
    $display("  - Text file processing complete");
  endtask
  
  task process_image_file(string filename);
    $display("Processing image file: %s", filename);
    $display("  - Resizing image");
    $display("  - Applying filters");
    $display("  - Image file processing complete");
  endtask
  
  task process_video_file(string filename);
    $display("Processing video file: %s", filename);
    $display("  - Transcoding video");
    $display("  - Extracting thumbnails");
    $display("  - Video file processing complete");
  endtask
  
  // File handler function that routes to appropriate processor
  function void process_file(string filename, string file_type);
    case (file_type)
      "text": process_text_file(filename);
      "image": process_image_file(filename);
      "video": process_video_file(filename);
      default: $display("Unknown file type: %s", file_type);
    endcase
  endfunction
  
  initial begin
    $display();
    $display("=== File Handler Design Demo ===");
    
    $display("\nProcessing different file types:");
    $display("--------------------------------");
    
    // Process different file types
    process_file("document.txt", "text");
    $display();
    
    process_file("photo.jpg", "image");
    $display();
    
    process_file("movie.mp4", "video");
    $display();
    
    $display("All files processed successfully!");
    $display();
  end

endmodule