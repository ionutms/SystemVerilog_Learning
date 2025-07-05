// command_processor.sv

// Command processor package
package command_processor_pkg;

  // Base command class with virtual execute method
  virtual class base_command;
    string command_name;
    
    function new(string name);
      this.command_name = name;
    endfunction
    
    // Virtual method to be overridden by derived classes
    pure virtual function void execute();
    
    // Method to get command name
    function string get_name();
      return command_name;
    endfunction
  endclass

  // Save command implementation
  class save_command extends base_command;
    string filename;
    
    function new(string filename);
      super.new("SAVE");
      this.filename = filename;
    endfunction
    
    virtual function void execute();
      $display("[%0t] Executing %s command: Saving to file '%s'", 
               $time, command_name, filename);
    endfunction
  endclass

  // Load command implementation
  class load_command extends base_command;
    string filename;
    
    function new(string filename);
      super.new("LOAD");
      this.filename = filename;
    endfunction
    
    virtual function void execute();
      $display("[%0t] Executing %s command: Loading from file '%s'", 
               $time, command_name, filename);
    endfunction
  endclass

  // Delete command implementation
  class delete_command extends base_command;
    string filename;
    
    function new(string filename);
      super.new("DELETE");
      this.filename = filename;
    endfunction
    
    virtual function void execute();
      $display("[%0t] Executing %s command: Deleting file '%s'", 
               $time, command_name, filename);
    endfunction
  endclass

  // Command processor class
  class command_processor;
    base_command command_queue[$];
    int command_count;
    
    function new();
      command_count = 0;
    endfunction
    
    // Add command to queue
    function void add_command(base_command cmd);
      command_queue.push_back(cmd);
      command_count++;
      $display("[%0t] Added %s command to queue (total: %0d)", 
               $time, cmd.get_name(), command_count);
    endfunction
    
    // Execute all commands in queue
    function void execute_all();
      $display("[%0t] Starting command execution (%0d commands)", 
               $time, command_queue.size());
      
      foreach (command_queue[i]) begin
        $display("[%0t] Command %0d of %0d:", 
                 $time, i+1, command_queue.size());
        command_queue[i].execute();
      end
      
      $display("[%0t] All commands executed successfully", $time);
    endfunction
    
    // Clear all commands
    function void clear_queue();
      command_queue.delete();
      command_count = 0;
      $display("[%0t] Command queue cleared", $time);
    endfunction
    
    // Get queue status
    function int get_queue_size();
      return command_queue.size();
    endfunction
  endclass

endpackage

import command_processor_pkg::*;

module command_processor_module();
  
  // Command processor instance
  command_processor processor;
  
  // Command instances
  save_command save_cmd1, save_cmd2;
  load_command load_cmd1, load_cmd2;
  delete_command delete_cmd1;
  
  initial begin
    $display("=== Command Processor Design Module ===");
    $display();
    
    // Create processor instance
    processor = new();
    
    // Create various command instances
    save_cmd1 = new("config.txt");
    load_cmd1 = new("settings.cfg");
    delete_cmd1 = new("temp.log");
    save_cmd2 = new("backup.dat");
    load_cmd2 = new("profile.xml");
    
    // Add commands to processor queue
    $display("--- Adding Commands ---");
    processor.add_command(save_cmd1);
    processor.add_command(load_cmd1);
    processor.add_command(delete_cmd1);
    processor.add_command(save_cmd2);
    processor.add_command(load_cmd2);
    $display();
    
    // Execute all commands polymorphically
    $display("--- Executing Commands ---");
    processor.execute_all();
    $display();
    
    // Show final status
    $display("--- Final Status ---");
    $display("Queue size: %0d", processor.get_queue_size());
    
    // Clear queue
    processor.clear_queue();
    $display("Queue size after clear: %0d", processor.get_queue_size());
    $display();
    
    $display("=== Design Module Complete ===");
  end

endmodule