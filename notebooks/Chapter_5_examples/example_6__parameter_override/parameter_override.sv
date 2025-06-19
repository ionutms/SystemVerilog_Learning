// parameter_override.sv
// Simple example demonstrating parameter override during instantiation

// Basic counter module with parameters
module simple_counter #(
    parameter int WIDTH = 8,           // Counter width
    parameter int MAX_COUNT = 255,     // Maximum count value
    parameter int STEP = 1,            // Increment step
    parameter bit UP_DOWN = 1'b1,      // 1 for up, 0 for down
    parameter logic [WIDTH-1:0] RESET_VALUE = 0  // Reset value
) (
    input  logic                clk,
    input  logic                reset_n,
    input  logic                enable,
    output logic [WIDTH-1:0]    count,
    output logic                overflow,
    output logic                underflow
);

    // Internal counter register
    logic [WIDTH-1:0] counter_reg;
    
    // Display parameters at initialization
    initial begin
        $display("Counter instantiated with parameters:");
        $display("  WIDTH = %0d", WIDTH);
        $display("  MAX_COUNT = %0d", MAX_COUNT);
        $display("  STEP = %0d", STEP);
        $display("  UP_DOWN = %b (%s)", UP_DOWN, UP_DOWN ? "UP" : "DOWN");
        $display("  RESET_VALUE = %0d", RESET_VALUE);
        $display("  Max representable value = %0d", (2**WIDTH)-1);
    end
    
    // Counter logic
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            counter_reg <= RESET_VALUE;
        end else if (enable) begin
            if (UP_DOWN) begin
                // Count up
                if (counter_reg >= WIDTH'(MAX_COUNT)) begin
                    counter_reg <= RESET_VALUE;  // Wrap around
                end else begin
                    counter_reg <= counter_reg + WIDTH'(STEP);
                end
            end else begin
                // Count down
                if (counter_reg <= WIDTH'(STEP)) begin
                    counter_reg <= WIDTH'(MAX_COUNT);  // Wrap around
                end else begin
                    counter_reg <= counter_reg - WIDTH'(STEP);
                end
            end
        end
    end
    
    // Output assignments
    assign count = counter_reg;
    assign overflow = UP_DOWN && (counter_reg >= WIDTH'(MAX_COUNT)) && enable;
    assign underflow = !UP_DOWN && (counter_reg <= WIDTH'(STEP)) && enable;

endmodule

// Simple memory module with parameters
module simple_ram #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 4,
    parameter int DEPTH = 16,
    parameter string INIT_FILE = "",
    parameter logic [DATA_WIDTH-1:0] INIT_VALUE = 8'h00
) (
    input  logic                    clk,
    input  logic                    we,
    input  logic [ADDR_WIDTH-1:0]   addr,
    input  logic [DATA_WIDTH-1:0]   din,
    output logic [DATA_WIDTH-1:0]   dout
);

    // Memory array
    logic [DATA_WIDTH-1:0] memory [0:DEPTH-1];
    
    // Display parameters
    initial begin
        $display("RAM instantiated with parameters:");
        $display("  DATA_WIDTH = %0d", DATA_WIDTH);
        $display("  ADDR_WIDTH = %0d", ADDR_WIDTH);
        $display("  DEPTH = %0d", DEPTH);
        $display("  INIT_FILE = \"%s\"", INIT_FILE);
        $display("  INIT_VALUE = 0x%h", INIT_VALUE);
        
        // Initialize memory
        if (INIT_FILE != "") begin
            $display("  Loading from file: %s", INIT_FILE);
            $readmemh(INIT_FILE, memory);
        end else begin
            $display("  Initializing with value: 0x%h", INIT_VALUE);
            for (int i = 0; i < DEPTH; i++) begin
                memory[i] = INIT_VALUE;
            end
        end
    end
    
    // RAM logic - Bounds checking handled by array indexing
    always_ff @(posedge clk) begin
        if (we) begin
            memory[addr] <= din;  // SystemVerilog handles out-of-bounds automatically
        end
        dout <= memory[addr];  // SystemVerilog handles out-of-bounds automatically
    end

endmodule

// Simple ALU with parameters
module simple_alu #(
    parameter int WIDTH = 8,
    parameter bit ENABLE_MULT = 1'b0,
    parameter bit ENABLE_DIV = 1'b0,
    parameter real DELAY_NS = 1.0
) (
    input  logic [WIDTH-1:0]    a,
    input  logic [WIDTH-1:0]    b,
    input  logic [2:0]          op,
    output logic [WIDTH-1:0]    result,
    output logic                valid
);

    // Operation codes
    localparam ADD = 3'b000;
    localparam SUB = 3'b001;
    localparam AND = 3'b010;
    localparam OR  = 3'b011;
    localparam XOR = 3'b100;
    localparam MUL = 3'b101;
    localparam DIV = 3'b110;
    
    logic [WIDTH-1:0] temp_result;
    logic temp_valid;
    
    initial begin
        $display("ALU instantiated with parameters:");
        $display("  WIDTH = %0d", WIDTH);
        $display("  ENABLE_MULT = %b", ENABLE_MULT);
        $display("  ENABLE_DIV = %b", ENABLE_DIV);
        $display("  DELAY_NS = %0.1f", DELAY_NS);
    end
    
    // ALU operations
    always_comb begin
        temp_valid = 1'b1;
        
        case (op)
            ADD: temp_result = a + b;
            SUB: temp_result = a - b;
            AND: temp_result = a & b;
            OR:  temp_result = a | b;
            XOR: temp_result = a ^ b;
            MUL: begin
                if (ENABLE_MULT) begin
                    temp_result = WIDTH'(a * b);
                end else begin
                    temp_result = '0;
                    temp_valid = 1'b0;
                end
            end
            DIV: begin
                if (ENABLE_DIV && b != 0) begin
                    temp_result = a / b;
                end else begin
                    temp_result = '0;
                    temp_valid = 1'b0;
                end
            end
            default: begin
                temp_result = '0;
                temp_valid = 1'b0;
            end
        endcase
    end
    
    // Add delay if specified
    generate
        if (DELAY_NS > 0.0) begin : delayed_output
            always #(DELAY_NS) begin
                result = temp_result;
                valid = temp_valid;
            end
        end else begin : immediate_output
            assign result = temp_result;
            assign valid = temp_valid;
        end
    endgenerate

endmodule