// circular_shift_register.sv
// Simple 4-bit Circular Shift Register
// The MSB output feeds back to become the LSB input

module circular_shift_register (
    input  logic clk,         // Clock signal
    input  logic reset,       // Reset signal (active high)
    input  logic load,        // Load enable signal
    input  logic [3:0] data,  // 4-bit data to load
    output logic [3:0] q      // 4-bit register output
);

    // On each clock edge, shift left and feed MSB back to LSB
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 4'b0000;  // Clear register on reset
        end else if (load) begin
            q <= data;     // Load new data when load is asserted
        end else begin
            // Circular shift: MSB goes to LSB, others shift left
            q <= {q[2:0], q[3]};
        end
    end

    // Display the shifting pattern for simulation
    always @(posedge clk) begin
        if (!reset && !load) begin
            $display("Time %0t: Shift Register = %b", $time, q);
        end
    end

endmodule