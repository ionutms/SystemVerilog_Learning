// math_utilities.sv
// Demonstrates static utility methods that can be called without instances

class MathUtilities;
  
  // Static method to find maximum of two numbers
  static function int max(int a, int b);
    return (a > b) ? a : b;
  endfunction
  
  // Static method to find minimum of two numbers
  static function int min(int a, int b);
    return (a < b) ? a : b;
  endfunction
  
  // Static method to calculate absolute value
  static function int abs(int value);
    return (value < 0) ? -value : value;
  endfunction
  
  // Static method to check if number is even
  static function bit is_even(int number);
    return (number % 2 == 0);
  endfunction
  
  // Static method to calculate power of 2
  static function int power_of_two(int exponent);
    return (1 << exponent);
  endfunction
  
  // Static method to clamp value between min and max
  static function int clamp(int value, int min_val, int max_val);
    if (value < min_val) return min_val;
    if (value > max_val) return max_val;
    return value;
  endfunction
  
endclass

// String utilities class
class StringUtilities;
  
  // Static method to get string length (simplified)
  static function int str_length(string str);
    return str.len();
  endfunction
  
  // Static method to check if string is empty
  static function bit is_empty(string str);
    return (str.len() == 0);
  endfunction
  
  // Static method to convert to uppercase (first character only)
  static function string to_upper_first(string str);
    byte ascii_val;
    string result;
    
    if (str.len() == 0) return "";
    
    ascii_val = str.getc(0);
    if (ascii_val >= 97 && ascii_val <= 122) begin  // lowercase a-z
      ascii_val = ascii_val - 32;  // Convert to uppercase
      result = {string'(ascii_val), str.substr(1, str.len()-1)};
    end else begin
      result = str;
    end
    
    return result;
  endfunction
  
endclass