// generic_array_container.sv
package generic_container_pkg;

  // Custom struct type for testing
  typedef struct {
    string name;
    int    age;
  } person_t;

  // Generic array container class
  class generic_array_container #(type T = int);
    
    // Private data members
    local T data_array[];
    local int size;
    local int capacity;
    
    // Constructor
    function new(int initial_capacity = 10);
      capacity = initial_capacity;
      size = 0;
      data_array = new[capacity];
    endfunction
    
    // Add element to container
    function void add(T item);
      if (size >= capacity) begin
        // Double capacity when full
        T temp_array[] = new[capacity * 2];
        for (int i = 0; i < size; i++) begin
          temp_array[i] = data_array[i];
        end
        data_array = temp_array;
        capacity *= 2;
        $display("Container resized to capacity: %0d", capacity);
      end
      data_array[size] = item;
      size++;
    endfunction
    
    // Get element from container
    function T get(int index);
      if (index >= 0 && index < size) begin
        return data_array[index];
      end else begin
        $error("Index %0d out of bounds (size=%0d)", index, size);
        return data_array[0]; // Return first element as default
      end
    endfunction
    
    // Display all elements
    function void display();
      $display("Container contents (size=%0d, capacity=%0d):", 
               size, capacity);
      for (int i = 0; i < size; i++) begin
        $display("  [%0d]: %p", i, data_array[i]);
      end
    endfunction
    
    // Get current size
    function int get_size();
      return size;
    endfunction
    
    // Get current capacity
    function int get_capacity();
      return capacity;
    endfunction
    
    // Check if container is empty
    function bit is_empty();
      return (size == 0);
    endfunction
    
    // Clear all elements
    function void clear();
      size = 0;
    endfunction
    
  endclass

endpackage