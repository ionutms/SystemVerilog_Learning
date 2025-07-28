// cpu_configuration_builder_testbench.sv
module cpu_builder_test_module;
  import cpu_config_pkg::*;
  
  cpu_builder_design_module DESIGN_INSTANCE();
  
  initial begin
    cpu_configuration_t gaming_cpu, server_cpu, budget_cpu, partial_cpu;
    
    // Dump waves
    $dumpfile("cpu_builder_test_module.vcd");
    $dumpvars(0, cpu_builder_test_module);
    
    $display("=== Builder Pattern Example ===");
    $display();
    
    // Build a gaming CPU configuration using function chaining
    $display("Building Gaming CPU Configuration:");
    gaming_cpu = create_default_config();
    gaming_cpu = set_processor(gaming_cpu, "Intel i9-13900K");
    gaming_cpu = set_cores(gaming_cpu, 24);
    gaming_cpu = set_cache(gaming_cpu, 36);
    gaming_cpu = set_frequency(gaming_cpu, 3000);
    gaming_cpu = enable_hyperthreading(gaming_cpu);
    display_config(gaming_cpu);
    $display();
    
    // Build a server CPU configuration (more compact style)
    $display("Building Server CPU Configuration:");
    server_cpu = enable_hyperthreading(
                   set_frequency(
                     set_cache(
                       set_cores(
                         set_processor(create_default_config(), 
                                      "AMD EPYC 9654"), 
                         96), 
                       384), 
                     2400));
    display_config(server_cpu);
    $display();
    
    // Build a budget CPU configuration
    $display("Building Budget CPU Configuration:");
    budget_cpu = create_default_config();
    budget_cpu = set_processor(budget_cpu, "AMD Ryzen 5 5600X");
    budget_cpu = set_cores(budget_cpu, 6);
    budget_cpu = set_cache(budget_cpu, 32);
    budget_cpu = set_frequency(budget_cpu, 3700);
    budget_cpu = disable_hyperthreading(budget_cpu);
    display_config(budget_cpu);
    $display();
    
    // Demonstrate partial building with defaults
    $display("Building Partial Configuration (only processor and cores):");
    partial_cpu = create_default_config();
    partial_cpu = set_processor(partial_cpu, "Custom CPU");
    partial_cpu = set_cores(partial_cpu, 8);
    display_config(partial_cpu);
    $display();
    
    #10;  // Wait before finishing
    $display("Builder Pattern demonstration completed!");
  end

endmodule