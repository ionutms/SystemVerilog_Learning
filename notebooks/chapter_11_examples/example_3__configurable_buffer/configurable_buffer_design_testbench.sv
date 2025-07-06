// configurable_buffer_design_testbench.sv
module configurable_buffer_testbench;
  import buffer_pkg::*;
  
  // Instantiate design under test
  configurable_buffer_design DESIGN_INSTANCE_NAME();
  
  // Test different buffer configurations
  configurable_buffer #(.BUFFER_SIZE(4), .DATA_TYPE(logic [7:0])) 
    byte_buffer;
  
  configurable_buffer #(.BUFFER_SIZE(8), .DATA_TYPE(logic [15:0])) 
    word_buffer;
  
  configurable_buffer #(.BUFFER_SIZE(16), .DATA_TYPE(logic [31:0])) 
    dword_buffer;
  
  // Test variables
  logic [7:0]  byte_data;
  logic [15:0] word_data;
  logic [31:0] dword_data;
  bit success;
  
  initial begin
    // Dump waves for verilator
    $dumpfile("configurable_buffer_testbench.vcd");
    $dumpvars(0, configurable_buffer_testbench);
    
    $display("=== Configurable Buffer Testbench Starting ===");
    $display();
    
    // Create buffer instances
    byte_buffer = new();
    word_buffer = new();
    dword_buffer = new();
    
    $display("\n=== Testing 8-bit Buffer (size=4) ===");
    test_byte_buffer();
    
    $display("\n=== Testing 16-bit Buffer (size=8) ===");
    test_word_buffer();
    
    $display("\n=== Testing 32-bit Buffer (size=16) ===");
    test_dword_buffer();
    
    $display("\n=== Testing Buffer Overflow/Underflow ===");
    test_edge_cases();
    
    #10; // Wait for a few time units
    $display("\n=== Configurable Buffer Testbench Complete ===");
    $finish;
  end
  
  // Test 8-bit buffer
  task test_byte_buffer();
    $display("Testing byte buffer operations...");
    
    // Fill buffer partially
    for (int i = 0; i < 3; i++) begin
      byte_data = 8'h10 + 8'(i);
      success = byte_buffer.write_data(byte_data);
      byte_buffer.display_status();
    end
    
    // Read some data
    for (int i = 0; i < 2; i++) begin
      success = byte_buffer.read_data(byte_data);
      byte_buffer.display_status();
    end
    
    // Write more data
    byte_data = 8'hFF;
    success = byte_buffer.write_data(byte_data);
    byte_buffer.display_status();
  endtask
  
  // Test 16-bit buffer
  task test_word_buffer();
    $display("Testing word buffer operations...");
    
    // Fill buffer with pattern
    for (int i = 0; i < 5; i++) begin
      word_data = 16'h1000 + 16'(i * 16'h0111);
      success = word_buffer.write_data(word_data);
      if (i % 2 == 0) word_buffer.display_status();
    end
    
    // Read all data
    while (!word_buffer.is_empty()) begin
      success = word_buffer.read_data(word_data);
      if (word_buffer.get_count() % 2 == 0) word_buffer.display_status();
    end
  endtask
  
  // Test 32-bit buffer
  task test_dword_buffer();
    $display("Testing dword buffer operations...");
    
    // Write pattern data
    for (int i = 0; i < 10; i++) begin
      dword_data = 32'h12345000 + 32'(i);
      success = dword_buffer.write_data(dword_data);
      if (i % 3 == 0) dword_buffer.display_status();
    end
    
    // Read half the data
    for (int i = 0; i < 5; i++) begin
      success = dword_buffer.read_data(dword_data);
      if (i % 2 == 0) dword_buffer.display_status();
    end
    
    // Reset and verify
    dword_buffer.reset();
    dword_buffer.display_status();
  endtask
  
  // Test edge cases
  task test_edge_cases();
    $display("Testing overflow and underflow conditions...");
    
    // Reset byte buffer for clean test
    byte_buffer.reset();
    
    // Fill buffer completely
    $display("Filling buffer to capacity...");
    for (int i = 0; i < 5; i++) begin  // Try to write 5 items to 4-slot buffer
      byte_data = 8'hA0 + 8'(i);
      success = byte_buffer.write_data(byte_data);
      byte_buffer.display_status();
    end
    
    // Try to read more than available
    $display("Emptying buffer and trying to read beyond...");
    for (int i = 0; i < 6; i++) begin  // Try to read 6 items from 4-slot buffer
      success = byte_buffer.read_data(byte_data);
      byte_buffer.display_status();
    end
  endtask
  
endmodule