// sorting_strategy_pattern.sv
package sorting_strategy_pkg;

  // Strategy interface - defines common interface for all sorting strategies
  virtual class SortStrategy;
    pure virtual function void sort(ref int data[]);
    pure virtual function string get_name();
  endclass

  // Concrete strategy 1: Bubble Sort
  class BubbleSortStrategy extends SortStrategy;
    
    virtual function void sort(ref int data[]);
      int temp;
      int n = data.size();
      
      for (int i = 0; i < n - 1; i++) begin
        for (int j = 0; j < n - i - 1; j++) begin
          if (data[j] > data[j + 1]) begin
            temp = data[j];
            data[j] = data[j + 1];
            data[j + 1] = temp;
          end
        end
      end
    endfunction
    
    virtual function string get_name();
      return "Bubble Sort";
    endfunction
    
  endclass

  // Concrete strategy 2: Selection Sort
  class SelectionSortStrategy extends SortStrategy;
    
    virtual function void sort(ref int data[]);
      int min_idx, temp;
      int n = data.size();
      
      for (int i = 0; i < n - 1; i++) begin
        min_idx = i;
        for (int j = i + 1; j < n; j++) begin
          if (data[j] < data[min_idx]) begin
            min_idx = j;
          end
        end
        if (min_idx != i) begin
          temp = data[i];
          data[i] = data[min_idx];
          data[min_idx] = temp;
        end
      end
    endfunction
    
    virtual function string get_name();
      return "Selection Sort";
    endfunction
    
  endclass

  // Concrete strategy 3: Insertion Sort
  class InsertionSortStrategy extends SortStrategy;
    
    virtual function void sort(ref int data[]);
      int key, j;
      int n = data.size();
      
      for (int i = 1; i < n; i++) begin
        key = data[i];
        j = i - 1;
        while (j >= 0 && data[j] > key) begin
          data[j + 1] = data[j];
          j = j - 1;
        end
        data[j + 1] = key;
      end
    endfunction
    
    virtual function string get_name();
      return "Insertion Sort";
    endfunction
    
  endclass

  // Context class that uses different sorting strategies
  class SortingContext;
    SortStrategy strategy;
    
    function new(SortStrategy initial_strategy);
      this.strategy = initial_strategy;
    endfunction
    
    function void set_strategy(SortStrategy new_strategy);
      this.strategy = new_strategy;
    endfunction
    
    function void execute_sort(ref int data[]);
      if (strategy != null) begin
        $display("Using strategy: %s", strategy.get_name());
        strategy.sort(data);
      end else begin
        $display("Error: No sorting strategy set!");
      end
    endfunction
    
    function string get_current_strategy_name();
      if (strategy != null) begin
        return strategy.get_name();
      end else begin
        return "No strategy set";
      end
    endfunction
    
  endclass

endpackage

// Main design module
module sorting_strategy_pattern;
  import sorting_strategy_pkg::*;
  
  initial begin
    $display("=== Strategy Pattern Example: Sorting Algorithms ===");
    $display();
  end
  
endmodule