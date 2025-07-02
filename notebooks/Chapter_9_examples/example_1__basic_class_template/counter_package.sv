// counter_package.sv
package counter_pkg;                        // SystemVerilog package definition

  class simple_counter_class;               // Basic class definition
    int count_value;                        // Class property (data member)
    string counter_name;                    // Another class property
    
    // Constructor method - called when object is created
    function new(string name = "default_counter");
      counter_name = name;                  // Initialize counter name
      count_value = 0;                      // Initialize count to zero
      $display("Created counter: %s", counter_name);
    endfunction
    
    // Method to increment the counter
    function void increment();
      count_value++;                        // Increment the count
      $display("%s: count = %0d", counter_name, count_value);
    endfunction
    
    // Method to get current count value
    function int get_count();
      return count_value;                   // Return current count
    endfunction
    
    // Method to reset the counter
    function void reset();
      count_value = 0;                      // Reset count to zero
      $display("%s: reset to 0", counter_name);
    endfunction

  endclass

endpackage : counter_pkg                    // End package with explicit name