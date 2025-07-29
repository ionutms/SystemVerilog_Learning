// handle_leak_detector.sv
package leak_detection_pkg;
  
  // Global leak detection statistics
  class leak_detector;
    static int object_count = 0;
    static int total_created = 0;
    static int total_destroyed = 0;
    
    static function void report_status();
      $display("=== Leak Detection Report ===");
      $display("Objects created:   %0d", total_created);
      $display("Objects destroyed: %0d", total_destroyed);
      $display("Current alive:     %0d", object_count);
      if (object_count > 0) begin
        $display("*** POTENTIAL MEMORY LEAK DETECTED! ***");
      end else begin
        $display("No memory leaks detected.");
      end
      $display("============================");
    endfunction
  endclass
  
  // Base class that tracks object lifecycle
  virtual class trackable_object;
    static int next_id = 1;
    int object_id;
    string object_name;
    
    function new(string name = "unnamed");
      object_id = next_id++;
      object_name = name;
      leak_detector::object_count++;
      leak_detector::total_created++;
      $display("[TRACK] Created %s (ID:%0d) - Total alive: %0d", 
               object_name, object_id, leak_detector::object_count);
    endfunction
    
    virtual function void destroy();
      leak_detector::object_count--;
      leak_detector::total_destroyed++;
      $display("[TRACK] Destroyed %s (ID:%0d) - Total alive: %0d", 
               object_name, object_id, leak_detector::object_count);
    endfunction
  endclass
  
  // Example resource class that might leak
  class file_handle extends trackable_object;
    string filename;
    bit is_open;
    
    function new(string fname);
      super.new($sformatf("FileHandle:%s", fname));
      filename = fname;
      is_open = 1'b1;
    endfunction
    
    function void close_file();
      if (is_open) begin
        $display("[FILE] Closing file: %s", filename);
        is_open = 1'b0;
      end
    endfunction
    
    virtual function void destroy();
      if (is_open) begin
        $display("[WARNING] File %s not properly closed!", filename);
      end
      close_file();
      super.destroy();
    endfunction
  endclass
  
  // Network connection class
  class network_connection extends trackable_object;
    string host;
    int port;
    bit connected;
    
    function new(string h, int p);
      super.new($sformatf("NetConn:%s:%0d", h, p));
      host = h;
      port = p;
      connected = 1'b1;
    endfunction
    
    function void disconnect();
      if (connected) begin
        $display("[NET] Disconnecting from %s:%0d", host, port);
        connected = 1'b0;
      end
    endfunction
    
    virtual function void destroy();
      if (connected) begin
        $display("[WARNING] Connection to %s:%0d not closed!", host, port);
      end
      disconnect();
      super.destroy();
    endfunction
  endclass
  
endpackage

module handle_leak_detector;
  import leak_detection_pkg::*;
  
  initial begin
    $display("Handle Leak Detection System Ready");
  end
  
endmodule