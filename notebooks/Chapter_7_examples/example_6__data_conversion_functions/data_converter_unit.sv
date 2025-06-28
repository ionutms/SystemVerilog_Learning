// data_converter_unit.sv
module data_converter_unit();                     // Data conversion functions

  // Function to convert binary to BCD (Binary Coded Decimal)
  function automatic [7:0] binary_to_bcd(input [7:0] binary_value);
    reg [7:0] bcd_result;
    reg [7:0] temp_value;
    integer digit_index;
    begin
      bcd_result = 8'b0;
      temp_value = binary_value;
      
      // Convert using double dabble algorithm (simplified for 8-bit)
      for (digit_index = 0; digit_index < 8; digit_index++) begin
        // Add 3 to BCD digits >= 5 before shifting
        if (bcd_result[3:0] >= 5) bcd_result[3:0] = bcd_result[3:0] + 3;
        if (bcd_result[7:4] >= 5) bcd_result[7:4] = bcd_result[7:4] + 3;
        
        // Shift left and bring in next binary bit
        bcd_result = {bcd_result[6:0], temp_value[7]};
        temp_value = temp_value << 1;
      end
      
      binary_to_bcd = bcd_result;
    end
  endfunction

  // Function to convert signed to unsigned with overflow detection
  function automatic [8:0] signed_to_unsigned_safe(input signed [7:0] 
                                                   signed_input);
    reg overflow_flag;
    reg [7:0] unsigned_result;
    begin
      if (signed_input < 0) begin
        overflow_flag = 1'b1;
        unsigned_result = 8'b0;  // Clamp to zero for negative values
      end else begin
        overflow_flag = 1'b0;
        unsigned_result = signed_input;
      end
      
      // Return {overflow_flag, unsigned_result}
      signed_to_unsigned_safe = {overflow_flag, unsigned_result};
    end
  endfunction

  // Function to convert temperature from Celsius to Fahrenheit
  function automatic [15:0] celsius_to_fahrenheit(input signed [7:0] 
                                                  celsius_temp);
    reg signed [15:0] fahrenheit_result;
    begin
      // F = (C * 9/5) + 32, using fixed point arithmetic
      fahrenheit_result = (celsius_temp * 9) / 5 + 32;
      celsius_to_fahrenheit = fahrenheit_result;
    end
  endfunction

  // Function to pack RGB values into single word
  function automatic [23:0] pack_rgb_color(input [7:0] red_channel,
                                           input [7:0] green_channel,
                                           input [7:0] blue_channel);
    begin
      pack_rgb_color = {red_channel, green_channel, blue_channel};
    end
  endfunction

  // Function to extract RGB components from packed color
  function automatic [23:0] unpack_rgb_color(input [23:0] packed_color,
                                             input [1:0] channel_select);
    begin
      case (channel_select)
        2'b00: unpack_rgb_color = {16'b0, packed_color[23:16]}; // Red
        2'b01: unpack_rgb_color = {16'b0, packed_color[15:8]};  // Green
        2'b10: unpack_rgb_color = {16'b0, packed_color[7:0]};   // Blue
        2'b11: unpack_rgb_color = packed_color;                 // All
      endcase
    end
  endfunction

  initial begin
    $display();
    $display("Data Conversion Functions Demonstration");
    $display("=========================================");
    $display();
  end

endmodule