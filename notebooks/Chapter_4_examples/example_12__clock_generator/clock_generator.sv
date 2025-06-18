// clock_generator.sv
module clock_generator ();               // Clock generator design under test
    logic clk;
    
    initial begin
        $display("Clock Generator: Initializing clock signal...");
        clk = 0;
        
        $display("Clock Generator: Starting 100 clock cycles...");
        repeat (100) begin
            #5 clk = ~clk;
            #5 clk = ~clk;
        end
        
        $display("Clock Generator: Generated 100 clock cycles");
        $display("Clock Generator: Simulation completed.");
        $finish;
    end
endmodule