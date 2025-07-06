// generic_counter.sv
`ifndef COUNTER_PKG_SV
`define COUNTER_PKG_SV

// Package containing the generic counter class
package counter_pkg;

  // Generic counter class with parameterized width and increment
  class generic_counter #(parameter int WIDTH = 8, parameter int INCREMENT = 1);
    
    // Internal counter value
    logic [WIDTH-1:0] count_value;
    logic [WIDTH-1:0] max_value;
    bit overflow_flag;
    
    // Constructor
    function new();
      count_value = 0;
      max_value = {WIDTH{1'b1}};  // All ones for maximum value
      overflow_flag = 0;
      $display("Counter created: WIDTH=%0d, INCREMENT=%0d, MAX=%0d", 
               WIDTH, INCREMENT, max_value);
    endfunction
    
    // Increment the counter
    function void increment();
      logic [WIDTH:0] temp_sum;  // Extra bit for overflow detection
      logic [WIDTH:0] extended_count;
      logic [WIDTH:0] extended_increment;
      
      /* verilator lint_off WIDTHTRUNC */
      /* verilator lint_off WIDTHEXPAND */
      extended_count = {1'b0, count_value};
      extended_increment = INCREMENT;
      temp_sum = extended_count + extended_increment;
      /* verilator lint_on WIDTHEXPAND */
      /* verilator lint_on WIDTHTRUNC */
      
      // Check for overflow
      if (temp_sum > {1'b0, max_value}) begin
        overflow_flag = 1;
        count_value = temp_sum[WIDTH-1:0];  // Wrap around
        $display("Counter overflow detected! Value wrapped to %0d", 
                 count_value);
      end else begin
        overflow_flag = 0;
        count_value = temp_sum[WIDTH-1:0];
      end
    endfunction
    
    // Reset the counter
    function void reset();
      count_value = 0;
      overflow_flag = 0;
      $display("Counter reset to 0");
    endfunction
    
    // Get current count value
    function logic [WIDTH-1:0] get_count();
      return count_value;
    endfunction
    
    // Get overflow status
    function bit get_overflow_flag();
      return overflow_flag;
    endfunction
    
    // Get maximum possible value
    function logic [WIDTH-1:0] get_max_value();
      return max_value;
    endfunction
    
    // Display current status
    function void display_status();
      $display("Counter Status - Value: %0d, Overflow: %0b, Max: %0d", 
               count_value, overflow_flag, max_value);
    endfunction
    
  endclass

endpackage

`endif // COUNTER_PKG_SV