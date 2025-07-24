// file_system_node_testbench.sv
module file_system_node_testbench;
  
  import file_system_pkg::*;
  
  // Instantiate design under test
  file_system_node FILE_SYSTEM_INSTANCE();
  
  // Test variables
  FileNode root_dir;
  FileNode src_dir, docs_dir;
  FileNode main_file, header_file, readme_file;
  FileNode shallow_copy_root, deep_copy_root;
  
  initial begin
    // Dump waves
    $dumpfile("file_system_node_testbench.vcd");
    $dumpvars(0, file_system_node_testbench);
    
    $display();
    $display("Creating File System Tree Structure");
    $display("===================================");
    
    // Create root directory
    root_dir = new("project", "directory", 0);
    
    // Create subdirectories
    src_dir = new("src", "directory", 0);
    docs_dir = new("docs", "directory", 0);
    
    // Create files
    main_file = new("main.sv", "file", 1024);
    header_file = new("header.svh", "file", 512);
    readme_file = new("README.md", "file", 256);
    
    // Build tree structure
    root_dir.add_child(src_dir);
    root_dir.add_child(docs_dir);
    
    src_dir.add_child(main_file);
    src_dir.add_child(header_file);
    
    docs_dir.add_child(readme_file);
    
    $display();
    $display("Original Tree Structure:");
    $display("------------------------");
    root_dir.display_info();
    
    $display();
    $display("Total size: %0d bytes", root_dir.get_total_size());
    
    #10;
    
    // Demonstrate shallow copy
    $display();
    $display("Performing Shallow Copy");
    $display("=======================");
    shallow_copy_root = root_dir.shallow_copy();
    
    $display();
    $display("Shallow Copy Tree Structure:");
    $display("-----------------------------");
    shallow_copy_root.display_info();
    
    #10;
    
    // Modify original file to show shallow copy behavior
    $display();
    $display("Modifying original file to test shallow copy behavior");
    $display("-----------------------------------------------------");
    main_file.modify_size(2048);
    
    $display();
    $display("Original tree after modification:");
    $display("---------------------------------");
    root_dir.display_info();
    
    $display();
    $display("Shallow copy tree (shares same file objects):");
    $display("----------------------------------------------");
    shallow_copy_root.display_info();
    
    #10;
    
    // Reset file size for deep copy test
    main_file.modify_size(1024);
    
    // Demonstrate deep copy
    $display();
    $display("Performing Deep Copy");
    $display("====================");
    deep_copy_root = root_dir.deep_copy();
    
    $display();
    $display("Deep Copy Tree Structure:");
    $display("--------------------------");
    deep_copy_root.display_info();
    
    #10;
    
    // Modify original file to show deep copy behavior
    $display();
    $display("Modifying original file to test deep copy behavior");
    $display("---------------------------------------------------");
    main_file.modify_size(4096);
    
    $display();
    $display("Original tree after modification:");
    $display("---------------------------------");
    root_dir.display_info();
    
    $display();
    $display("Deep copy tree (independent file objects):");
    $display("-------------------------------------------");
    deep_copy_root.display_info();
    
    #10;
    
    // Compare sizes
    $display();
    $display("Size Comparison After Modifications");
    $display("===================================");
    $display("Original tree total size: %0d bytes", 
             root_dir.get_total_size());
    $display("Shallow copy total size:  %0d bytes", 
             shallow_copy_root.get_total_size());
    $display("Deep copy total size:     %0d bytes", 
             deep_copy_root.get_total_size());
    
    $display();
    $display("Shallow copy shares subtrees - modifications affect both");
    $display("Deep copy duplicates entire tree - modifications are " +
             "independent");
    
    #10;
    $display();
    $display("File System Node Test Completed!");
    $finish;
    
  end
  
endmodule