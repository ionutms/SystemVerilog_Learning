// ring_counter_design.sv
module ring_counter_4bit (
    input  logic clock,
    input  logic reset_n,
    input  logic enable,
    output logic [3:0] ring_output
);

    // 4-bit ring counter register
    logic [3:0] ring_register;
    
    always_ff @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            // Initialize with one bit set (start pattern)
            ring_register <= 4'b0001;
        end
        else if (enable) begin
            // Circular shift: MSB feeds back to LSB
            ring_register <= {ring_register[2:0], ring_register[3]};
        end
    end
    
    // Output the ring register state
    assign ring_output = ring_register;
    
    // Display current state for debugging
    always @(posedge clock) begin
        if (enable && reset_n) begin
            $display("Ring Counter: %b", ring_register);
        end
    end

endmodule