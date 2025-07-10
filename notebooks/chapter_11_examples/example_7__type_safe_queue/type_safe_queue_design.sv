// type_safe_queue_design.sv
// Type-safe queue implementation with parameterized data types

package type_safe_queue_pkg;

  // Base queue interface for type safety
  virtual class BaseQueue;
    pure virtual function int size();
    pure virtual function bit is_empty();
    pure virtual function bit is_full();
    pure virtual function void clear();
  endclass

  // Parameterized type-safe queue class
  class TypeSafeQueue #(type T = int, int MAX_SIZE = 16) extends BaseQueue;
    
    // Internal storage array
    protected T queue_data[MAX_SIZE];
    protected int head_ptr;
    protected int tail_ptr;
    protected int count;
    
    // Constructor
    function new();
      head_ptr = 0;
      tail_ptr = 0;
      count = 0;
    endfunction
    
    // Enqueue operation - add element to rear
    virtual function bit enqueue(T item);
      if (is_full()) begin
        $display("ERROR: Queue is full, cannot enqueue item");
        return 0;
      end
      
      queue_data[tail_ptr] = item;
      tail_ptr = (tail_ptr + 1) % MAX_SIZE;
      count++;
      
      $display("Enqueued item (Queue size: %0d)", count);
      return 1;
    endfunction
    
    // Dequeue operation - remove element from front
    virtual function bit dequeue(output T item);
      if (is_empty()) begin
        $display("ERROR: Queue is empty, cannot dequeue item");
        return 0;
      end
      
      item = queue_data[head_ptr];
      head_ptr = (head_ptr + 1) % MAX_SIZE;
      count--;
      
      $display("Dequeued item (Queue size: %0d)", count);
      return 1;
    endfunction
    
    // Peek at front element without removing it
    virtual function bit peek_front(output T item);
      if (is_empty()) begin
        $display("ERROR: Queue is empty, cannot peek");
        return 0;
      end
      
      item = queue_data[head_ptr];
      $display("Peek front operation completed");
      return 1;
    endfunction
    
    // Peek at rear element without removing it
    virtual function bit peek_rear(output T item);
      int rear_idx;
      
      if (is_empty()) begin
        $display("ERROR: Queue is empty, cannot peek");
        return 0;
      end
      
      rear_idx = (tail_ptr - 1 + MAX_SIZE) % MAX_SIZE;
      item = queue_data[rear_idx];
      $display("Peek rear operation completed");
      return 1;
    endfunction
    
    // Get current queue size
    virtual function int size();
      return count;
    endfunction
    
    // Check if queue is empty
    virtual function bit is_empty();
      return (count == 0);
    endfunction
    
    // Check if queue is full
    virtual function bit is_full();
      return (count == MAX_SIZE);
    endfunction
    
    // Clear all elements
    virtual function void clear();
      head_ptr = 0;
      tail_ptr = 0;
      count = 0;
      $display("Queue cleared");
    endfunction
    
    // Display queue contents
    virtual function void display_queue();
      int i, idx;
      
      $display("=== Queue Contents ===");
      $display("Size: %0d/%0d", count, MAX_SIZE);
      $display("Head: %0d, Tail: %0d", head_ptr, tail_ptr);
      
      if (is_empty()) begin
        $display("Queue is empty");
      end else begin
        $display("Queue has %0d elements", count);
      end
      $display("===================");
    endfunction
    
  endclass

  // Specialized queue for string data
  class StringQueue extends TypeSafeQueue#(string, 8);
    
    // Override enqueue for string-specific messaging
    virtual function bit enqueue(string item);
      if (is_full()) begin
        $display("ERROR: String queue is full, cannot enqueue item");
        return 0;
      end
      
      queue_data[tail_ptr] = item;
      tail_ptr = (tail_ptr + 1) % MAX_SIZE;
      count++;
      
      $display("Enqueued string: \"%s\" (Queue size: %0d)", item, count);
      return 1;
    endfunction
    
    // Override dequeue for string-specific messaging
    virtual function bit dequeue(output string item);
      if (is_empty()) begin
        $display("ERROR: String queue is empty, cannot dequeue item");
        return 0;
      end
      
      item = queue_data[head_ptr];
      head_ptr = (head_ptr + 1) % MAX_SIZE;
      count--;
      
      $display("Dequeued string: \"%s\" (Queue size: %0d)", item, count);
      return 1;
    endfunction
    
    // Override display for string-specific formatting
    virtual function void display_queue();
      int i, idx;
      
      $display("=== String Queue Contents ===");
      $display("Size: %0d/%0d", count, MAX_SIZE);
      
      if (is_empty()) begin
        $display("Queue is empty");
      end else begin
        $display("Elements:");
        for (i = 0; i < count; i++) begin
          idx = (head_ptr + i) % MAX_SIZE;
          $display("  [%0d]: \"%s\"", i, queue_data[idx]);
        end
      end
      $display("============================");
    endfunction
    
  endclass

  // Specialized queue for integer data
  class IntQueue extends TypeSafeQueue#(int, 10);
    
    // Override enqueue for int-specific messaging
    virtual function bit enqueue(int item);
      if (is_full()) begin
        $display("ERROR: Int queue is full, cannot enqueue item");
        return 0;
      end
      
      queue_data[tail_ptr] = item;
      tail_ptr = (tail_ptr + 1) % MAX_SIZE;
      count++;
      
      $display("Enqueued int: %0d (Queue size: %0d)", item, count);
      return 1;
    endfunction
    
    // Override dequeue for int-specific messaging
    virtual function bit dequeue(output int item);
      if (is_empty()) begin
        $display("ERROR: Int queue is empty, cannot dequeue item");
        return 0;
      end
      
      item = queue_data[head_ptr];
      head_ptr = (head_ptr + 1) % MAX_SIZE;
      count--;
      
      $display("Dequeued int: %0d (Queue size: %0d)", item, count);
      return 1;
    endfunction
    
    // Override display for int-specific formatting
    virtual function void display_queue();
      int i, idx;
      
      $display("=== Int Queue Contents ===");
      $display("Size: %0d/%0d", count, MAX_SIZE);
      
      if (is_empty()) begin
        $display("Queue is empty");
      end else begin
        $write("Elements: ");
        for (i = 0; i < count; i++) begin
          idx = (head_ptr + i) % MAX_SIZE;
          $write("%0d ", queue_data[idx]);
        end
        $display();
      end
      $display("=========================");
    endfunction
    
  endclass

  // Specialized queue for byte data
  class ByteQueue extends TypeSafeQueue#(bit [7:0], 6);
    
    // Override enqueue for byte-specific messaging
    virtual function bit enqueue(bit [7:0] item);
      if (is_full()) begin
        $display("ERROR: Byte queue is full, cannot enqueue item");
        return 0;
      end
      
      queue_data[tail_ptr] = item;
      tail_ptr = (tail_ptr + 1) % MAX_SIZE;
      count++;
      
      $display("Enqueued byte: 0x%02h (Queue size: %0d)", item, count);
      return 1;
    endfunction
    
    // Override dequeue for byte-specific messaging
    virtual function bit dequeue(output bit [7:0] item);
      if (is_empty()) begin
        $display("ERROR: Byte queue is empty, cannot dequeue item");
        return 0;
      end
      
      item = queue_data[head_ptr];
      head_ptr = (head_ptr + 1) % MAX_SIZE;
      count--;
      
      $display("Dequeued byte: 0x%02h (Queue size: %0d)", item, count);
      return 1;
    endfunction
    
    // Override display for byte-specific formatting
    virtual function void display_queue();
      int i, idx;
      
      $display("=== Byte Queue Contents ===");
      $display("Size: %0d/%0d", count, MAX_SIZE);
      
      if (is_empty()) begin
        $display("Queue is empty");
      end else begin
        $write("Elements: ");
        for (i = 0; i < count; i++) begin
          idx = (head_ptr + i) % MAX_SIZE;
          $write("0x%02h ", queue_data[idx]);
        end
        $display();
      end
      $display("=========================");
    endfunction
    
  endclass

  // Queue manager for handling multiple queue types
  class QueueManager;
    
    // Different queue instances
    IntQueue int_queue;
    ByteQueue byte_queue;
    StringQueue string_queue;
    
    function new();
      int_queue = new();
      byte_queue = new();
      string_queue = new();
    endfunction
    
    // Demonstrate operations on different queue types
    function void demonstrate_operations();
      bit success;
      
      $display("\n=== Queue Manager Demo ===");
      
      // Test integer queue
      $display("\n--- Integer Queue Test ---");
      success = int_queue.enqueue(42);
      if (!success) $display("Failed to enqueue 42");
      
      success = int_queue.enqueue(100);
      if (!success) $display("Failed to enqueue 100");
      
      success = int_queue.enqueue(255);
      if (!success) $display("Failed to enqueue 255");
      
      int_queue.display_queue();
      
      // Test byte queue
      $display("\n--- Byte Queue Test ---");
      success = byte_queue.enqueue(8'hFF);
      if (!success) $display("Failed to enqueue 0xFF");
      
      success = byte_queue.enqueue(8'hAA);
      if (!success) $display("Failed to enqueue 0xAA");
      
      success = byte_queue.enqueue(8'h55);
      if (!success) $display("Failed to enqueue 0x55");
      
      byte_queue.display_queue();
      
      // Test string queue
      $display("\n--- String Queue Test ---");
      success = string_queue.enqueue("Hello");
      if (!success) $display("Failed to enqueue Hello");
      
      success = string_queue.enqueue("World");
      if (!success) $display("Failed to enqueue World");
      
      success = string_queue.enqueue("SystemVerilog");
      if (!success) $display("Failed to enqueue SystemVerilog");
      
      string_queue.display_queue();
      
      $display("\n=========================");
    endfunction
    
  endclass

endpackage

// Top-level design module
module type_safe_queue_design();
  
  import type_safe_queue_pkg::*;
  
  // Queue instances for testing
  QueueManager queue_mgr;
  
  initial begin
    $display("=== Type-Safe Queue Design Demo ===");
    
    // Create queue manager
    queue_mgr = new();
    
    // Run demonstration
    queue_mgr.demonstrate_operations();
    
    $display("\n=== Design Demo Complete ===");
  end

endmodule