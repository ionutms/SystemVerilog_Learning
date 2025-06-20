// port_direction.sv
module port_direction (
    // INPUT ports - data flows INTO the module
    input  logic       clk,        // Clock signal
    input  logic       reset_n,    // Active-low reset
    input  logic [3:0] data_in,    // 4-bit input data
    
    // OUTPUT ports - data flows OUT of the module
    output logic [3:0] data_out,   // 4-bit output data
    output logic       valid_out,  // Output valid flag
    
    // INOUT ports - bidirectional data flow
    inout  wire  [7:0] bus_data,   // 8-bit bidirectional bus
    
    // REF ports - pass by reference (SystemVerilog only)
    ref    logic [1:0] ref_counter // Reference to external counter
);

    // Internal signals
    logic       bus_enable;    // Controls bus direction
    logic [7:0] internal_bus;  // Internal bus data
    
    // Simple counter for demonstration
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            data_out <= 4'h0;
            valid_out <= 1'b0;
            internal_bus <= 8'h00;
            bus_enable <= 1'b0;
        end else begin
            // Process input data (double it)
            data_out <= data_in * 2;
            valid_out <= |data_in;  // Valid if any input bit is set
            
            // Bus control logic
            bus_enable <= data_in[0];  // Use LSB to control bus
            if (data_in[0]) begin
                internal_bus <= {4'h0, data_in};  // Drive bus
            end
            
            // Modify ref_counter directly (demonstrates ref port)
            if (valid_out) begin
                ref_counter <= ref_counter + 1;
            end
        end
    end
    
    // Bidirectional bus driver
    assign bus_data = bus_enable ? internal_bus : 8'hZZ;
    
    // Display messages for simulation
    initial begin
        $display();
        $display("Port Direction Demo module initialized");
        $display("  - INPUT: clk, reset_n, data_in");
        $display("  - OUTPUT: data_out, valid_out");
        $display("  - INOUT: bus_data (bidirectional)");
        $display("  - REF: ref_counter (pass by reference)");
        $display();
    end

endmodule