// color_lookup_dictionary.sv
module color_lookup_dictionary ();
  // RGB color code type definition (24-bit hex value)
  typedef logic [23:0] rgb_color_t;
  
  // Associative array: color name string -> RGB hex value
  rgb_color_t color_dictionary[string];
  
  initial begin
    // Populate the color dictionary with common colors
    color_dictionary["red"]     = 24'hFF0000;  // Red
    color_dictionary["green"]   = 24'h00FF00;  // Green  
    color_dictionary["blue"]    = 24'h0000FF;  // Blue
    color_dictionary["white"]   = 24'hFFFFFF;  // White
    color_dictionary["black"]   = 24'h000000;  // Black
    color_dictionary["yellow"]  = 24'hFFFF00;  // Yellow
    color_dictionary["cyan"]    = 24'h00FFFF;  // Cyan
    color_dictionary["magenta"] = 24'hFF00FF;  // Magenta
    color_dictionary["orange"]  = 24'hFFA500;  // Orange
    color_dictionary["purple"]  = 24'h800080;  // Purple
    
    $display();
    $display("Color Dictionary Initialized!");
    $display("Dictionary contains %0d colors", color_dictionary.size());
  end
  
  // Function to lookup color by name
  function rgb_color_t lookup_color_by_name(string color_name);
    if (|color_dictionary.exists(color_name)) begin
      return color_dictionary[color_name];
    end else begin
      $display("Warning: Color '%s' not found in dictionary!", color_name);
      return 24'h000000; // Return black as default
    end
  endfunction
  
  // Function to display all colors in dictionary
  function void display_all_colors();
    string color_name;
    rgb_color_t rgb_value;
    
    $display();
    $display("=== Color Dictionary Contents ===");
    if (|color_dictionary.first(color_name)) begin
      do begin
        rgb_value = color_dictionary[color_name];
        $display("%-8s -> #%06X", color_name, rgb_value);
      end while (|color_dictionary.next(color_name));
    end
    $display("=================================");
  endfunction

endmodule