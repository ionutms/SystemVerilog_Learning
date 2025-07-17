// simple_car_tb.sv
module simple_car_tb;
    
    // Testbench properties
    logic clk;
    logic rst_n;
    logic car_started;

    // Instantiate the car module
    simple_car i_car(
        .clk(clk),
        .rst_n(rst_n),
        .car_started(car_started)
    );

    // Testbench control logic
    initial begin
        $dumpfile("simple_car_tb.vcd");
        $dumpvars(0, simple_car_tb);
        
        // Initialize signals
        clk = 1'b0;
        rst_n = 1'b0;
        #10;
        rst_n = 1'b1;
        
        // Start the car
        $display("=== Simple Car Testbench Started ===");
        $display("Time %0t: Starting the car...", $time);
        #10;
        
        // Check if the car started
        $display("Time %0t: Checking if the car started...", $time);
        if (car_started) begin
            $display("Car started successfully!");
        end else begin
            $display("Failed to start the car!");
        end
        
        // Stop the simulation
        $finish;
    end

    // Clock generation
    always #5 clk = ~clk;

endmodule