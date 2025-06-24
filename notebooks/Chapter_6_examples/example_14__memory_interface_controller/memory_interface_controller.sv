// memory_interface_controller.sv
module memory_interface_controller (
    input  logic        clk,
    input  logic        rst_n,
    
    // CPU Interface
    input  logic        cpu_req,           // CPU request
    input  logic        cpu_wr_en,         // CPU write enable (1=write, 0=read)
    input  logic [7:0]  cpu_addr,          // CPU address
    input  logic [15:0] cpu_wr_data,       // CPU write data
    output logic [15:0] cpu_rd_data,       // CPU read data
    output logic        cpu_ready,         // CPU ready signal
    
    // External Memory Interface
    output logic        mem_req,           // Memory request
    output logic        mem_wr_en,         // Memory write enable
    output logic [7:0]  mem_addr,          // Memory address
    output logic [15:0] mem_wr_data,       // Memory write data
    input  logic [15:0] mem_rd_data,       // Memory read data
    input  logic        mem_ready          // Memory ready signal
);

    // State machine states
    typedef enum logic [1:0] {
        IDLE        = 2'b00,
        MEM_ACCESS  = 2'b01,
        WAIT_READY  = 2'b10
    } state_t;
    
    state_t current_state, next_state;
    
    // Internal registers
    logic [7:0]  addr_reg;
    logic [15:0] wr_data_reg;
    logic        wr_en_reg;
    
    // State machine: sequential logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            addr_reg      <= 8'b0;
            wr_data_reg   <= 16'b0;
            wr_en_reg     <= 1'b0;
        end else begin
            current_state <= next_state;
            
            // Capture CPU request when transitioning to MEM_ACCESS
            if (current_state == IDLE && cpu_req) begin
                addr_reg    <= cpu_addr;
                wr_data_reg <= cpu_wr_data;
                wr_en_reg   <= cpu_wr_en;
            end
        end
    end
    
    // State machine: combinational logic
    always_comb begin
        // Default values
        next_state = current_state;
        mem_req    = 1'b0;
        cpu_ready  = 1'b0;
        
        case (current_state)
            IDLE: begin
                cpu_ready = 1'b1;  // Ready to accept new requests
                if (cpu_req) begin
                    next_state = MEM_ACCESS;
                end
            end
            
            MEM_ACCESS: begin
                mem_req = 1'b1;    // Send request to memory
                if (mem_ready) begin
                    cpu_ready  = 1'b1;  // Transaction complete
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_READY;
                end
            end
            
            WAIT_READY: begin
                mem_req = 1'b1;    // Keep request active
                if (mem_ready) begin
                    cpu_ready  = 1'b1;  // Transaction complete
                    next_state = IDLE;
                end
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end
    
    // Memory interface outputs
    assign mem_addr    = addr_reg;
    assign mem_wr_data = wr_data_reg;
    assign mem_wr_en   = wr_en_reg;
    
    // CPU read data output
    assign cpu_rd_data = mem_rd_data;
    
    initial $display("Memory Interface Controller initialized");

endmodule