// strategy_pattern_generics.sv
package sorting_strategy_pkg;
  
  // Generic strategy interface for sorting algorithms
  virtual class SortingStrategy #(type T = int);
    pure virtual function void sort(ref T data[$]);
    pure virtual function string get_name();
  endclass

  // Bubble sort strategy implementation
  class BubbleSortStrategy #(type T = int) extends SortingStrategy#(T);
    
    virtual function void sort(ref T data[$]);
      int n = data.size();
      T temp;
      
      for (int i = 0; i < n-1; i++) begin
        for (int j = 0; j < n-i-1; j++) begin
          if (data[j] > data[j+1]) begin
            temp = data[j];
            data[j] = data[j+1];
            data[j+1] = temp;
          end
        end
      end
    endfunction
    
    virtual function string get_name();
      return "Bubble Sort";
    endfunction
    
  endclass

  // Selection sort strategy implementation  
  class SelectionSortStrategy #(type T = int) extends SortingStrategy#(T);
    
    virtual function void sort(ref T data[$]);
      int n = data.size();
      int min_idx;
      T temp;
      
      for (int i = 0; i < n-1; i++) begin
        min_idx = i;
        for (int j = i+1; j < n; j++) begin
          if (data[j] < data[min_idx]) begin
            min_idx = j;
          end
        end
        temp = data[min_idx];
        data[min_idx] = data[i];
        data[i] = temp;
      end
    endfunction
    
    virtual function string get_name();
      return "Selection Sort";
    endfunction
    
  endclass

  // Context class that uses the strategy
  class SortingContext #(type T = int);
    SortingStrategy#(T) strategy;
    
    function new(SortingStrategy#(T) initial_strategy);
      this.strategy = initial_strategy;
    endfunction
    
    function void set_strategy(SortingStrategy#(T) new_strategy);
      this.strategy = new_strategy;
    endfunction
    
    function void execute_sort(ref T data[$]);
      $display("Using %s algorithm:", strategy.get_name());
      strategy.sort(data);
    endfunction
    
  endclass

endpackage

module strategy_pattern_generics;
  import sorting_strategy_pkg::*;
  
  // Demonstrate the strategy pattern with different data types
  initial begin
    
    // Test with integer data
    int int_data[$];
    SortingContext#(int) int_context;
    BubbleSortStrategy#(int) bubble_sort;
    SelectionSortStrategy#(int) selection_sort;
    
    // Initialize integer array manually
    int_data.push_back(5);
    int_data.push_back(2);
    int_data.push_back(8);
    int_data.push_back(1);
    int_data.push_back(9);
    int_data.push_back(3);
    
    $display("=== Strategy Pattern with Generics Demo ===");
    $display("Original integer data: %p", int_data);
    
    // Create strategies
    bubble_sort = new();
    selection_sort = new();
    
    // Create context with bubble sort
    int_context = new(bubble_sort);
    int_context.execute_sort(int_data);
    $display("Sorted data: %p", int_data);
    $display();
    
    // Reset data and change strategy to selection sort
    int_data.delete();
    int_data.push_back(7);
    int_data.push_back(1);
    int_data.push_back(4);
    int_data.push_back(6);
    int_data.push_back(2);
    int_data.push_back(9);
    int_data.push_back(3);
    
    $display("New integer data: %p", int_data);
    int_context.set_strategy(selection_sort);
    int_context.execute_sort(int_data);
    $display("Sorted data: %p", int_data);
    $display();
    
    $display("=== Strategy Pattern with Generics Demo Complete ===");
    
  end
  
endmodule