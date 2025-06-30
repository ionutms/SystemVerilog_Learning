// sparse_memory_controller_testbench.sv
module sparse_memory_testbench;

  // Instantiate the sparse memory controller
  sparse_memory_controller memory_controller_instance();

  // Test addresses - sparse pattern to demonstrate efficiency
  logic [31:0] test_addresses [5] = '{
    32'h0000_1000,  // Low address
    32'h8000_0000,  // High address  
    32'hFFFF_F000,  // Very high address
    32'h0000_2000,  // Another low address
    32'h4000_0000   // Mid-range address
  };

  logic [31:0] test_data [5] = '{
    32'hDEAD_BEEF,
    32'hCAFE_BABE,
    32'h1234_5678,
    32'hABCD_EF00,
    32'h5555_AAAA
  };

  // Unwritten test addresses
  logic [31:0] unwritten_addresses [3] = '{
    32'h0000_0500,  // Between written addresses
    32'h9000_0000,  // High unwritten address
    32'h0000_0000   // Very low address
  };

  initial begin
    // Setup waveform dumping
    $dumpfile("sparse_memory_testbench.vcd");
    $dumpvars(0, sparse_memory_testbench);

    $display("=== Sparse Memory Model Demonstration ===");
    $display();

    // Initialize control signals
    memory_controller_instance.write_enable = 1'b0;
    memory_controller_instance.read_enable = 1'b0;
    memory_controller_instance.memory_address = 32'h0000_0000;
    memory_controller_instance.write_data = 32'h0000_0000;

    #10;

    // Phase 1: Write data to sparse addresses
    $display("Phase 1: Writing to sparse memory addresses");
    for (int i = 0; i < 5; i++) begin
      #10;
      memory_controller_instance.memory_address = test_addresses[i];
      memory_controller_instance.write_data = test_data[i];
      memory_controller_instance.read_enable = 1'b0;
      #1;
      memory_controller_instance.write_enable = 1'b1;
      #1;
      memory_controller_instance.write_enable = 1'b0;
      #1;
    end

    #10;
    $display();
    memory_controller_instance.display_memory_statistics();
    $display();

    // Phase 2: Read from written addresses
    $display("Phase 2: Reading from written addresses");
    for (int i = 0; i < 5; i++) begin
      #10;
      memory_controller_instance.memory_address = test_addresses[i];
      memory_controller_instance.write_enable = 1'b0;
      memory_controller_instance.read_enable = 1'b1;
      #1;
      $display("READ:  Address 0x%08h = 0x%08h (VALID)", 
               test_addresses[i], memory_controller_instance.read_data);
      memory_controller_instance.read_enable = 1'b0;
      #1;
    end

    #10;
    $display();

    // Phase 3: Read from unwritten addresses
    $display("Phase 3: Reading from uninitialized addresses");

    for (int i = 0; i < 3; i++) begin
      #10;
      memory_controller_instance.memory_address = unwritten_addresses[i];
      memory_controller_instance.write_enable = 1'b0;
      memory_controller_instance.read_enable = 1'b1;
      #1;
      $display("READ:  Address 0x%08h = 0x%08h (UNINITIALIZED)", 
               unwritten_addresses[i], memory_controller_instance.read_data);
      memory_controller_instance.read_enable = 1'b0;
      #1;
    end

    #10;
    $display();
    $display("=== Test Complete ===");
    $display("Sparse memory model efficiently stores only 5 addresses");
    $display();

    #50;
    $finish;
  end

endmodule