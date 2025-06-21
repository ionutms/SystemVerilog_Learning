// parallel_adder_generator_testbench.sv
module parallel_adder_generator_testbench;

  // Test signals for 4-bit adder
  logic [3:0] a4, b4, sum4;
  logic cin4, cout4;
  
  // Test signals for 8-bit adder
  logic [7:0] a8, b8, sum8;
  logic cin8, cout8;
  
  // Test signals for 2-bit adder
  logic [1:0] a2, b2, sum2;
  logic cin2, cout2;

  // Instance 1: 4-bit adder (default)
  parallel_adder_generator #(.WIDTH(4)) adder_4bit (
    .a(a4), .b(b4), .cin(cin4),
    .sum(sum4), .cout(cout4)
  );

  // Instance 2: 8-bit adder
  parallel_adder_generator #(.WIDTH(8)) adder_8bit (
    .a(a8), .b(b8), .cin(cin8),
    .sum(sum8), .cout(cout8)
  );

  // Instance 3: 2-bit adder
  parallel_adder_generator #(.WIDTH(2)) adder_2bit (
    .a(a2), .b(b2), .cin(cin2),
    .sum(sum2), .cout(cout2)
  );

  initial begin
    // Dump waves
    $dumpfile("parallel_adder_generator_testbench.vcd");
    $dumpvars(0, parallel_adder_generator_testbench);
    
    $display("=== Parallel Adder Generator Testbench ===");
    $display("Testing different width adders generated with for loops");
    $display();
    
    // Wait for generation messages
    #1;
    
    // Test 4-bit adder
    $display("--- Testing 4-bit Adder ---");
    a4 = 4'b0101; b4 = 4'b0011; cin4 = 1'b0;
    #1;
    $display("4-bit: %b + %b + %b = %b (carry=%b)", a4, b4, cin4, sum4, cout4);
    $display("4-bit: %0d + %0d + %0d = %0d (carry=%0d)", a4, b4, cin4, sum4, cout4);
    
    // Test 8-bit adder
    $display("--- Testing 8-bit Adder ---");
    a8 = 8'b10101010; b8 = 8'b01010101; cin8 = 1'b1;
    #1;
    $display("8-bit: %b + %b + %b = %b (carry=%b)", a8, b8, cin8, sum8, cout8);
    $display("8-bit: %0d + %0d + %0d = %0d (carry=%0d)", a8, b8, cin8, sum8, cout8);
    
    // Test 2-bit adder
    $display("--- Testing 2-bit Adder ---");
    a2 = 2'b11; b2 = 2'b01; cin2 = 1'b1;
    #1;
    $display("2-bit: %b + %b + %b = %b (carry=%b)", a2, b2, cin2, sum2, cout2);
    $display("2-bit: %0d + %0d + %0d = %0d (carry=%0d)", a2, b2, cin2, sum2, cout2);
    
    $display();
    $display("All adders created using the same generate for loop!");
    $display("Each instance automatically generates the correct number of stages.");
    
    #10;
    $finish;
  end

endmodule