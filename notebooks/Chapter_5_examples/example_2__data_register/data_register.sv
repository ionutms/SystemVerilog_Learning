// data_register.sv
module data_register (
    input  logic       clk,     // Clock signal
    input  logic       rst_n,   // Active-low reset
    input  logic       enable,  // Enable signal
    input  logic [7:0] data_in, // 8-bit input data
    output logic [7:0] data_out // 8-bit output data
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 8'h00;  // Reset to zero
        end else if (enable) begin
            data_out <= data_in; // Load input data when enabled
        end
        // If enable is low, data_out retains its value
    end

    // Display messages for simulation
    initial begin
        $display();
        $display("Data Register module initialized");
        $display("  - 8-bit register with enable control");
        $display("  - Active-low reset");
        $display();
    end

endmodule