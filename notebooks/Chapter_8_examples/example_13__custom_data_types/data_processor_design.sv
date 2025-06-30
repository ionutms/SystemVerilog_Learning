// data_processor_design.sv
module data_processor_module (
  input  logic        clock_signal,
  input  logic        reset_signal,
  input  logic [7:0]  input_byte_data,
  input  logic [15:0] input_word_data,
  input  logic [31:0] input_dword_data,
  output logic [7:0]  output_byte_result,
  output logic [15:0] output_word_result,
  output logic [31:0] output_dword_result
);

  // Custom data type definitions for better code readability
  typedef logic [7:0]  byte_t;      // 8-bit byte type
  typedef logic [15:0] word_t;      // 16-bit word type  
  typedef logic [31:0] dword_t;     // 32-bit double word type
  typedef logic [63:0] qword_t;     // 64-bit quad word type

  // Internal registers using custom data types
  byte_t  internal_byte_register;
  word_t  internal_word_register;
  dword_t internal_dword_register;
  qword_t internal_qword_register;

  // Processing logic using custom data types
  always_ff @(posedge clock_signal or posedge reset_signal) begin
    if (reset_signal) begin
      internal_byte_register  <= byte_t'(0);
      internal_word_register  <= word_t'(0);
      internal_dword_register <= dword_t'(0);
      internal_qword_register <= qword_t'(0);
    end else begin
      // Process byte data - simple increment with proper width handling
      internal_byte_register <= byte_t'(byte_t'(input_byte_data) + 
                                        byte_t'(1));
      
      // Process word data - shift left by 1 with proper width handling
      internal_word_register <= word_t'(word_t'(input_word_data) << 1);
      
      // Process dword data - bitwise inversion with proper width handling
      internal_dword_register <= dword_t'(~dword_t'(input_dword_data));
      
      // Combine all inputs into qword register
      internal_qword_register <= qword_t'({dword_t'(input_dword_data), 
                                          word_t'(input_word_data), 
                                          byte_t'(input_byte_data),
                                          8'h00});
    end
  end

  // Output assignments using custom data types
  assign output_byte_result  = internal_byte_register;
  assign output_word_result  = internal_word_register;
  assign output_dword_result = internal_dword_register;

  // Display formatted output using custom types
  always_ff @(posedge clock_signal) begin
    if (!reset_signal) begin
      $display("Byte processing:  %02h -> %02h", 
               input_byte_data, internal_byte_register);
      $display("Word processing:  %04h -> %04h", 
               input_word_data, internal_word_register);
      $display("DWord processing: %08h -> %08h", 
               input_dword_data, internal_dword_register);
      $display("QWord combined:   %016h", internal_qword_register);
      $display("----------------------------------------");
    end
  end

endmodule