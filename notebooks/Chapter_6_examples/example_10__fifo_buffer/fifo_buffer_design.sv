// fifo_buffer_design.sv
module fifo_buffer_8x4 (
    input  logic       clock,
    input  logic       reset_n,
    input  logic       write_enable,
    input  logic       read_enable,
    input  logic [3:0] write_data,
    output logic [3:0] read_data,
    output logic       fifo_full,
    output logic       fifo_empty,
    output logic [2:0] data_count
);

    // FIFO parameters
    parameter FIFO_DEPTH = 8;
    parameter ADDR_WIDTH = 3;  // log2(8) = 3
    
    // FIFO memory array
    logic [3:0] fifo_memory [0:FIFO_DEPTH-1];
    
    // Read and write pointers
    logic [ADDR_WIDTH-1:0] write_pointer;
    logic [ADDR_WIDTH-1:0] read_pointer;
    logic [ADDR_WIDTH:0]   count;  // Extra bit to distinguish full/empty
    
    // FIFO control logic
    always_ff @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            // Reset all pointers and count
            write_pointer <= 0;
            read_pointer <= 0;
            count <= 0;
        end
        else begin
            // Write operation
            if (write_enable && !fifo_full) begin
                fifo_memory[write_pointer] <= write_data;
                write_pointer <= write_pointer + 1;
                $display("WRITE: Data=%h at addr=%d", write_data, write_pointer);
            end
            
            // Read operation
            if (read_enable && !fifo_empty) begin
                read_pointer <= read_pointer + 1;
                $display("READ:  Data=%h from addr=%d", fifo_memory[read_pointer], read_pointer);
            end
            
            // Update count
            case ({write_enable && !fifo_full, read_enable && !fifo_empty})
                2'b10: count <= count + 1;  // Write only
                2'b01: count <= count - 1;  // Read only
                2'b11: count <= count;      // Both (no change)
                2'b00: count <= count;      // Neither (no change)
            endcase
        end
    end
    
    // Output assignments
    assign read_data = fifo_memory[read_pointer];
    assign fifo_full = (count == FIFO_DEPTH);
    assign fifo_empty = (count == 0);
    assign data_count = count[2:0];  // Lower 3 bits for count display
    
    // Status display
    always @(posedge clock) begin
        if (reset_n) begin
            $display("Status: Count=%d, WPtr=%d, RPtr=%d, Full=%b, Empty=%b", 
                     count, write_pointer, read_pointer, fifo_full, fifo_empty);
        end
    end

endmodule