// data_bus_latch.sv - Fixed version without circular logic
module data_bus_latch (
    input  logic        clk,
    input  logic        rst_n,
    
    // Control signals
    input  logic        latch_enable,      // Enable latch operation
    input  logic        cpu_to_bus_dir,    // Direction: 1=CPU->Bus, 0=Bus->CPU
    input  logic        bus_output_enable, // Enable bus output drivers
    
    // CPU side interface
    inout  logic [7:0]  cpu_data,          // Bidirectional CPU data bus
    
    // External bus interface  
    inout  logic [7:0]  ext_bus_data,      // Bidirectional external data bus
    
    // Status outputs
    output logic        latch_active,      // Latch is currently active
    output logic        bus_isolated       // Bus is isolated (high-Z)
);

    // Internal latched data storage
    logic [7:0] cpu_to_bus_latch;    // Latch for CPU->Bus direction
    logic [7:0] bus_to_cpu_latch;    // Latch for Bus->CPU direction
    
    // Previous latch enable states for edge detection
    logic prev_latch_enable;
    logic prev_cpu_to_bus_dir;
    
    // Control signals for driving the buses
    logic drive_cpu_bus;
    logic drive_ext_bus;
    
    // Update previous states on clock edge
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev_latch_enable <= 1'b0;
            prev_cpu_to_bus_dir <= 1'b0;
        end else begin
            prev_latch_enable <= latch_enable;
            prev_cpu_to_bus_dir <= cpu_to_bus_dir;
        end
    end
    
    // Latch data on the rising edge of latch_enable
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cpu_to_bus_latch <= 8'h00;
            bus_to_cpu_latch <= 8'h00;
        end else begin
            // Latch on rising edge of latch_enable
            if (latch_enable && !prev_latch_enable) begin
                if (cpu_to_bus_dir) begin
                    // CPU->Bus: latch CPU data
                    cpu_to_bus_latch <= cpu_data;
                    $display(
                        "Time %0t: Data Bus Latch - CPU->Bus direction, latching CPU data: 0x%02h", 
                        $time, cpu_data);
                end else begin
                    // Bus->CPU: latch external bus data
                    bus_to_cpu_latch <= ext_bus_data;
                    $display(
                        "Time %0t: Data Bus Latch - Bus->CPU direction, latching Bus data: 0x%02h", 
                        $time, ext_bus_data);
                end
            end
        end
    end
    
    // Drive control logic - only drive when latch is active and output is enabled
    assign drive_ext_bus = latch_enable && cpu_to_bus_dir && bus_output_enable;
    assign drive_cpu_bus = latch_enable && !cpu_to_bus_dir && bus_output_enable;
    
    // Bidirectional bus control
    assign cpu_data = drive_cpu_bus ? bus_to_cpu_latch : 8'bz;
    assign ext_bus_data = drive_ext_bus ? cpu_to_bus_latch : 8'bz;
    
    // Status signals
    assign latch_active = latch_enable;
    assign bus_isolated = !bus_output_enable;
    
    // Debug output for bus driving
    always @(posedge bus_output_enable) begin
        if (latch_enable) begin
            if (cpu_to_bus_dir) begin
                $display(
                    "Time %0t: Data Bus Latch - Driving ext_bus with latched data: 0x%02h", 
                    $time, cpu_to_bus_latch);
            end else begin
                $display(
                    "Time %0t: Data Bus Latch - Driving cpu_data with latched data: 0x%02h", 
                    $time, bus_to_cpu_latch);
            end
        end
    end
    
    always @(negedge bus_output_enable) begin
        $display(
            "Time %0t: Data Bus Latch - Output disabled, buses isolated",
            $time);
    end
    
    initial $display(
        "Data Bus Latch initialized - Bidirectional data isolation and timing control");

endmodule