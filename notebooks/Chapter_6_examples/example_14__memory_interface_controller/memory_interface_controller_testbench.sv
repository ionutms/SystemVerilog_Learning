// memory_interface_controller_testbench.sv
module memory_controller_testbench;

    // Clock and reset
    logic clk;
    logic rst_n;
    
    // CPU Interface signals
    logic        cpu_req;
    logic        cpu_wr_en;
    logic [7:0]  cpu_addr;
    logic [15:0] cpu_wr_data;
    logic [15:0] cpu_rd_data;
    logic        cpu_ready;
    
    // Memory Interface signals
    logic        mem_req;
    logic        mem_wr_en;
    logic [7:0]  mem_addr;
    logic [15:0] mem_wr_data;
    logic [15:0] mem_rd_data;
    logic        mem_ready;
    
    // Simple memory model
    logic [15:0] memory_array [0:255];
    
    // Instantiate the memory interface controller
    memory_interface_controller MEMORY_CONTROLLER_INST (
        .clk(clk),
        .rst_n(rst_n),
        .cpu_req(cpu_req),
        .cpu_wr_en(cpu_wr_en),
        .cpu_addr(cpu_addr),
        .cpu_wr_data(cpu_wr_data),
        .cpu_rd_data(cpu_rd_data),
        .cpu_ready(cpu_ready),
        .mem_req(mem_req),
        .mem_wr_en(mem_wr_en),
        .mem_addr(mem_addr),
        .mem_wr_data(mem_wr_data),
        .mem_rd_data(mem_rd_data),
        .mem_ready(mem_ready)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end
    
    // Simple memory model behavior
    always_ff @(posedge clk) begin
        if (mem_req) begin
            if (mem_wr_en) begin
                // Write operation
                memory_array[mem_addr] <= mem_wr_data;
                $display("Time %0t: Memory WRITE - Addr: 0x%02h, Data: 0x%04h", 
                         $time, mem_addr, mem_wr_data);
            end else begin
                // Read operation
                $display("Time %0t: Memory READ  - Addr: 0x%02h, Data: 0x%04h", 
                         $time, mem_addr, memory_array[mem_addr]);
            end
        end
    end
    
    // Memory ready signal (simulate memory delay)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mem_ready <= 1'b0;
        end else begin
            mem_ready <= mem_req;  // Ready one cycle after request
        end
    end
    
    // Memory read data
    assign mem_rd_data = memory_array[mem_addr];
    
    // Test sequence
    initial begin
        // Initialize
        rst_n = 0;
        cpu_req = 0;
        cpu_wr_en = 0;
        cpu_addr = 0;
        cpu_wr_data = 0;
        
        // Initialize memory with some values
        memory_array[8'h10] = 16'hABCD;
        memory_array[8'h20] = 16'h1234;
        memory_array[8'h30] = 16'h5678;
        
        // Dump waves
        $dumpfile("memory_controller_testbench.vcd");
        $dumpvars(0, memory_controller_testbench);
        
        $display();
        $display("=== Memory Interface Controller Test ===");
        $display();
        
        // Release reset
        #20 rst_n = 1;
        #10;
        
        // Test 1: Write operation
        $display("Test 1: Write 0xDEAD to address 0x10");
        wait(cpu_ready);
        cpu_req = 1;
        cpu_wr_en = 1;
        cpu_addr = 8'h10;
        cpu_wr_data = 16'hDEAD;
        #10;
        cpu_req = 0;
        wait(cpu_ready);
        #20;
        
        // Test 2: Read operation
        $display("Test 2: Read from address 0x10");
        wait(cpu_ready);
        cpu_req = 1;
        cpu_wr_en = 0;
        cpu_addr = 8'h10;
        #10;
        cpu_req = 0;
        wait(cpu_ready);
        $display("Read data: 0x%04h", cpu_rd_data);
        #20;
        
        // Test 3: Write to different address
        $display("Test 3: Write 0xBEEF to address 0x20");
        wait(cpu_ready);
        cpu_req = 1;
        cpu_wr_en = 1;
        cpu_addr = 8'h20;
        cpu_wr_data = 16'hBEEF;
        #10;
        cpu_req = 0;
        wait(cpu_ready);
        #20;
        
        // Test 4: Read from different address
        $display("Test 4: Read from address 0x20");
        wait(cpu_ready);
        cpu_req = 1;
        cpu_wr_en = 0;
        cpu_addr = 8'h20;
        #10;
        cpu_req = 0;
        wait(cpu_ready);
        $display("Read data: 0x%04h", cpu_rd_data);
        #20;
        
        // Test 5: Multiple operations
        $display("Test 5: Multiple operations");
        for (int i = 0; i < 3; i++) begin
            // Write
            wait(cpu_ready);
            cpu_req = 1;
            cpu_wr_en = 1;
            cpu_addr = 8'h30 + 8'(i);
            cpu_wr_data = 16'h1000 + 16'(i);
            #10;
            cpu_req = 0;
            wait(cpu_ready);
            
            // Read back
            wait(cpu_ready);
            cpu_req = 1;
            cpu_wr_en = 0;
            cpu_addr = 8'h30 + 8'(i);
            #10;
            cpu_req = 0;
            wait(cpu_ready);
            $display("Address 0x%02h: Written 0x%04h, Read 0x%04h", 
                     8'h30 + 8'(i), 16'h1000 + 16'(i), cpu_rd_data);
            #10;
        end
        
        $display();
        $display("=== All tests completed ===");
        $display();
        
        #50 $finish;
    end

endmodule