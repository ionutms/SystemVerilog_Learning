// port_direction_demo.sv
module port_direction_demo #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 4,
    parameter string MODULE_NAME = "PORT_DEMO"
) (
    // Standard INPUT ports
    input  logic                    clk,            // Clock input
    input  logic                    reset_n,        // Reset input (active low)
    input  logic                    enable,         // Enable signal
    input  logic [DATA_WIDTH-1:0]   data_in,        // Data input
    input  logic [ADDR_WIDTH-1:0]   address,        // Address input
    input  logic                    read_enable,    // Read enable
    input  logic                    write_enable,   // Write enable
    
    // Standard OUTPUT ports
    output logic [DATA_WIDTH-1:0]   data_out,       // Data output
    output logic                    valid_out,      // Valid output flag
    output logic                    ready,          // Ready signal
    output logic                    error,          // Error flag
    output logic [1:0]              status,         // Status output
    
    // INOUT (bidirectional) ports
    inout  wire  [DATA_WIDTH-1:0]   data_bus,       // Bidirectional data bus
    inout  wire                     bus_enable,     // Bidirectional control
    
    // REF ports (SystemVerilog reference - for testbench use)
    ref    logic [DATA_WIDTH-1:0]   debug_data,     // Reference to external signal
    ref    logic                    debug_valid     // Reference to external signal
);

    // Internal registers and wires
    logic [DATA_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1];
    logic [DATA_WIDTH-1:0] internal_data;
    logic [DATA_WIDTH-1:0] bus_data_out;
    logic bus_drive_enable;
    logic [2:0] state;
    logic internal_valid;
    
    // Initialize memory
    initial begin
        for (int i = 0; i < (1<<ADDR_WIDTH); i++) begin
            memory[i] = i[DATA_WIDTH-1:0];  // Initialize with address values
        end
        $display("%s: Memory initialized with %0d locations", MODULE_NAME, 1<<ADDR_WIDTH);
    end
    
    //========================================================================
    // INPUT Port Usage Examples
    // - Inputs can only be read, never assigned
    // - Connected from outside the module
    //========================================================================
    
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            internal_data <= '0;
            internal_valid <= 1'b0;
            state <= 3'b000;
        end else if (enable) begin
            // Reading from INPUT ports
            if (write_enable && address < (1<<ADDR_WIDTH)) begin
                memory[address] <= data_in;  // Use input port data_in
                internal_data <= data_in;
                internal_valid <= 1'b1;
                state <= 3'b001;  // Write state
                $display("%s: Write operation - addr=%0h, data=%0h", 
                        MODULE_NAME, address, data_in);
            end else if (read_enable && address < (1<<ADDR_WIDTH)) begin
                internal_data <= memory[address];
                internal_valid <= 1'b1;
                state <= 3'b010;  // Read state
                $display("%s: Read operation - addr=%0h, data=%0h", 
                        MODULE_NAME, address, memory[address]);
            end else begin
                internal_valid <= 1'b0;
                state <= 3'b000;  // Idle state
            end
        end
    end
    
    //========================================================================
    // OUTPUT Port Usage Examples
    // - Outputs can only be assigned, never read internally
    // - Drive signals to outside the module
    //========================================================================
    
    // Continuous assignments to OUTPUT ports
    assign data_out = internal_data;
    assign valid_out = internal_valid;
    assign ready = !reset_n ? 1'b0 : enable;
    assign error = (write_enable || read_enable) && (address >= (1<<ADDR_WIDTH));
    assign status = {error, internal_valid};
    
    //========================================================================
    // INOUT (Bidirectional) Port Usage Examples
    // - Can be driven or read depending on control signals
    // - Requires tri-state logic
    // - Common for buses, shared resources
    //========================================================================
    
    // Control when to drive the bidirectional bus
    always_comb begin
        bus_drive_enable = enable && write_enable && (state == 3'b001);
        bus_data_out = internal_data;
    end
    
    // Tri-state driver for bidirectional data bus
    assign data_bus = bus_drive_enable ? bus_data_out : 'z;
    
    // Tri-state driver for bidirectional control
    assign bus_enable = bus_drive_enable ? 1'b1 : 'z;
    
    // Reading from bidirectional bus when not driving
    logic [DATA_WIDTH-1:0] bus_data_in;
    logic bus_enable_in;
    
    always_comb begin
        if (!bus_drive_enable) begin
            bus_data_in = data_bus;
            bus_enable_in = bus_enable;
        end else begin
            bus_data_in = 'x;  // Don't care when driving
            bus_enable_in = 'x;
        end
    end
    
    //========================================================================
    // REF Port Usage Examples
    // - References to signals in parent scope
    // - Mainly used in testbenches for debugging
    // - Allows direct access without port connections
    //========================================================================
    
    // Update debug references (these would be connected to testbench signals)
    always_comb begin
        // Note: In actual usage, these would reference signals in testbench
        // Here we're just showing the syntax
        if (internal_valid) begin
            // debug_data and debug_valid are references to external signals
            // They would be automatically updated when the referenced signals change
        end
    end
    
    // Debug monitoring using ref ports
    always @(debug_data or debug_valid) begin
        if (debug_valid) begin
            $display("%s: Debug - External debug_data changed to %0h at time %0t", 
                    MODULE_NAME, debug_data, $time);
        end
    end
    
    //========================================================================
    // Port Direction Summary and Best Practices
    //========================================================================
    
    initial begin
        $display();
        $display("=== Port Direction Examples in %s ===", MODULE_NAME);
        $display("INPUT ports:  Can only be READ, never assigned");
        $display("OUTPUT ports: Can only be ASSIGNED, never read internally");
        $display("INOUT ports:  Can be both READ and DRIVEN (tri-state)");
        $display("REF ports:    References to signals in parent scope");
        $display();
    end
    
    // Demonstrate port usage violations (these would cause compilation errors)
    /*
    // WRONG - Cannot assign to input ports
    always_comb begin
        data_in = 8'h00;        // ERROR: Cannot assign to input
        clk = 1'b0;             // ERROR: Cannot assign to input
    end
    
    // WRONG - Cannot read output ports internally
    always_comb begin
        internal_data = data_out;  // ERROR: Cannot read output port
    end
    
    // WRONG - Direct assignment to inout without tri-state
    assign data_bus = internal_data;  // ERROR: Need tri-state logic
    */

endmodule