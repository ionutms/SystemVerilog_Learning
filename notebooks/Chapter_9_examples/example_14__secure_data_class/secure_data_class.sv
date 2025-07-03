// secure_data_class.sv
class secure_data_class;
  // Private data members (local by default in SystemVerilog)
  local int secret_code;
  local string confidential_message;
  
  // Protected data - accessible by derived classes
  int access_level;
  
  // Public data - accessible from anywhere (default)
  string public_info;
  
  // Constructor
  function new(int code = 1234, string msg = "Default Secret");
    this.secret_code = code;
    this.confidential_message = msg;
    this.access_level = 1;
    this.public_info = "Public Information";
  endfunction
  
  // Public method to set private data (setter)
  function void set_secret_code(int new_code);
    if (new_code > 0) begin
      this.secret_code = new_code;
      $display("Secret code updated successfully");
    end else begin
      $display("Invalid code! Must be positive");
    end
  endfunction
  
  // Public method to get private data (getter) - with validation
  function int get_secret_code(string password);
    if (password == "admin_pass") begin
      $display("Access granted - returning secret code");
      return this.secret_code;
    end else begin
      $display("Access denied - incorrect password");
      return -1;
    end
  endfunction
  
  // Public method to safely display information
  function void display_info();
    $display("=== Secure Data Class Information ===");
    $display("Public Info: %s", this.public_info);
    $display("Access Level: %0d", this.access_level);
    $display("Secret Code: [PROTECTED]");
    $display("Confidential Message: [PROTECTED]");
  endfunction
  
  // Method to verify access
  function bit verify_access(int code_attempt);
    return (code_attempt == this.secret_code);
  endfunction
  
endclass

module secure_data_module;
  initial begin
    $display("=== Secure Data Class Example ===");
    $display();
  end
endmodule