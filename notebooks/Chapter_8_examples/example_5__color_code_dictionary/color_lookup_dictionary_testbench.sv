// color_lookup_dictionary_testbench.sv
module color_lookup_dictionary_testbench;
  // Instantiate the color dictionary design under test
  color_lookup_dictionary COLOR_DICT_INSTANCE();
  
  // Test variables
  logic [23:0] retrieved_color;
  string test_colors[] = {"red", "blue", "yellow", "pink", "green"};
  
  initial begin
    // Setup wave dump
    $dumpfile("color_lookup_dictionary_testbench.vcd");
    $dumpvars(0, color_lookup_dictionary_testbench);
    
    // Wait for dictionary initialization
    #2;
    
    $display();
    $display("Starting Color Dictionary Tests...");
    
    // Display all available colors
    COLOR_DICT_INSTANCE.display_all_colors();
    
    $display();
    $display("=== Color Lookup Tests ===");
    
    // Test color lookups
    foreach (test_colors[i]) begin
      retrieved_color = COLOR_DICT_INSTANCE.lookup_color_by_name(
                                                            test_colors[i]);
      if (|COLOR_DICT_INSTANCE.color_dictionary.exists(test_colors[i])) begin
        $display("Found '%s' -> #%06X", test_colors[i], retrieved_color);
      end else begin
        $display("'%s' not found, returned default: #%06X", 
                 test_colors[i], retrieved_color);
      end
      #1;
    end
    
    $display();
    $display("=== Adding New Colors ===");
    
    // Add new colors to dictionary during simulation
    COLOR_DICT_INSTANCE.color_dictionary["pink"] = 24'hFFC0CB;
    COLOR_DICT_INSTANCE.color_dictionary["lime"] = 24'h00FF00;
    
    $display("Added 'pink' and 'lime' to dictionary");
    $display("Dictionary now contains %0d colors", 
             COLOR_DICT_INSTANCE.color_dictionary.size());
    
    // Test newly added colors
    retrieved_color = COLOR_DICT_INSTANCE.lookup_color_by_name("pink");
    $display("Found 'pink' -> #%06X", retrieved_color);
    
    $display();
    $display("Hello from color dictionary testbench!");
    $display();
    
    #5;
    $finish;
  end

endmodule