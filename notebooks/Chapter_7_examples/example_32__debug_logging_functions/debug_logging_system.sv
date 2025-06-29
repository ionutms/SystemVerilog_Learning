// debug_logging_system.sv
module debug_logging_system #(
    parameter DATA_WIDTH = 8,
    parameter ENABLE_DEBUG = 1
)();
    
    // Internal signals for demonstration
    logic [DATA_WIDTH-1:0] processor_data;
    logic                  memory_valid;
    logic                  error_detected;
    logic                  system_ready;
    
    // Debug and logging void functions
    function void log_info(string message);
        $display("[INFO] [%0t] %s", $time, message);
    endfunction
    
    function void log_warning(string message);
        $display("[WARNING] [%0t] %s", $time, message);
    endfunction
    
    function void log_error(string message);
        $display("[ERROR] [%0t] %s", $time, message);
    endfunction
    
    function void debug_print(string debug_message);
        if (ENABLE_DEBUG) begin
            $display("[DEBUG] [%0t] %s", $time, debug_message);
        end
    endfunction
    
    function void dump_system_state();
        $display("========== SYSTEM STATE DUMP ==========");
        $display("Time: %0t", $time);
        $display("Processor Data: 0x%02h (%0d)", processor_data, 
                processor_data);
        $display("Memory Valid: %b", memory_valid);
        $display("Error Detected: %b", error_detected);
        $display("System Ready: %b", system_ready);
        $display("=======================================");
    endfunction
    
    function void trace_signal_change(string signal_name, 
                                     logic old_value, 
                                     logic new_value);
        if (old_value !== new_value) begin
            $display("[TRACE] [%0t] %s: %b -> %b", $time, signal_name, 
                    old_value, new_value);
        end
    endfunction
    
    function void performance_checkpoint(string checkpoint_name);
        $display("[PERF] [%0t] Checkpoint: %s", $time, checkpoint_name);
    endfunction
    
    // Simple system behavior for demonstration
    initial begin
        log_info("Debug logging system initialized");
        
        // Initialize signals
        processor_data = 8'h00;
        memory_valid = 1'b0;
        error_detected = 1'b0;
        system_ready = 1'b0;
        
        debug_print("Initial state configured");
        performance_checkpoint("System startup");
        
        // Simulate system operation
        #10;
        processor_data = 8'hAA;
        memory_valid = 1'b1;
        debug_print("Memory interface activated");
        
        #5;
        system_ready = 1'b1;
        log_info("System ready for operation");
        dump_system_state();
        
        #15;
        error_detected = 1'b1;
        log_error("Memory corruption detected!");
        trace_signal_change("error_detected", 1'b0, 1'b1);
        
        #10;
        log_warning("Attempting error recovery");
        error_detected = 1'b0;
        processor_data = 8'h55;
        debug_print("Error recovery sequence completed");
        
        performance_checkpoint("Error recovery completed");
        dump_system_state();
        
        log_info("Debug logging system test completed");
    end
    
endmodule