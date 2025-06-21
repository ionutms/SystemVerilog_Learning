// parameter_override_testbench.sv
module parameter_override_testbench;

  // Instance 1: Use default parameters
  parameter_override default_params();

  // Instance 2: Override WIDTH parameter only
  parameter_override #(.WIDTH(16)) width_override();

  // Instance 3: Override both parameters
  parameter_override #(.WIDTH(32), .DEPTH(16)) both_override();

  // Instance 4: Override parameters in different order
  parameter_override #(.DEPTH(64), .WIDTH(8)) reordered_override();

  initial begin
    // Dump waves
    $dumpfile("parameter_override_testbench.vcd");
    $dumpvars(0, parameter_override_testbench);
    
    $display("=== Parameter Override Example ===");
    $display();
    
    #1; // Let all instances initialize
    
    $display("All instances created with different parameter values!");
    $display();
    
    #10;
    $finish;
  end

endmodule