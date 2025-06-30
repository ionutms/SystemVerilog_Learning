// command_queue_processor.sv
module command_queue_processor #(
    parameter QUEUE_DEPTH = 8,
    parameter CMD_WIDTH = 64  // 8 characters * 8 bits each
) (
    input  logic                    clock,
    input  logic                    reset_n,
    input  logic                    push_front_enable,
    input  logic                    push_back_enable,
    input  logic                    pop_enable,
    input  logic [CMD_WIDTH-1:0]    command_data_in,
    output logic [CMD_WIDTH-1:0]    command_data_out,
    output logic                    queue_empty,
    output logic                    queue_full
);

    // Internal queue storage
    logic [CMD_WIDTH-1:0] command_queue [0:QUEUE_DEPTH-1];
    logic [$clog2(QUEUE_DEPTH)-1:0] front_pointer;
    logic [$clog2(QUEUE_DEPTH)-1:0] back_pointer;
    logic [$clog2(QUEUE_DEPTH):0] queue_count;

    // Status signals
    assign queue_empty = (queue_count == 0);
    assign queue_full = (queue_count == QUEUE_DEPTH);
    assign command_data_out = queue_empty ? '0 : 
                             command_queue[front_pointer];

    always_ff @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            front_pointer <= 0;
            back_pointer <= 0;
            queue_count <= 0;
            for (int i = 0; i < QUEUE_DEPTH; i++) begin
                command_queue[i] <= '0;
            end
        end else begin
            // Handle push to front
            if (push_front_enable && !queue_full) begin
                if (front_pointer == 0) begin
                    front_pointer <= $clog2(QUEUE_DEPTH)'(QUEUE_DEPTH - 1);
                end else begin
                    front_pointer <= front_pointer - 1;
                end
                command_queue[front_pointer == 0 ? QUEUE_DEPTH-1 : 
                             front_pointer-1] <= command_data_in;
                queue_count <= queue_count + 1;
            end
            // Handle push to back
            else if (push_back_enable && !queue_full) begin
                command_queue[back_pointer] <= command_data_in;
                if (back_pointer == $clog2(QUEUE_DEPTH)'(QUEUE_DEPTH - 1)) begin
                    back_pointer <= 0;
                end else begin
                    back_pointer <= back_pointer + 1;
                end
                queue_count <= queue_count + 1;
            end
            // Handle pop from front
            else if (pop_enable && !queue_empty) begin
                if (front_pointer == $clog2(QUEUE_DEPTH)'(QUEUE_DEPTH - 1)) begin
                    front_pointer <= 0;
                end else begin
                    front_pointer <= front_pointer + 1;
                end
                queue_count <= queue_count - 1;
            end
        end
    end

    // Display current command when it changes
    always @(command_data_out) begin
        if (!queue_empty && command_data_out != 0) begin
            $display("Processing command: %s", command_data_out);
        end
    end

endmodule