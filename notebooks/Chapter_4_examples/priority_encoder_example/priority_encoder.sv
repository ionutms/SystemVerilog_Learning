// priority_encoder.sv
module priority_encoder(
    input logic [7:0] data_in,
    output logic [2:0] encoded_out,
    output logic valid
);
    always_comb begin
        if (data_in[7])
            encoded_out = 3'd7;
        else if (data_in[6])
            encoded_out = 3'd6;
        else if (data_in[5])
            encoded_out = 3'd5;
        else if (data_in[4])
            encoded_out = 3'd4;
        else if (data_in[3])
            encoded_out = 3'd3;
        else if (data_in[2])
            encoded_out = 3'd2;
        else if (data_in[1])
            encoded_out = 3'd1;
        else if (data_in[0])
            encoded_out = 3'd0;
        else
            encoded_out = 3'd0;
            
        valid = |data_in; // OR reduction - valid when any bit is set
    end
endmodule