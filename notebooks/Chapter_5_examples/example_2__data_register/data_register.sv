// data_register.sv
module data_register #(
    // Parameters
    parameter int WIDTH = 8,                    // Data width
    parameter logic [WIDTH-1:0] RESET_VALUE = '0, // Reset value
    parameter bit SYNC_RESET = 1'b0,            // 0=async reset, 1=sync reset
    parameter string REGISTER_NAME = "DATA_REG"  // Register name for debugging
) (
    // Clock and reset
    input  logic                clk,            // Clock input
    input  logic                reset_n,        // Reset (active low)
    
    // Control signals
    input  logic                enable,         // Write enable
    input  logic                load,           // Load enable (higher priority)
    input  logic                clear,          // Clear register
    
    // Data signals
    input  logic [WIDTH-1:0]    data_in,       // Data input
    input  logic [WIDTH-1:0]    load_data,     // Load data input
    output logic [WIDTH-1:0]    data_out,      // Data output
    
    // Status signals
    output logic                valid,          // Data valid flag
    output logic                changed         // Data changed flag
);

    // Internal registers
    logic [WIDTH-1:0] data_reg;
    logic [WIDTH-1:0] prev_data;
    logic valid_reg;
    
    // Generate block for reset type selection
    generate
        if (SYNC_RESET) begin : sync_reset_logic
            // Synchronous reset implementation
            always_ff @(posedge clk) begin
                if (!reset_n) begin
                    data_reg <= RESET_VALUE;
                    prev_data <= RESET_VALUE;
                    valid_reg <= 1'b0;
                end else begin
                    prev_data <= data_reg;  // Store previous value
                    
                    if (clear) begin
                        data_reg <= '0;
                        valid_reg <= 1'b0;
                    end else if (load) begin
                        data_reg <= load_data;
                        valid_reg <= 1'b1;
                    end else if (enable) begin
                        data_reg <= data_in;
                        valid_reg <= 1'b1;
                    end
                end
            end
        end else begin : async_reset_logic
            // Asynchronous reset implementation
            always_ff @(posedge clk or negedge reset_n) begin
                if (!reset_n) begin
                    data_reg <= RESET_VALUE;
                    prev_data <= RESET_VALUE;
                    valid_reg <= 1'b0;
                end else begin
                    prev_data <= data_reg;  // Store previous value
                    
                    if (clear) begin
                        data_reg <= '0;
                        valid_reg <= 1'b0;
                    end else if (load) begin
                        data_reg <= load_data;
                        valid_reg <= 1'b1;
                    end else if (enable) begin
                        data_reg <= data_in;
                        valid_reg <= 1'b1;
                    end
                end
            end
        end
    endgenerate
    
    // Output assignments
    assign data_out = data_reg;
    assign valid = valid_reg;
    assign changed = valid_reg && (data_reg != prev_data);
    
    // Debug display (only in simulation)
    initial begin
        $display("%s: Initialized with WIDTH=%0d, RESET_VALUE=%0h, SYNC_RESET=%b", 
                REGISTER_NAME, WIDTH, RESET_VALUE, SYNC_RESET);
    end
    
    // Monitor changes (simulation only)
    always @(posedge clk) begin
        if (reset_n && changed) begin
            $display("%s: Data changed from %0h to %0h at time %0t", 
                    REGISTER_NAME, prev_data, data_reg, $time);
        end
    end

endmodule