// byte_array_processor.sv
module byte_array_processor (
  input  logic        clock,
  input  logic        reset,
  input  logic [31:0] data_word,           // 4-byte input word
  input  logic [1:0]  byte_select,         // Select which byte to access
  input  logic        write_enable,        // Enable write operation
  output logic [7:0]  selected_byte,       // Output selected byte
  output logic        byte_parity,         // Parity of selected byte
  output logic [3:0]  nibble_high,         // Upper 4 bits of byte
  output logic [3:0]  nibble_low           // Lower 4 bits of byte
);

  // Internal byte array storage (4 bytes = 32 bits)
  logic [31:0] byte_array_storage;

  // Byte extraction from packed array
  logic [7:0] byte_0, byte_1, byte_2, byte_3;
  
  always_comb begin
    // Extract individual bytes from packed array
    byte_0 = byte_array_storage[7:0];       // LSB byte
    byte_1 = byte_array_storage[15:8];      // Byte 1
    byte_2 = byte_array_storage[23:16];     // Byte 2  
    byte_3 = byte_array_storage[31:24];     // MSB byte
    
    // Select byte based on byte_select input
    case (byte_select)
      2'b00: selected_byte = byte_0;
      2'b01: selected_byte = byte_1;
      2'b10: selected_byte = byte_2;
      2'b11: selected_byte = byte_3;
    endcase
    
    // Bit-level operations on selected byte
    byte_parity = ^selected_byte;           // XOR reduction for parity
    nibble_high = selected_byte[7:4];       // Upper nibble
    nibble_low  = selected_byte[3:0];       // Lower nibble
  end

  // Sequential logic for storage updates
  always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
      byte_array_storage <= 32'h00000000;
    end else if (write_enable) begin
      byte_array_storage <= data_word;
    end
  end

  // Display byte array contents for debugging
  initial begin
    $display("Byte Array Processor initialized");
  end

endmodule