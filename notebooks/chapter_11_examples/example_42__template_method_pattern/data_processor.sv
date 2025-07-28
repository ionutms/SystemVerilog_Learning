// data_processor.sv - Template Method Pattern Example
package data_processor_pkg;

  // Base class with template method
  virtual class base_data_processor;
    string processor_name;
    
    function new(string name);
      this.processor_name = name;
    endfunction
    
    // Template method - defines the algorithm skeleton
    virtual task process_data(int data_array[5]);
      $display("[%s] Starting data processing...", processor_name);
      validate_input(data_array);
      transform_data(data_array);
      store_results(data_array);
      $display("[%s] Data processing completed.", processor_name);
    endtask
    
    // Concrete method - same for all implementations
    virtual function void validate_input(int data_array[5]);
      $display("[%s] Validating input data (size: %0d)", 
               processor_name, $size(data_array));
      if ($size(data_array) == 0) begin
        $error("[%s] Input data is empty!", processor_name);
      end
    endfunction
    
    // Abstract methods - must be implemented by derived classes
    pure virtual function void transform_data(ref int data_array[5]);
    pure virtual function void store_results(int data_array[5]);
  endclass

  // Concrete implementation 1 - Doubles each value
  class doubler_processor extends base_data_processor;
    
    function new();
      super.new("DOUBLER");
    endfunction
    
    virtual function void transform_data(ref int data_array[5]);
      $display("[%s] Transforming: doubling each value", processor_name);
      foreach (data_array[i]) begin
        data_array[i] = data_array[i] * 2;
      end
    endfunction
    
    virtual function void store_results(int data_array[5]);
      $write("[%s] Storing results: ", processor_name);
      foreach (data_array[i]) begin
        $write("%0d ", data_array[i]);
      end
      $display("");
    endfunction
  endclass

  // Concrete implementation 2 - Squares each value
  class squarer_processor extends base_data_processor;
    
    function new();
      super.new("SQUARER");
    endfunction
    
    virtual function void transform_data(ref int data_array[5]);
      $display("[%s] Transforming: squaring each value", processor_name);
      foreach (data_array[i]) begin
        data_array[i] = data_array[i] ** 2;
      end
    endfunction
    
    virtual function void store_results(int data_array[5]);
      $write("[%s] Storing results: ", processor_name);
      foreach (data_array[i]) begin
        $write("%0d ", data_array[i]);
      end
      $display("");
    endfunction
  endclass

  // Concrete implementation 3 - Adds 10 to each value
  class adder_processor extends base_data_processor;
    
    function new();
      super.new("ADDER");
    endfunction
    
    virtual function void transform_data(ref int data_array[5]);
      $display("[%s] Transforming: adding 10 to each value", 
               processor_name);
      foreach (data_array[i]) begin
        data_array[i] = data_array[i] + 10;
      end
    endfunction
    
    virtual function void store_results(int data_array[5]);
      $write("[%s] Storing results: ", processor_name);
      foreach (data_array[i]) begin
        $write("%0d ", data_array[i]);
      end
      $display("");
    endfunction
  endclass

endpackage

module data_processor_module;
  import data_processor_pkg::*;
  
  initial begin
    $display("Template Method Pattern - Data Processor Example");
    $display("================================================");
  end

endmodule