// parallel_adder_generator.sv

// Simple full adder module
module full_adder (
  input  logic a, b, cin,
  output logic sum, cout
);
  assign {cout, sum} = a + b + cin;
endmodule

// Parallel adder using generate for loops
module parallel_adder_generator #(
  parameter WIDTH = 4
)(
  input  logic [WIDTH-1:0] a, b,
  input  logic cin,
  output logic [WIDTH-1:0] sum,
  output logic cout
);

  // Internal carry signals
  logic [WIDTH:0] carry;
  
  // Connect input carry
  assign carry[0] = cin;
  
  // Connect output carry
  assign cout = carry[WIDTH];

  // Generate block for creating multiple full adders
  genvar i;
  generate
    for (i = 0; i < WIDTH; i++) begin : adder_stage
      full_adder fa_inst (
        .a(a[i]),
        .b(b[i]),
        .cin(carry[i]),
        .sum(sum[i]),
        .cout(carry[i+1])
      );
      
      // Display which stage is being generated
      initial begin
        $display("Generated adder stage %0d", i);
      end
    end
  endgenerate

  initial begin
    $display();
    $display("=== Parallel Adder Generator ===");
    $display("WIDTH = %0d bits", WIDTH);
    $display("Generated %0d full adder stages", WIDTH);
    $display();
  end

endmodule