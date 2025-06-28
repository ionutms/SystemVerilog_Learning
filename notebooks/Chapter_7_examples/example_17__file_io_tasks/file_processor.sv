// file_processor.sv
module file_data_processor #(
  parameter DATA_WIDTH = 8
)(
  input  logic                    clock,
  input  logic                    reset_n,
  input  logic [DATA_WIDTH-1:0]   input_data,
  input  logic                    data_valid,
  output logic [DATA_WIDTH-1:0]   processed_data,
  output logic                    output_valid
);

  // Simple data processing: increment by 1
  always_ff @(posedge clock or negedge reset_n) begin
    if (!reset_n) begin
      processed_data <= '0;
      output_valid   <= 1'b0;
    end else begin
      if (data_valid) begin
        processed_data <= input_data + 1'b1;  // Simple increment
        output_valid   <= 1'b1;
      end else begin
        output_valid   <= 1'b0;
      end
    end
  end

endmodule