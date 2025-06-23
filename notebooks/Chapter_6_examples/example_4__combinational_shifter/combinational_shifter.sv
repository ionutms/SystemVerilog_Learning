// combinational_shifter.sv
module combinational_shifter (
    input  logic [7:0] data_in,     // 8-bit input data
    input  logic [2:0] shift_amt,   // 3-bit shift amount (0-7)
    input  logic [1:0] shift_op,    // 2-bit operation select
    output logic [7:0] data_out     // 8-bit shifted output
);

    // Operation encoding:
    // 00: Logical shift left (LSL)
    // 01: Logical shift right (LSR)
    // 10: Arithmetic shift right (ASR)
    // 11: Rotate right (ROR)

    always_comb begin
        case (shift_op)
            2'b00: begin // Logical shift left
                data_out = data_in << shift_amt;
            end
            
            2'b01: begin // Logical shift right
                data_out = data_in >> shift_amt;
            end
            
            2'b10: begin // Arithmetic shift right (sign extend)
                data_out = $signed(data_in) >>> shift_amt;
            end
            
            2'b11: begin // Rotate right
                case (shift_amt)
                    3'd0: data_out = data_in;
                    3'd1: data_out = {data_in[0], data_in[7:1]};
                    3'd2: data_out = {data_in[1:0], data_in[7:2]};
                    3'd3: data_out = {data_in[2:0], data_in[7:3]};
                    3'd4: data_out = {data_in[3:0], data_in[7:4]};
                    3'd5: data_out = {data_in[4:0], data_in[7:5]};
                    3'd6: data_out = {data_in[5:0], data_in[7:6]};
                    3'd7: data_out = {data_in[6:0], data_in[7]};
                endcase
            end
            
            default: data_out = data_in; // Pass through
        endcase
    end

    // Display shifter operation
    always_comb begin
        case (shift_op)
            2'b00: $display("Shifter: LSL %8b << %0d = %8b", 
                           data_in, shift_amt, data_out);
            2'b01: $display("Shifter: LSR %8b >> %0d = %8b", 
                           data_in, shift_amt, data_out);
            2'b10: $display("Shifter: ASR %8b >>> %0d = %8b", 
                           data_in, shift_amt, data_out);
            2'b11: $display("Shifter: ROR %8b rotate %0d = %8b", 
                           data_in, shift_amt, data_out);
        endcase
    end

endmodule