// fsm.sv
typedef enum logic [1:0] {
    IDLE = 2'b00,
    READ = 2'b01,
    WRITE = 2'b10,
    DONE = 2'b11
} state_t;

module fsm(
    input logic clk, rst_n, start, rw,
    output logic busy, done
);
    state_t current_state, next_state;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end
    
    always_comb begin
        unique case (current_state)
            IDLE: begin
                if (start)
                    next_state = rw ? WRITE : READ;
                else
                    next_state = IDLE;
            end
            READ: next_state = DONE;
            WRITE: next_state = DONE;
            DONE: next_state = IDLE;
        endcase
    end
    
    assign busy = (current_state != IDLE);
    assign done = (current_state == DONE);
endmodule