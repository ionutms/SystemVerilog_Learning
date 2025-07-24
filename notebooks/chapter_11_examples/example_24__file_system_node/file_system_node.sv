// file_system_node.sv
package file_system_pkg;
  
  // File node class with tree structure
  class FileNode;
    string name;
    string file_type;  // "file" or "directory"
    int size_bytes;
    FileNode children[$];  // Dynamic array for child nodes
    
    // Constructor
    function new(string node_name = "untitled", 
                 string node_type = "file", 
                 int node_size = 0);
      this.name = node_name;
      this.file_type = node_type;
      this.size_bytes = node_size;
    endfunction
    
    // Add child node (for directories)
    function void add_child(FileNode child);
      if (this.file_type == "directory") begin
        this.children.push_back(child);
      end else begin
        $display("Error: Cannot add child to file '%s'", this.name);
      end
    endfunction
    
    // Shallow copy - shares child references
    function FileNode shallow_copy();
      FileNode copy_node = new(this.name, this.file_type, this.size_bytes);
      // Copy child references (shallow)
      copy_node.children = this.children;
      return copy_node;
    endfunction
    
    // Deep copy - duplicates entire subtree
    function FileNode deep_copy();
      FileNode copy_node = new(this.name, this.file_type, this.size_bytes);
      
      // Recursively copy all children
      foreach(this.children[i]) begin
        copy_node.children.push_back(this.children[i].deep_copy());
      end
      
      return copy_node;
    endfunction
    
    // Display node information
    function void display_info(int indent_level = 0);
      string indent = "";
      
      // Create indentation
      for(int i = 0; i < indent_level; i++) begin
        indent = {indent, "  "};
      end
      
      if (this.file_type == "directory") begin
        $display("%s[DIR] %s", indent, this.name);
        // Display children
        foreach(this.children[i]) begin
          this.children[i].display_info(indent_level + 1);
        end
      end else begin
        $display("%s[FILE] %s (%0d bytes)", indent, this.name, 
                 this.size_bytes);
      end
    endfunction
    
    // Get total size (including children for directories)
    function int get_total_size();
      int total = this.size_bytes;
      
      if (this.file_type == "directory") begin
        foreach(this.children[i]) begin
          total += this.children[i].get_total_size();
        end
      end
      
      return total;
    endfunction
    
    // Modify file size (for testing copy behavior)
    function void modify_size(int new_size);
      this.size_bytes = new_size;
      $display("Modified '%s' size to %0d bytes", this.name, new_size);
    endfunction
    
  endclass
  
endpackage

module file_system_node;
  
  import file_system_pkg::*;
  
  initial begin
    $display("File System Node - Tree Structure Copying Example");
    $display("====================================================");
  end
  
endmodule