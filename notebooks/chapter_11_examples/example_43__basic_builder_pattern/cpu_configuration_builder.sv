// cpu_configuration_builder.sv
package cpu_config_pkg;

  typedef struct {
    string processor_type;
    int    core_count;
    int    cache_size_mb;
    int    frequency_mhz;
    bit    hyperthreading_enabled;
  } cpu_configuration_t;

  function cpu_configuration_t create_default_config();
    cpu_configuration_t cfg;
    cfg.processor_type = "Generic";
    cfg.core_count = 1;
    cfg.cache_size_mb = 1;
    cfg.frequency_mhz = 1000;
    cfg.hyperthreading_enabled = 0;
    return cfg;
  endfunction

  function cpu_configuration_t set_processor(cpu_configuration_t cfg, 
                                            string proc_type);
    cfg.processor_type = proc_type;
    return cfg;
  endfunction

  function cpu_configuration_t set_cores(cpu_configuration_t cfg, 
                                        int cores);
    cfg.core_count = cores;
    return cfg;
  endfunction

  function cpu_configuration_t set_cache(cpu_configuration_t cfg, 
                                        int cache_mb);
    cfg.cache_size_mb = cache_mb;
    return cfg;
  endfunction

  function cpu_configuration_t set_frequency(cpu_configuration_t cfg, 
                                            int freq_mhz);
    cfg.frequency_mhz = freq_mhz;
    return cfg;
  endfunction

  function cpu_configuration_t enable_hyperthreading(cpu_configuration_t cfg);
    cfg.hyperthreading_enabled = 1;
    return cfg;
  endfunction

  function cpu_configuration_t disable_hyperthreading(cpu_configuration_t cfg);
    cfg.hyperthreading_enabled = 0;
    return cfg;
  endfunction

  function void display_config(cpu_configuration_t cfg);
    $display("=== CPU Configuration ===");
    $display("Processor: %s", cfg.processor_type);
    $display("Cores: %0d", cfg.core_count);
    $display("Cache: %0d MB", cfg.cache_size_mb);
    $display("Frequency: %0d MHz", cfg.frequency_mhz);
    $display("Hyperthreading: %s", 
             cfg.hyperthreading_enabled ? "Enabled" : "Disabled");
    $display("========================");
  endfunction

endpackage

module cpu_builder_design_module;
  import cpu_config_pkg::*;
  
  initial begin
    $display("Builder Pattern Design Module Loaded");
  end

endmodule