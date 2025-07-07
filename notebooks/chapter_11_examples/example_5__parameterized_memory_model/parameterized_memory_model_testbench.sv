// parameterized_memory_model_testbench.sv
// Testbench for parameterized memory model

module memory_model_test_bench;
  import memory_model_pkg::*;
  
  // Instantiate design under test
  parameterized_memory_model MEMORY_MODEL_INSTANCE();
  
  // Test variables
  typedef ParameterizedMemory #(.ADDR_WIDTH(8), .DATA_WIDTH(32)) Memory32;
  typedef ParameterizedMemory #(.ADDR_WIDTH(4), .DATA_WIDTH(16)) Memory16;
  
  Memory32 mem32;
  Memory16 mem16;
  
  bit [31:0] read_data_32;
  bit [15:0] read_data_16;
  
  initial begin
    // Setup waveform dumping
    $dumpfile("memory_model_test_bench.vcd");
    $dumpvars(0, memory_model_test_bench);
    
    $display("=== Parameterized Memory Model Test ===");
    $display();
    
    // Test 32-bit memory
    $display("--- Testing 32-bit Memory (8-bit addr) ---");
    mem32 = new();
    
    // Write some data
    mem32.write(8'h00, 32'hDEADBEEF);
    mem32.write(8'h01, 32'hCAFEBABE);
    mem32.write(8'hFF, 32'h12345678);
    
    $display();
    
    // Read back data
    read_data_32 = mem32.read(8'h00);
    read_data_32 = mem32.read(8'h01);
    read_data_32 = mem32.read(8'hFF);
    
    // Try reading uninitialized address
    $display();
    read_data_32 = mem32.read(8'h10);
    
    $display();
    mem32.dump_memory();
    
    $display();
    mem32.print_stats();
    
    $display();
    $display("--- Testing 16-bit Memory (4-bit addr) ---");
    mem16 = new();
    
    // Write some data
    mem16.write(4'h0, 16'hABCD);
    mem16.write(4'h1, 16'h1234);
    mem16.write(4'hF, 16'h9876);
    
    $display();
    
    // Read back data
    read_data_16 = mem16.read(4'h0);
    read_data_16 = mem16.read(4'h1);
    read_data_16 = mem16.read(4'hF);
    
    $display();
    mem16.dump_memory();
    
    $display();
    mem16.print_stats();
    
    // Test clear functionality
    $display();
    $display("--- Testing Clear Functionality ---");
    mem32.clear();
    mem32.dump_memory();
    mem32.print_stats();
    
    $display();
    $display("Test completed successfully!");
    
    // Small delay before finishing
    #10;
    
  end
  
endmodule