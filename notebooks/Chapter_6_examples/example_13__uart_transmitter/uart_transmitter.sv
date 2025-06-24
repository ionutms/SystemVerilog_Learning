// uart_transmitter.sv - Clean Version with Minimal Debug Output
module uart_transmitter (
    input  logic       clk,
    input  logic       reset,
    input  logic       tx_start,      // Start transmission
    input  logic [7:0] tx_data,       // Data to transmit
    output logic       tx_serial,     // Serial output
    output logic       tx_busy,       // Transmission in progress
    output logic       tx_done        // Transmission complete
);

    // UART frame states
    typedef enum logic [2:0] {
        IDLE       = 3'b000,
        START_BIT  = 3'b001,
        DATA_BITS  = 3'b010,
        STOP_BIT   = 3'b011
    } uart_state_t;

    uart_state_t current_state;
    
    // Internal registers
    logic [7:0] shift_register;    // Data to be transmitted
    logic [2:0] bit_counter;       // Count data bits (0-7)
    logic [3:0] baud_counter;      // Baud rate timing
    
    // Baud rate control (simplified for simulation)
    parameter BAUD_TICKS = 4'd8;   // Clock cycles per bit period
    
    // State register and counters
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            shift_register <= 8'h00;
            bit_counter <= 3'd0;
            baud_counter <= 4'd0;
        end else begin
            // State machine
            case (current_state)
                IDLE: begin
                    baud_counter <= 4'd0;
                    bit_counter <= 3'd0;
                    if (tx_start) begin
                        current_state <= START_BIT;
                        shift_register <= tx_data;
                        $display("Time %0t: Start transmission - Data: 0x%02h", $time, tx_data);
                    end
                end
                
                START_BIT: begin
                    if (baud_counter >= BAUD_TICKS - 1) begin
                        baud_counter <= 4'd0;
                        current_state <= DATA_BITS;
                    end else begin
                        baud_counter <= baud_counter + 1;
                    end
                end
                
                DATA_BITS: begin
                    if (baud_counter >= BAUD_TICKS - 1) begin
                        baud_counter <= 4'd0;
                        shift_register <= {1'b0, shift_register[7:1]};
                        bit_counter <= bit_counter + 1;
                        if (bit_counter >= 3'd7) begin
                            current_state <= STOP_BIT;
                        end
                    end else begin
                        baud_counter <= baud_counter + 1;
                    end
                end
                
                STOP_BIT: begin
                    if (baud_counter >= BAUD_TICKS - 1) begin
                        baud_counter <= 4'd0;
                        current_state <= IDLE;
                        $display("Time %0t: UART transmission complete!", $time);
                    end else begin
                        baud_counter <= baud_counter + 1;
                    end
                end
                
                default: current_state <= IDLE;
            endcase
        end
    end

    // Output logic
    always_comb begin
        case (current_state)
            IDLE:      tx_serial = 1'b1;              // Line idle high
            START_BIT: tx_serial = 1'b0;              // Start bit low
            DATA_BITS: tx_serial = shift_register[0]; // LSB first
            STOP_BIT:  tx_serial = 1'b1;              // Stop bit high
            default:   tx_serial = 1'b1;
        endcase
        
        tx_busy = (current_state != IDLE);
        tx_done = (current_state == STOP_BIT) && (baud_counter >= BAUD_TICKS - 1);
    end

    // Minimal debug output - only show key events
    // Remove or comment out this block for completely silent operation
    /*
    always_ff @(posedge clk) begin
        if (tx_start && current_state == IDLE) begin
            $display("Time %0t: Starting UART frame", $time);
        end
        if (tx_done) begin
            $display("Time %0t: UART frame complete", $time);
        end
    end
    */

endmodule