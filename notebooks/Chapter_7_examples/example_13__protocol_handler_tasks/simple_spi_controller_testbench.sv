// simple_spi_controller_testbench.sv
module spi_controller_testbench;

  // Clock and reset signals
  logic system_clock;
  logic system_reset;
  
  // DUT interface signals
  logic       initiate_transfer;
  logic [7:0] data_to_send;
  logic       spi_serial_clock;
  logic       spi_chip_select_n;
  logic       spi_master_out;
  logic       spi_master_in;
  logic [7:0] data_received;
  logic       transfer_done;

  // Instantiate the design under test
  simple_spi_controller SPI_CONTROLLER_INSTANCE (
    .clock_signal(system_clock),
    .reset_signal(system_reset),
    .start_transaction(initiate_transfer),
    .transmit_data(data_to_send),
    .spi_clock(spi_serial_clock),
    .spi_chip_select(spi_chip_select_n),
    .spi_data_out(spi_master_out),
    .spi_data_in(spi_master_in),
    .received_data(data_received),
    .transaction_complete(transfer_done)
  );

  // Clock generation
  initial begin
    system_clock = 0;
    forever #5 system_clock = ~system_clock;  // 10ns period (100MHz)
  end

  // Task: Protocol handler for SPI write transaction
  task automatic spi_write_transaction(input logic [7:0] write_data);
    begin
      $display("Starting SPI write transaction with data: 0x%02X", 
               write_data);
      
      data_to_send = write_data;
      initiate_transfer = 1;
      @(posedge system_clock);
      initiate_transfer = 0;
      
      // Wait for transaction to complete
      wait(transfer_done);
      @(posedge system_clock);
      
      $display("SPI write transaction completed");
      $display("Data sent: 0x%02X, Data received: 0x%02X", 
               write_data, data_received);
    end
  endtask

  // Task: Protocol handler for SPI read transaction
  task automatic spi_read_transaction(output logic [7:0] read_data);
    begin
      $display("Starting SPI read transaction");
      
      data_to_send = 8'h00;  // Send dummy data for read
      initiate_transfer = 1;
      @(posedge system_clock);
      initiate_transfer = 0;
      
      // Wait for transaction to complete
      wait(transfer_done);
      @(posedge system_clock);
      
      read_data = data_received;
      $display("SPI read transaction completed");
      $display("Data received: 0x%02X", read_data);
    end
  endtask

  // Task: Protocol handler for full duplex SPI transaction
  task automatic spi_full_duplex_transaction(
    input  logic [7:0] tx_data,
    output logic [7:0] rx_data
  );
    begin
      $display("Starting SPI full-duplex transaction");
      $display("Transmitting: 0x%02X", tx_data);
      
      data_to_send = tx_data;
      initiate_transfer = 1;
      @(posedge system_clock);
      initiate_transfer = 0;
      
      // Wait for transaction to complete
      wait(transfer_done);
      @(posedge system_clock);
      
      rx_data = data_received;
      $display("Full-duplex transaction completed");
      $display("Sent: 0x%02X, Received: 0x%02X", tx_data, rx_data);
    end
  endtask

  // Task: Protocol handler for system reset sequence
  task automatic system_reset_sequence();
    begin
      $display("Executing system reset sequence");
      system_reset = 1;
      initiate_transfer = 0;
      data_to_send = 8'h00;
      repeat(3) @(posedge system_clock);
      system_reset = 0;
      @(posedge system_clock);
      $display("System reset sequence completed");
    end
  endtask

  // Test variables
  logic [7:0] received_byte;
  logic [7:0] duplex_received;

  // Simulate SPI slave response
  always @(posedge spi_serial_clock) begin
    if (!spi_chip_select_n) begin
      // Echo back inverted data (simple slave behavior)
      spi_master_in <= ~spi_master_out;
    end
  end

  // Main test sequence
  initial begin
    // Initialize waveform dump
    $dumpfile("spi_controller_testbench.vcd");
    $dumpvars(0, spi_controller_testbench);
    
    $display("=== SPI Protocol Handler Tasks Test ===");
    $display();
    
    // Initialize signals
    initiate_transfer = 0;
    data_to_send = 8'h00;
    spi_master_in = 0;
    
    // Execute reset sequence
    system_reset_sequence();
    
    $display();
    $display("--- Testing Protocol Handler Tasks ---");
    
    // Test write transaction
    spi_write_transaction(8'hA5);
    
    #100;  // Wait between transactions
    
    // Test read transaction
    spi_read_transaction(received_byte);
    
    #100;  // Wait between transactions
    
    // Test full-duplex transaction
    spi_full_duplex_transaction(8'h3C, duplex_received);
    
    #100;  // Wait between transactions
    
    // Test multiple consecutive transactions
    $display();
    $display("--- Testing Multiple Consecutive Transactions ---");
    spi_write_transaction(8'h55);
    spi_write_transaction(8'hAA);
    spi_write_transaction(8'hFF);
    
    #200;  // Final wait
    
    $display();
    $display("=== SPI Protocol Handler Tasks Test Complete ===");
    $finish;
  end

endmodule