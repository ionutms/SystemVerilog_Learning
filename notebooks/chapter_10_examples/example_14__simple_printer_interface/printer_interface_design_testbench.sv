// printer_interface_design_testbench.sv
module printer_interface_testbench;
  import printer_interface_pkg::*;
  
  // Instantiate design under test
  printer_interface_design_module DUT();
  
  // Test variables
  LaserPrinter laser_printer;
  InkjetPrinter inkjet_printer;
  BasePrinter printer_array[2];
  
  initial begin
    // Configure VCD dumping
    $dumpfile("printer_interface_testbench.vcd");
    $dumpvars(0, printer_interface_testbench);
    
    $display("\n=== Printer Interface Testbench ===");
    $display("Testing inheritance and polymorphism with printers");
    
    // Create printer instances
    laser_printer = new("HP LaserJet Pro", 75);
    inkjet_printer = new("Canon PIXMA", 60);
    
    $display("\n--- Individual Printer Testing ---");
    
    // Test laser printer
    $display("\n1. Testing Laser Printer:");
    laser_printer.display_status();
    laser_printer.print("Business Report");
    laser_printer.print("Invoice #12345");
    
    // Test inkjet printer
    $display("\n2. Testing Inkjet Printer:");
    inkjet_printer.display_status();
    inkjet_printer.print("Family Photo");
    inkjet_printer.print("Color Brochure");
    
    $display("\n--- Polymorphism Demonstration ---");
    
    // Demonstrate polymorphism using base class handles
    printer_array[0] = laser_printer;
    printer_array[1] = inkjet_printer;
    
    $display("\n3. Polymorphic printing:");
    for (int i = 0; i < 2; i++) begin
      $display("\nPrinter %0d:", i+1);
      printer_array[i].display_status();
      printer_array[i].print($sformatf("Document_%0d", i+1));
    end
    
    $display("\n--- Resource Management Testing ---");
    
    // Test resource depletion and refill
    $display("\n4. Testing resource management:");
    
    // Deplete laser printer toner
    repeat(15) begin
      laser_printer.print("Test Page");
    end
    
    // Refill toner
    laser_printer.replace_toner();
    laser_printer.print("After Toner Replacement");
    
    // Deplete inkjet printer ink
    repeat(6) begin
      inkjet_printer.print("Test Image");
    end
    
    // Refill ink
    inkjet_printer.refill_ink();
    inkjet_printer.print("After Ink Refill");
    
    $display("\n--- Final Status Check ---");
    $display("\n5. Final printer status:");
    laser_printer.display_status();
    inkjet_printer.display_status();
    
    #10;
    $display("\n=== Printer Interface Test Complete ===");
    $finish;
  end
  
endmodule