// parameter_override_testbench.sv
module parameter_override_testbench;

    // Clock and control signals
    logic clk;
    logic reset_n;
    logic enable;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // === COUNTER EXAMPLES ===
    
    // Counter signals
    logic [3:0]  count4;    // 4-bit counter
    logic [7:0]  count8;    // 8-bit counter  
    logic [15:0] count16;   // 16-bit counter
    logic        overflow4, overflow8, overflow16;
    logic        underflow4, underflow8, underflow16;
    
    // Counter 1: Default parameters (8-bit, count to 255, step 1, up)
    simple_counter counter_default (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .count(count8),
        .overflow(overflow8),
        .underflow(underflow8)
    );
    
    // Counter 2: Override WIDTH to 4-bit, MAX_COUNT to 10
    simple_counter #(
        .WIDTH(4),
        .MAX_COUNT(10)
    ) counter_4bit (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .count(count4),
        .overflow(overflow4),
        .underflow(underflow4)
    );
    
    // Counter 3: 16-bit down counter with step 2, starting from 100
    simple_counter #(
        .WIDTH(16),
        .MAX_COUNT(100),
        .STEP(2),
        .UP_DOWN(1'b0),        // Count down
        .RESET_VALUE(16'd100)  // Start at 100
    ) counter_16bit_down (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .count(count16),
        .overflow(overflow16),
        .underflow(underflow16)
    );
    
    // === RAM EXAMPLES ===
    
    // RAM signals
    logic        we8, we16, we32;
    logic [3:0]  addr8;
    logic [2:0]  addr16;
    logic [1:0]  addr32;
    logic [7:0]  din8, dout8;
    logic [15:0] din16, dout16;
    logic [31:0] din32, dout32;
    
    // RAM 1: Default 8-bit x 16 words
    simple_ram ram_default (
        .clk(clk),
        .we(we8),
        .addr(addr8),
        .din(din8),
        .dout(dout8)
    );
    
    // RAM 2: 16-bit x 8 words, initialized with 0xAAAA
    simple_ram #(
        .DATA_WIDTH(16),
        .ADDR_WIDTH(3),
        .DEPTH(8),
        .INIT_VALUE(16'hAAAA)
    ) ram_16bit (
        .clk(clk),
        .we(we16),
        .addr(addr16),
        .din(din16),
        .dout(dout16)
    );
    
    // RAM 3: 32-bit x 4 words, initialized with 0xDEADBEEF
    simple_ram #(
        .DATA_WIDTH(32),
        .ADDR_WIDTH(2),
        .DEPTH(4),
        .INIT_VALUE(32'hDEADBEEF)
    ) ram_32bit (
        .clk(clk),
        .we(we32),
        .addr(addr32),
        .din(din32),
        .dout(dout32)
    );
    
    // === ALU EXAMPLES ===
    
    // ALU signals
    logic [7:0]  alu_a8, alu_b8, alu_result8;
    logic [15:0] alu_a16, alu_b16, alu_result16;
    logic [3:0]  alu_a4, alu_b4, alu_result4;
    logic [2:0]  alu_op;
    logic        alu_valid8, alu_valid16, alu_valid4;
    
    // ALU 1: Default 8-bit, no multiply/divide
    simple_alu alu_basic (
        .a(alu_a8),
        .b(alu_b8),
        .op(alu_op),
        .result(alu_result8),
        .valid(alu_valid8)
    );
    
    // ALU 2: 16-bit with multiply enabled, 2.5ns delay
    simple_alu #(
        .WIDTH(16),
        .ENABLE_MULT(1'b1),
        .DELAY_NS(2.5)
    ) alu_16bit_mult (
        .a(alu_a16),
        .b(alu_b16),
        .op(alu_op),
        .result(alu_result16),
        .valid(alu_valid16)
    );
    
    // ALU 3: 4-bit with both multiply and divide enabled
    simple_alu #(
        .WIDTH(4),
        .ENABLE_MULT(1'b1),
        .ENABLE_DIV(1'b1),
        .DELAY_NS(0.0)  // No delay
    ) alu_4bit_full (
        .a(alu_a4),
        .b(alu_b4),
        .op(alu_op),
        .result(alu_result4),
        .valid(alu_valid4)
    );
    
    // Test stimulus
    initial begin
        // Initialize VCD dump
        $dumpfile("parameter_override_testbench.vcd");
        $dumpvars(0, parameter_override_testbench);
        
        $display("\n=== Parameter Override Testbench Started ===");
        $display("This example demonstrates parameter override during instantiation\n");
        
        // Initialize signals
        reset_n = 0;
        enable = 0;
        we8 = 0; we16 = 0; we32 = 0;
        addr8 = 0; addr16 = 0; addr32 = 0;
        din8 = 0; din16 = 0; din32 = 0;
        alu_a8 = 0; alu_b8 = 0;
        alu_a16 = 0; alu_b16 = 0;
        alu_a4 = 0; alu_b4 = 0;
        alu_op = 0;
        
        // Reset phase
        $display("--- Reset Phase ---");
        #20;
        reset_n = 1;
        #10;
        
        // Test counters
        $display("\n--- Counter Test ---");
        enable = 1;
        
        $display("Watching counters for 15 clock cycles:");
        $display("Time | 8bit | 4bit | 16bit | Overflows");
        $display("-----|------|------|-------|----------");
        
        for (int i = 0; i < 15; i++) begin
            @(posedge clk);
            $display("%4t | %3d  | %2d   | %5d | %b%b%b", 
                    $time, count8, count4, count16, 
                    overflow8, overflow4, underflow16);
        end
        
        enable = 0;
        
        // Test RAM
        $display("\n--- RAM Test ---");
        
        // Write to all RAMs
        $display("Writing test data to RAMs...");
        for (int i = 0; i < 4; i++) begin
            // Write to 8-bit RAM
            if (i < 16) begin
                @(posedge clk);
                we8 = 1;
                addr8 = 4'(i);
                din8 = 8'h10 + 8'(i);
            end
            
            // Write to 16-bit RAM  
            if (i < 8) begin
                @(posedge clk);
                we16 = 1;
                addr16 = 3'(i);
                din16 = 16'h2000 + 16'(i);
            end
            
            // Write to 32-bit RAM
            @(posedge clk);
            we32 = 1;
            addr32 = 2'(i);
            din32 = 32'h30000000 + 32'(i);
        end
        
        we8 = 0; we16 = 0; we32 = 0;
        #10;
        
        // Read back from RAMs
        $display("\nReading back from RAMs:");
        $display("Addr | 8-bit | 16-bit | 32-bit");
        $display("-----|-------|--------|--------");
        
        for (int i = 0; i < 4; i++) begin
            addr8 = 4'(i);
            addr16 = 3'(i);
            addr32 = 2'(i);
            @(posedge clk);
            #1; // Small delay for output to settle
            $display("  %0d  | 0x%02h  | 0x%04h | 0x%08h", 
                    i, dout8, dout16, dout32);
        end
        
        // Test ALUs
        $display("\n--- ALU Test ---");
        
        // Test basic operations
        alu_a8 = 15; alu_b8 = 10;
        alu_a16 = 1000; alu_b16 = 250;  
        alu_a4 = 7; alu_b4 = 3;
        
        $display("Testing ALU operations:");
        $display("8-bit: a=%0d, b=%0d", alu_a8, alu_b8);
        $display("16-bit: a=%0d, b=%0d", alu_a16, alu_b16);
        $display("4-bit: a=%0d, b=%0d", alu_a4, alu_b4);
        $display("");
        $display("Op | 8-bit | 16-bit | 4-bit | Valid(8/16/4)");
        $display("---|-------|--------|-------|-------------");
        
        for (int op = 0; op < 8; op++) begin
            alu_op = 3'(op);
            #10; // Wait for results (including delays)
            
            case (op)
                0: $display("ADD| %3d   | %4d   | %2d    | %b/%b/%b", 
                          alu_result8, alu_result16, alu_result4,
                          alu_valid8, alu_valid16, alu_valid4);
                1: $display("SUB| %3d   | %4d   | %2d    | %b/%b/%b", 
                          alu_result8, alu_result16, alu_result4,
                          alu_valid8, alu_valid16, alu_valid4);
                2: $display("AND| %3d   | %4d   | %2d    | %b/%b/%b", 
                          alu_result8, alu_result16, alu_result4,
                          alu_valid8, alu_valid16, alu_valid4);
                3: $display("OR | %3d   | %4d   | %2d    | %b/%b/%b", 
                          alu_result8, alu_result16, alu_result4,
                          alu_valid8, alu_valid16, alu_valid4);
                4: $display("XOR| %3d   | %4d   | %2d    | %b/%b/%b", 
                          alu_result8, alu_result16, alu_result4,
                          alu_valid8, alu_valid16, alu_valid4);
                5: $display("MUL| %3d   | %4d   | %2d    | %b/%b/%b", 
                          alu_result8, alu_result16, alu_result4,
                          alu_valid8, alu_valid16, alu_valid4);
                6: $display("DIV| %3d   | %4d   | %2d    | %b/%b/%b", 
                          alu_result8, alu_result16, alu_result4,
                          alu_valid8, alu_valid16, alu_valid4);
                7: $display("???| %3d   | %4d   | %2d    | %b/%b/%b", 
                          alu_result8, alu_result16, alu_result4,
                          alu_valid8, alu_valid16, alu_valid4);
            endcase
        end
        
        // Test parameter validation
        $display("\n--- Parameter Summary ---");
        $display("This testbench demonstrated:");
        $display("1. Counter with different widths and behaviors");
        $display("2. RAM with different sizes and initialization");
        $display("3. ALU with different capabilities and timing");
        $display("");
        $display("Key parameter overrides used:");
        $display("- Counter: WIDTH, MAX_COUNT, STEP, UP_DOWN, RESET_VALUE");
        $display("- RAM: DATA_WIDTH, ADDR_WIDTH, DEPTH, INIT_VALUE");
        $display("- ALU: WIDTH, ENABLE_MULT, ENABLE_DIV, DELAY_NS");
        
        $display("\n=== Parameter Override Testbench Completed ===");
        $finish;
    end

endmodule