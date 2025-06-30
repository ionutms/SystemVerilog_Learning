// register_overlay_design.sv
module register_overlay_processor ();

  // Packed union to overlay different views of 32-bit data
  typedef union packed {
    logic [31:0] word_view;           // Full 32-bit word
    logic [3:0][7:0] byte_view;       // 4 bytes (MSB to LSB)
    logic [31:0] bit_view;            // Individual bits
    struct packed {
      logic [15:0] upper_half;        // Upper 16 bits
      logic [15:0] lower_half;        // Lower 16 bits  
    } half_word_view;
  } data_overlay_t;

  data_overlay_t control_register;
  data_overlay_t status_register;

  initial begin
    $display();
    $display("=== Register Overlay Demonstration ===");
    
    // Initialize control register with word view
    control_register.word_view = 32'hDEADBEEF;
    
    $display("Control Register Word: 0x%08X", 
             control_register.word_view);
    $display("  Byte[3]: 0x%02X", control_register.byte_view[3]);
    $display("  Byte[2]: 0x%02X", control_register.byte_view[2]); 
    $display("  Byte[1]: 0x%02X", control_register.byte_view[1]);
    $display("  Byte[0]: 0x%02X", control_register.byte_view[0]);
    $display("  Upper Half: 0x%04X", 
             control_register.half_word_view.upper_half);
    $display("  Lower Half: 0x%04X", 
             control_register.half_word_view.lower_half);
    
    // Modify individual bytes and observe word change
    status_register.byte_view[3] = 8'hAB;
    status_register.byte_view[2] = 8'hCD;
    status_register.byte_view[1] = 8'hEF;
    status_register.byte_view[0] = 8'h12;
    
    $display();
    $display("Status Register built from bytes:");
    $display("  Resulting Word: 0x%08X", status_register.word_view);
    
    // Modify half-words
    status_register.half_word_view.upper_half = 16'h5555;
    status_register.half_word_view.lower_half = 16'hAAAA;
    
    $display("  After half-word modification: 0x%08X", 
             status_register.word_view);
    $display();
  end

endmodule