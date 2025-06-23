// magnitude_comparator.sv
// Multi-bit Magnitude Comparator
// Compares two N-bit unsigned numbers and generates comparison outputs

module magnitude_comparator #(
    parameter WIDTH = 8  // Bit width of inputs (default 8-bit)
) (
    input  logic [WIDTH-1:0] a_in,    // First number input
    input  logic [WIDTH-1:0] b_in,    // Second number input
    output logic             equal,   // Output: a == b
    output logic             greater, // Output: a > b
    output logic             less     // Output: a < b
);

    // Combinational comparison logic
    always_comb begin
        equal   = (a_in == b_in);
        greater = (a_in > b_in);
        less    = (a_in < b_in);
    end

    // Display comparison results for simulation
    always_comb begin
        if (equal)
            $display("Comparator: %0d == %0d (Equal)", a_in, b_in);
        else if (greater)
            $display("Comparator: %0d > %0d (Greater)", a_in, b_in);
        else if (less)
            $display("Comparator: %0d < %0d (Less)", a_in, b_in);
    end

    // Verification: exactly one output should be high
    always_comb begin
        assert (equal + greater + less == 1) 
        else $error("Comparator error: Multiple or no outputs active!");
    end

endmodule