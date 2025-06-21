// encoder_width_selector.sv
module encoder_width_selector #(
  parameter INPUT_WIDTH = 4    // Valid values: 2, 4, 8, 16
)(
  input  logic [INPUT_WIDTH-1:0] data_in,
  output logic [$clog2(INPUT_WIDTH)-1:0] encoded_out,
  output logic valid_out
);

  localparam OUTPUT_WIDTH = $clog2(INPUT_WIDTH);

  // Generate different encoder implementations based on input width
  generate
    case (INPUT_WIDTH)
      
      2: begin : encoder_2to1
        // 2-to-1 encoder
        always_comb begin
          case (data_in)
            2'b01: begin encoded_out = 1'b0; valid_out = 1'b1; end
            2'b10: begin encoded_out = 1'b1; valid_out = 1'b1; end
            default: begin encoded_out = 1'b0; valid_out = 1'b0; end
          endcase
        end
        
        initial $display("Generated 2-to-1 encoder (2 inputs -> 1 output)");
      end
      
      4: begin : encoder_4to2
        // 4-to-2 encoder  
        always_comb begin
          casez (data_in)
            4'b0001: begin encoded_out = 2'b00; valid_out = 1'b1; end
            4'b0010: begin encoded_out = 2'b01; valid_out = 1'b1; end
            4'b0100: begin encoded_out = 2'b10; valid_out = 1'b1; end
            4'b1000: begin encoded_out = 2'b11; valid_out = 1'b1; end
            default: begin encoded_out = 2'b00; valid_out = 1'b0; end
          endcase
        end
        
        initial $display("Generated 4-to-2 encoder (4 inputs -> 2 outputs)");
      end
      
      8: begin : encoder_8to3
        // 8-to-3 encoder
        always_comb begin
          casez (data_in)
            8'b00000001: begin encoded_out = 3'b000; valid_out = 1'b1; end
            8'b00000010: begin encoded_out = 3'b001; valid_out = 1'b1; end
            8'b00000100: begin encoded_out = 3'b010; valid_out = 1'b1; end
            8'b00001000: begin encoded_out = 3'b011; valid_out = 1'b1; end
            8'b00010000: begin encoded_out = 3'b100; valid_out = 1'b1; end
            8'b00100000: begin encoded_out = 3'b101; valid_out = 1'b1; end
            8'b01000000: begin encoded_out = 3'b110; valid_out = 1'b1; end
            8'b10000000: begin encoded_out = 3'b111; valid_out = 1'b1; end
            default: begin encoded_out = 3'b000; valid_out = 1'b0; end
          endcase
        end
        
        initial $display("Generated 8-to-3 encoder (8 inputs -> 3 outputs)");
      end
      
      16: begin : encoder_16to4
        // 16-to-4 encoder (simplified implementation)
        always_comb begin
          encoded_out = 4'b0000;
          valid_out = 1'b0;
          
          for (int i = 0; i < 16; i++) begin
            if (data_in[i]) begin
              encoded_out = i[3:0];
              valid_out = 1'b1;
              break;
            end
          end
        end
        
        initial $display("Generated 16-to-4 encoder (16 inputs -> 4 outputs)");
      end
      
      default: begin : encoder_invalid
        // Invalid width - tie outputs to zero
        assign encoded_out = '0;
        assign valid_out = 1'b0;
        
        initial begin
          $display("ERROR: Invalid INPUT_WIDTH = %0d", INPUT_WIDTH);
          $display("Valid widths: 2, 4, 8, 16");
        end
      end
      
    endcase
  endgenerate

  initial begin
    $display();
    $display("=== Encoder Width Selector ===");
    $display("INPUT_WIDTH = %0d", INPUT_WIDTH);
    $display("OUTPUT_WIDTH = %0d", OUTPUT_WIDTH);
    $display();
  end

endmodule