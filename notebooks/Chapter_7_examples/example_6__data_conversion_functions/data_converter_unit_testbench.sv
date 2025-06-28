// data_converter_unit_testbench.sv
module data_conversion_testbench;             // Data conversion testbench

  // Instantiate the data converter unit
  data_converter_unit CONVERTER_INSTANCE();

  // Test variables
  reg [7:0] test_binary_value;
  reg signed [7:0] test_signed_value;
  reg signed [7:0] test_celsius_temp;
  reg [7:0] test_red, test_green, test_blue;
  reg [23:0] test_packed_color;
  integer test_channel_select;

  // Result variables
  reg [7:0] bcd_result;
  reg [8:0] unsigned_result;
  reg [15:0] fahrenheit_result;
  reg [23:0] packed_result;
  reg [23:0] unpacked_result;

  initial begin
    // Setup waveform dumping
    $dumpfile("data_conversion_testbench.vcd");
    $dumpvars(0, data_conversion_testbench);
    
    #1;  // Wait for initialization
    
    $display("Testing Binary to BCD Conversion:");
    $display("================================");
    
    // Test binary to BCD conversion
    test_binary_value = 8'd42;
    bcd_result = CONVERTER_INSTANCE.binary_to_bcd(test_binary_value);
    $display(
        "Binary %d converts to BCD 0x%h", test_binary_value, bcd_result);
    
    test_binary_value = 8'd99;
    bcd_result = CONVERTER_INSTANCE.binary_to_bcd(test_binary_value);
    $display(
        "Binary %d converts to BCD 0x%h", test_binary_value, bcd_result);
    
    $display();
    $display("Testing Signed to Unsigned Conversion:");
    $display("=====================================");
    
    // Test signed to unsigned conversion
    test_signed_value = -25;
    unsigned_result = CONVERTER_INSTANCE.signed_to_unsigned_safe(
                      test_signed_value);
    $display(
        "Signed %d converts to unsigned %d (overflow: %b)", 
        test_signed_value, unsigned_result[7:0], unsigned_result[8]);
    
    test_signed_value = 100;
    unsigned_result = CONVERTER_INSTANCE.signed_to_unsigned_safe(
                      test_signed_value);
    $display(
        "Signed %d converts to unsigned %d (overflow: %b)", 
        test_signed_value, unsigned_result[7:0], unsigned_result[8]);
    
    $display();
    $display("Testing Temperature Conversion:");
    $display("==============================");
    
    // Test temperature conversion
    test_celsius_temp = 0;
    fahrenheit_result = CONVERTER_INSTANCE.celsius_to_fahrenheit(
                        test_celsius_temp);
    $display(
        "Temperature %d Celsius converts to %d Fahrenheit", 
        test_celsius_temp, fahrenheit_result);
    
    test_celsius_temp = 25;
    fahrenheit_result = CONVERTER_INSTANCE.celsius_to_fahrenheit(
                        test_celsius_temp);
    $display(
        "Temperature %d Celsius converts to %d Fahrenheit", 
        test_celsius_temp, fahrenheit_result);
    
    $display();
    $display("Testing RGB Color Packing/Unpacking:");
    $display("===================================");
    
    // Test RGB color packing
    test_red = 8'hFF;    // Maximum red
    test_green = 8'h80;  // Medium green
    test_blue = 8'h40;   // Low blue
    
    packed_result = CONVERTER_INSTANCE.pack_rgb_color(test_red, test_green, 
                                                      test_blue);
    $display("RGB(%h, %h, %h) packs to 0x%h", test_red, test_green, 
             test_blue, packed_result);
    
    // Test RGB color unpacking
    test_packed_color = 24'hFF8040;
    
    for (test_channel_select = 0; test_channel_select < 4; 
         test_channel_select = test_channel_select + 1) begin
      unpacked_result = CONVERTER_INSTANCE.unpack_rgb_color(
                        test_packed_color, test_channel_select[1:0]);
      case (test_channel_select[1:0])
        2'b00: $display("Red channel: 0x%h", unpacked_result[7:0]);
        2'b01: $display("Green channel: 0x%h", unpacked_result[7:0]);
        2'b10: $display("Blue channel: 0x%h", unpacked_result[7:0]);
        2'b11: $display("All channels: 0x%h", unpacked_result);
      endcase
    end
    
    $display();
    $display("Data conversion function testing completed successfully!");
    $display();

  end

endmodule