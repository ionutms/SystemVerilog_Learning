// simple_spi_controller.sv
module simple_spi_controller (
  input  logic       clock_signal,
  input  logic       reset_signal,
  input  logic       start_transaction,
  input  logic [7:0] transmit_data,
  output logic       spi_clock,
  output logic       spi_chip_select,
  output logic       spi_data_out,
  input  logic       spi_data_in,
  output logic [7:0] received_data,
  output logic       transaction_complete
);

  typedef enum logic [1:0] {
    IDLE_STATE,
    ACTIVE_STATE,
    COMPLETE_STATE
  } protocol_state_type;

  protocol_state_type current_state, next_state;
  logic [3:0] bit_counter;
  logic [7:0] shift_register_tx, shift_register_rx;

  // State machine for SPI protocol
  always_ff @(posedge clock_signal or posedge reset_signal) begin
    if (reset_signal) begin
      current_state <= IDLE_STATE;
      bit_counter <= 0;
      shift_register_tx <= 0;
      shift_register_rx <= 0;
      spi_clock <= 0;
      spi_chip_select <= 1;
      spi_data_out <= 0;
      received_data <= 0;
      transaction_complete <= 0;
    end else begin
      current_state <= next_state;
      
      case (current_state)
        IDLE_STATE: begin
          spi_chip_select <= 1;
          spi_clock <= 0;
          transaction_complete <= 0;
          if (start_transaction) begin
            shift_register_tx <= transmit_data;
            bit_counter <= 0;
          end
        end
        
        ACTIVE_STATE: begin
          spi_chip_select <= 0;
          spi_clock <= ~spi_clock;
          
          if (spi_clock) begin  // Rising edge of SPI clock
            shift_register_rx <= {shift_register_rx[6:0], spi_data_in};
            bit_counter <= bit_counter + 1;
          end else begin        // Falling edge of SPI clock
            spi_data_out <= shift_register_tx[7];
            shift_register_tx <= {shift_register_tx[6:0], 1'b0};
          end
        end
        
        COMPLETE_STATE: begin
          spi_chip_select <= 1;
          spi_clock <= 0;
          received_data <= shift_register_rx;
          transaction_complete <= 1;
        end
        
        default: begin
          spi_chip_select <= 1;
          spi_clock <= 0;
          transaction_complete <= 0;
        end
      endcase
    end
  end

  // Next state logic
  always_comb begin
    case (current_state)
      IDLE_STATE: 
        next_state = start_transaction ? ACTIVE_STATE : IDLE_STATE;
      ACTIVE_STATE: 
        next_state = (bit_counter == 8) ? COMPLETE_STATE : ACTIVE_STATE;
      COMPLETE_STATE: 
        next_state = IDLE_STATE;
      default: 
        next_state = IDLE_STATE;
    endcase
  end

endmodule