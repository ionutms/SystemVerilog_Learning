// array_port_module.sv - Fixed version with proper bit widths
module array_port_module #(
    parameter int DATA_WIDTH = 8,               // Width of each data element
    parameter int NUM_CHANNELS = 4              // Number of parallel channels
) (
    // Clock and reset
    input  logic                            clk,
    input  logic                            reset_n,
    input  logic                            enable,
    
    // Unpacked array input ports - multiple data channels
    input  logic [DATA_WIDTH-1:0]          data_in [NUM_CHANNELS],     // Array of input data
    input  logic                            valid_in [NUM_CHANNELS],    // Array of valid signals
    
    // Unpacked array output ports
    output logic [DATA_WIDTH-1:0]          data_out [NUM_CHANNELS],    // Array of output data
    output logic                            valid_out [NUM_CHANNELS],   // Array of valid outputs
    
    // Status arrays
    output logic [7:0]                      channel_count [NUM_CHANNELS],   // Per-channel counters
    output logic [DATA_WIDTH-1:0]          channel_max [NUM_CHANNELS],     // Maximum value per channel
    output logic [DATA_WIDTH-1:0]          channel_min [NUM_CHANNELS]      // Minimum value per channel
);

    // Generate block for per-channel processing
    generate
        genvar ch;
        for (ch = 0; ch < NUM_CHANNELS; ch++) begin : channel_proc
            
            // Per-channel registers
            logic [DATA_WIDTH-1:0] data_reg;
            logic                   valid_reg;
            logic [7:0]            counter;
            logic [DATA_WIDTH-1:0] max_val;
            logic [DATA_WIDTH-1:0] min_val;
            
            // Per-channel processing logic
            always_ff @(posedge clk or negedge reset_n) begin
                if (!reset_n) begin
                    data_reg <= '0;
                    valid_reg <= 1'b0;
                    counter <= '0;
                    max_val <= '0;
                    min_val <= '1; // All 1s for minimum initialization
                end else if (enable) begin
                    // Process input data
                    data_reg <= data_in[ch];
                    valid_reg <= valid_in[ch];
                    
                    // Update statistics when valid data arrives
                    if (valid_in[ch]) begin
                        counter <= counter + 1'b1;
                        
                        // Track max/min values
                        if (data_in[ch] > max_val) begin
                            max_val <= data_in[ch];
                        end
                        if (data_in[ch] < min_val) begin
                            min_val <= data_in[ch];
                        end
                    end
                end
            end
            
            // Connect internal registers to output arrays
            assign data_out[ch] = data_reg;
            assign valid_out[ch] = valid_reg;
            assign channel_count[ch] = counter;
            assign channel_max[ch] = max_val;
            assign channel_min[ch] = min_val;
        end
    endgenerate
    
    // Cross-channel operations using array manipulation
    logic [DATA_WIDTH-1:0] sum_all_channels;
    logic [$clog2(NUM_CHANNELS+1)-1:0] active_channels;
    
    // Calculate sum and count of active channels
    always_comb begin
        sum_all_channels = '0;
        active_channels = '0;
        
        for (int i = 0; i < NUM_CHANNELS; i++) begin
            if (valid_out[i]) begin
                sum_all_channels += data_out[i];
                active_channels++;
            end
        end
    end
    
    // Simple array comparison example - fixed width truncation
    logic [DATA_WIDTH-1:0] highest_value;
    logic [$clog2(NUM_CHANNELS)-1:0] highest_channel;
    
    always_comb begin
        highest_value = '0;
        highest_channel = '0;
        
        for (int i = 0; i < NUM_CHANNELS; i++) begin
            if (valid_out[i] && (data_out[i] > highest_value)) begin
                highest_value = data_out[i];
                highest_channel = i[$clog2(NUM_CHANNELS)-1:0]; // Fixed: proper width conversion
            end
        end
    end
    
    // Parameter validation and info display
    initial begin
        assert (NUM_CHANNELS > 0 && NUM_CHANNELS <= 16) 
            else $error("NUM_CHANNELS must be between 1 and 16");
        assert (DATA_WIDTH > 0 && DATA_WIDTH <= 16) 
            else $error("DATA_WIDTH must be between 1 and 16");
        
        $display("Simple Array Port Module Initialized:");
        $display("  DATA_WIDTH = %0d bits", DATA_WIDTH);
        $display("  NUM_CHANNELS = %0d", NUM_CHANNELS);
    end

endmodule