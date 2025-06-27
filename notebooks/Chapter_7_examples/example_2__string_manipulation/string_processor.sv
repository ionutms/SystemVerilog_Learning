// string_processor.sv
module string_processor ();
  
  // String manipulation functions demonstration
  function automatic string format_name(string first_name, string last_name);
    return $sformatf("%s %s", first_name, last_name);
  endfunction
  
  function automatic string extract_extension(string filename);
    int dot_position;
    dot_position = filename.len() - 1;
    
    // Find the last dot in filename
    while (dot_position >= 0 && filename[dot_position] != ".") begin
      dot_position--;
    end
    
    if (dot_position >= 0)
      return filename.substr(dot_position + 1, filename.len() - 1);
    else
      return "no_extension";
  endfunction
  
  function automatic string reverse_string(string input_text);
    string reversed_text = "";
    for (int i = input_text.len() - 1; i >= 0; i--) begin
      reversed_text = {reversed_text, input_text[i]};
    end
    return reversed_text;
  endfunction
  
  function automatic int count_vowels(string text);
    int vowel_count = 0;
    string lowercase_text;
    
    lowercase_text = text.tolower();
    
    for (int i = 0; i < lowercase_text.len(); i++) begin
      case (lowercase_text[i])
        "a", "e", "i", "o", "u": vowel_count++;
        default: ; // Non-vowel characters, do nothing
      endcase
    end
    return vowel_count;
  endfunction
  
  initial begin
    string first_name = "Alice";
    string last_name = "Johnson";
    string full_name;
    string filename = "report.txt";
    string file_extension;
    string sample_text = "SystemVerilog";
    string reversed_text;
    int vowel_count;
    
    $display("=== String Manipulation Functions Demo ===");
    $display();
    
    // Format name demonstration
    full_name = format_name(first_name, last_name);
    $display("Name formatting:");
    $display("  First: %s, Last: %s", first_name, last_name);
    $display("  Full name: %s", full_name);
    $display();
    
    // File extension extraction
    file_extension = extract_extension(filename);
    $display("File extension extraction:");
    $display("  Filename: %s", filename);
    $display("  Extension: %s", file_extension);
    $display();
    
    // String reversal
    reversed_text = reverse_string(sample_text);
    $display("String reversal:");
    $display("  Original: %s", sample_text);
    $display("  Reversed: %s", reversed_text);
    $display();
    
    // Vowel counting
    vowel_count = count_vowels(sample_text);
    $display("Vowel counting:");
    $display("  Text: %s", sample_text);
    $display("  Vowel count: %0d", vowel_count);
    $display();
  end

endmodule