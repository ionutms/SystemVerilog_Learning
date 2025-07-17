// simple_car.sv
module simple_car(
    input  logic        clk,
    input  logic        rst_n,
    output logic        car_started
);
    
    // Car properties
    logic engine_started;
    logic [3:0] gear;

    // Engine instance
    engine i_engine(
        .clk(clk),
        .rst_n(rst_n),
        .start_engine(engine_started)
    );

    // Car control logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            engine_started <= 1'b0;
            gear <= 4'b0000;
        end else begin
            // Start engine when gear is in neutral
            if (gear == 4'b0000) begin
                engine_started <= 1'b1;
            end
            // Shift gears when engine is running
            else if (engine_started) begin
                gear <= gear + 1'b1;
            end
        end
    end

    // Output assignment
    assign car_started = engine_started;

endmodule

module engine(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        start_engine
);
    
    // Engine properties
    logic engine_running;

    // Engine control logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            engine_running <= 1'b0;
        end else begin
            // Start engine when start signal is high
            if (start_engine) begin
                engine_running <= 1'b1;
            end
        end
    end

endmodule