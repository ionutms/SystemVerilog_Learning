// simple_object_pool.sv
package object_pool_pkg;

  // Simple data object that can be pooled
  class data_packet;
    int id;
    string payload;
    bit [31:0] timestamp;
    
    function new(int packet_id = 0);
      this.id = packet_id;
      this.payload = "";
      this.timestamp = 0;
    endfunction
    
    function void reset();
      this.payload = "";
      this.timestamp = 0;
    endfunction
    
    function string to_string();
      return $sformatf("Packet[%0d]: %s @%0d", id, payload, timestamp);
    endfunction
  endclass

  // Simple object pool for managing data_packet objects
  class simple_object_pool;
    local data_packet available_objects[$];
    local data_packet allocated_objects[int];  // Handle -> object mapping
    local int next_handle;
    local int pool_size;
    
    function new(int size = 10);
      this.pool_size = size;
      this.next_handle = 1;
      
      // Pre-allocate objects in the pool
      for (int i = 0; i < size; i++) begin
        data_packet pkt = new(i);
        available_objects.push_back(pkt);
      end
      
      $display("Object pool created with %0d objects", size);
    endfunction
    
    // Get an object from the pool (returns handle)
    function int get_object();
      data_packet obj;
      int handle;
      
      if (available_objects.size() == 0) begin
        $display("ERROR: Object pool exhausted! No available objects");
        return 0;  // Invalid handle
      end
      
      obj = available_objects.pop_front();
      handle = next_handle++;
      allocated_objects[handle] = obj;
      
      $display("Allocated object (handle=%0d), %0d objects remaining", 
               handle, available_objects.size());
      return handle;
    endfunction
    
    // Return an object to the pool using its handle
    function bit return_object(int handle);
      data_packet obj;
      
      if (!allocated_objects.exists(handle)) begin
        $display("ERROR: Invalid handle %0d for object return", handle);
        return 0;
      end
      
      obj = allocated_objects[handle];
      obj.reset();  // Clean up the object
      allocated_objects.delete(handle);
      available_objects.push_back(obj);
      
      $display("Returned object (handle=%0d), %0d objects available", 
               handle, available_objects.size());
      return 1;
    endfunction
    
    // Get object reference by handle for manipulation
    function data_packet get_object_ref(int handle);
      if (!allocated_objects.exists(handle)) begin
        $display("ERROR: Invalid handle %0d for object access", handle);
        return null;
      end
      return allocated_objects[handle];
    endfunction
    
    function int get_available_count();
      return available_objects.size();
    endfunction
    
    function int get_allocated_count();
      return allocated_objects.size();
    endfunction
    
    function void print_status();
      $display("Pool Status: %0d available, %0d allocated, %0d total", 
               available_objects.size(), allocated_objects.size(), 
               pool_size);
    endfunction
  endclass

endpackage