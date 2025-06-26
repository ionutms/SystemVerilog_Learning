// parameterized_delay_line.sv
module configurable_delay_line #(
    parameter DELAY_STAGES = 4,      // Number of delay stages
    parameter DATA_WIDTH = 8         // Width of data bus
)(
    input  logic                    clock_signal,
    input  logic                    reset_signal,
    input  logic [DATA_WIDTH-1:0]   data_input,
    output logic [DATA_WIDTH-1:0]   delayed_data_output
);

    // Internal delay stage signals
    logic [DATA_WIDTH-1:0] delay_stage_outputs [DELAY_STAGES:0];
    
    // Connect input to first stage
    assign delay_stage_outputs[0] = data_input;
    
    // Generate delay stages using generate block
    genvar stage_index;
    generate
        for (stage_index = 0; stage_index < DELAY_STAGES; stage_index++) begin : delay_stage_generation
            // Each delay stage is a simple D flip-flop
            always_ff @(posedge clock_signal or posedge reset_signal) begin
                if (reset_signal) begin
                    delay_stage_outputs[stage_index + 1] <= '0;
                end else begin
                    delay_stage_outputs[stage_index + 1] <= delay_stage_outputs[stage_index];
                end
            end
        end
    endgenerate
    
    // Connect final stage to output
    assign delayed_data_output = delay_stage_outputs[DELAY_STAGES];
    
    // Display information about the generated delay line
    initial begin
        $display("Parameterized Delay Line Configuration:");
        $display("  - Delay Stages: %0d", DELAY_STAGES);
        $display("  - Data Width: %0d bits", DATA_WIDTH);
        $display("  - Total Delay: %0d clock cycles", DELAY_STAGES);
        $display();
    end

endmodule