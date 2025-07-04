// printer_interface_design.sv
package printer_interface_pkg;

  // Base printer class with pure virtual print method
  virtual class BasePrinter;
    string printer_name;
    
    function new(string name);
      this.printer_name = name;
    endfunction
    
    // Pure virtual method - must be implemented by derived classes
    pure virtual function void print(string document);
    
    // Common method for all printers
    function void display_status();
      $display("[%s] Printer is ready", printer_name);
    endfunction
  endclass

  // Laser printer implementation
  class LaserPrinter extends BasePrinter;
    int toner_level;
    
    function new(string name, int initial_toner = 100);
      super.new(name);
      this.toner_level = initial_toner;
    endfunction
    
    // Implementation of pure virtual method
    virtual function void print(string document);
      if (toner_level > 0) begin
        $display("[%s] Laser printing: '%s'", printer_name, document);
        $display("[%s] Using laser technology for crisp text", printer_name);
        toner_level -= 5;
        $display("[%s] Toner level: %0d%%", printer_name, toner_level);
      end else begin
        $display("[%s] ERROR: Toner empty!", printer_name);
      end
    endfunction
    
    function void replace_toner();
      toner_level = 100;
      $display("[%s] Toner cartridge replaced", printer_name);
    endfunction
  endclass

  // Inkjet printer implementation
  class InkjetPrinter extends BasePrinter;
    int ink_level;
    
    function new(string name, int initial_ink = 80);
      super.new(name);
      this.ink_level = initial_ink;
    endfunction
    
    // Implementation of pure virtual method
    virtual function void print(string document);
      if (ink_level > 0) begin
        $display("[%s] Inkjet printing: '%s'", printer_name, document);
        $display("[%s] Using liquid ink for vibrant colors", printer_name);
        ink_level -= 10;
        $display("[%s] Ink level: %0d%%", printer_name, ink_level);
      end else begin
        $display("[%s] ERROR: Ink cartridge empty!", printer_name);
      end
    endfunction
    
    function void refill_ink();
      ink_level = 80;
      $display("[%s] Ink cartridge refilled", printer_name);
    endfunction
  endclass

endpackage

module printer_interface_design_module;
  // This module serves as the design under test container
  // The actual functionality is in the package classes
  
  initial begin
    $display("=== Printer Interface Design Module ===");
    $display("Classes defined in printer_interface_pkg package");
    $display("Ready for testbench instantiation");
  end
  
endmodule