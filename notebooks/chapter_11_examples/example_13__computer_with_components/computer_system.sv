// computer_system.sv
package computer_components_pkg;

  // CPU class - handles processing operations
  class cpu_class;
    string model;
    int    clock_speed_mhz;
    int    cores;
    
    function new(string model = "GenericCPU", int speed = 1000, int cores = 1);
      this.model = model;
      this.clock_speed_mhz = speed;
      this.cores = cores;
      $display("CPU created: %s @ %0d MHz, %0d cores", 
               model, speed, cores);
    endfunction
    
    function void execute_instruction(string instruction);
      $display("CPU executing: %s", instruction);
    endfunction
    
    function void display_info();
      $display("CPU Info: %s @ %0d MHz, %0d cores", 
               model, clock_speed_mhz, cores);
    endfunction
  endclass

  // RAM class - handles memory operations
  class ram_class;
    int    capacity_gb;
    string memory_type;
    int    used_memory_mb;
    
    function new(int capacity = 8, string mem_type = "DDR4");
      this.capacity_gb = capacity;
      this.memory_type = mem_type;
      this.used_memory_mb = 0;
      $display("RAM created: %0d GB %s", capacity, mem_type);
    endfunction
    
    function bit allocate_memory(int size_mb);
      if (used_memory_mb + size_mb <= capacity_gb * 1024) begin
        used_memory_mb += size_mb;
        $display("Allocated %0d MB, Used: %0d MB", size_mb, used_memory_mb);
        return 1'b1; // Success
      end else begin
        $display("Memory allocation failed - insufficient space");
        return 1'b0; // Failure
      end
    endfunction
    
    function void display_info();
      $display("RAM Info: %0d GB %s, Used: %0d MB / %0d MB", 
               capacity_gb, memory_type, used_memory_mb, capacity_gb * 1024);
    endfunction
  endclass

  // Storage class - handles disk operations
  class storage_class;
    int    capacity_gb;
    string storage_type;
    int    used_space_gb;
    
    function new(int capacity = 500, string stor_type = "SSD");
      this.capacity_gb = capacity;
      this.storage_type = stor_type;
      this.used_space_gb = 0;
      $display("Storage created: %0d GB %s", capacity, stor_type);
    endfunction
    
    function bit store_data(string filename, int size_gb);
      if (used_space_gb + size_gb <= capacity_gb) begin
        used_space_gb += size_gb;
        $display("Stored %s (%0d GB), Used: %0d GB", 
                 filename, size_gb, used_space_gb);
        return 1'b1; // Success
      end else begin
        $display("Storage failed - insufficient space for %s", filename);
        return 1'b0; // Failure
      end
    endfunction
    
    function void display_info();
      $display("Storage Info: %0d GB %s, Used: %0d GB / %0d GB", 
               capacity_gb, storage_type, used_space_gb, capacity_gb);
    endfunction
  endclass

  // Computer class - main class with nested components
  class computer_class;
    string       model;
    cpu_class    cpu;
    ram_class    ram;
    storage_class storage;
    
    function new(string model = "GenericPC");
      this.model = model;
      $display("=== Creating Computer: %s ===", model);
      
      // Create nested component objects
      cpu = new("Intel i7", 3200, 8);
      ram = new(16, "DDR4");
      storage = new(1000, "NVMe SSD");
      
      $display("=== Computer %s ready ===", model);
    endfunction
    
    function void boot_system();
      bit ram_result, storage_result;
      $display("\n=== Booting %s ===", model);
      cpu.execute_instruction("Initialize BIOS");
      ram_result = ram.allocate_memory(512); // Boot loader
      storage_result = storage.store_data("boot.log", 1);
      cpu.execute_instruction("Load Operating System");
      ram_result = ram.allocate_memory(2048); // OS
      $display("=== Boot complete ===");
    endfunction
    
    function void run_application(string app_name, int ram_mb, int storage_gb);
      $display("\n=== Running %s ===", app_name);
      
      if (ram.allocate_memory(ram_mb)) begin
        if (storage.store_data({app_name, "_data.dat"}, storage_gb)) begin
          cpu.execute_instruction({"Run ", app_name});
          $display("Application %s running successfully", app_name);
        end else begin
          $display("Application %s failed - storage issue", app_name);
        end
      end else begin
        $display("Application %s failed - memory issue", app_name);
      end
    endfunction
    
    function void display_system_info();
      $display("\n=== %s System Information ===", model);
      cpu.display_info();
      ram.display_info();
      storage.display_info();
    endfunction
    
    function void shutdown();
      bit storage_result;
      $display("\n=== Shutting down %s ===", model);
      cpu.execute_instruction("Save system state");
      storage_result = storage.store_data("shutdown.log", 1);
      cpu.execute_instruction("Power off");
      $display("=== Shutdown complete ===");
    endfunction
  endclass

endpackage

module computer_system_module;
  import computer_components_pkg::*;
  
  initial begin
    $display("Computer System Design Module");
    $display("Demonstrates nested class composition");
  end
endmodule