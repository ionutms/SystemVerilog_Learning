// encoder_width_selector.sv
module encoder_width_selector ();
  
  // Parameter to select encoder width
  parameter WIDTH = 4; // Options: 2, 4, 8 bits
  
  // Generate different encoder implementations based on WIDTH parameter
  generate
    case (WIDTH)
      2: begin : encoder_2bit
        initial begin
          $display("2-bit Encoder Selected");
          $display("- Inputs: 4 (A[3:0])");
          $display("- Outputs: 2 (Y[1:0])");
          $display("- Function: 4-to-2 priority encoder");
        end
      end
      
      4: begin : encoder_4bit
        initial begin
          $display("4-bit Encoder Selected");
          $display("- Inputs: 16 (A[15:0])");
          $display("- Outputs: 4 (Y[3:0])");
          $display("- Function: 16-to-4 priority encoder");
        end
      end
      
      8: begin : encoder_8bit
        initial begin
          $display("8-bit Encoder Selected");
          $display("- Inputs: 256 (A[255:0])");
          $display("- Outputs: 8 (Y[7:0])");
          $display("- Function: 256-to-8 priority encoder");
        end
      end
      
      default: begin : encoder_unsupported
        initial begin
          $display("ERROR: Unsupported encoder width %0d", WIDTH);
          $display("Supported widths: 2, 4, 8 bits");
        end
      end
    endcase
  endgenerate
  
  initial $display("=== Encoder Width Selector Example ===");
  
endmodule