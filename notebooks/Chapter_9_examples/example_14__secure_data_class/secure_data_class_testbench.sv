// secure_data_class_testbench.sv
module secure_data_testbench;
  secure_data_module SECURE_DATA_INSTANCE();
  
  initial begin
    secure_data_class my_secure_data;
    int retrieved_code;
    bit access_result;
    
    // Dump waves
    $dumpfile("secure_data_testbench.vcd");
    $dumpvars(0, secure_data_testbench);
    
    $display("=== Testing Secure Data Class ===");
    $display();
    
    // Create instance of secure data class
    my_secure_data = new(9876, "Top Secret Information");
    
    // Test public access
    $display("1. Testing public access:");
    $display("   Public info: %s", my_secure_data.public_info);
    my_secure_data.public_info = "Updated Public Info";
    $display("   Updated public info: %s", my_secure_data.public_info);
    $display();
    
    // Test protected/public access
    $display("2. Testing public/protected access:");
    $display("   Access level: %0d", my_secure_data.access_level);
    $display();
    
    // Test private access through public methods
    $display("3. Testing local/private access through methods:");
    
    // Try to get secret code with wrong password
    $display("   Attempting access with wrong password:");
    retrieved_code = my_secure_data.get_secret_code("wrong_pass");
    $display("   Retrieved code: %0d", retrieved_code);
    $display();
    
    // Try to get secret code with correct password
    $display("   Attempting access with correct password:");
    retrieved_code = my_secure_data.get_secret_code("admin_pass");
    $display("   Retrieved code: %0d", retrieved_code);
    $display();
    
    // Test setter method
    $display("4. Testing setter method:");
    my_secure_data.set_secret_code(5555);
    $display();
    
    // Test access verification
    $display("5. Testing access verification:");
    access_result = my_secure_data.verify_access(1234);
    $display("   Verify with old code (1234): %s", 
             access_result ? "PASS" : "FAIL");
    
    access_result = my_secure_data.verify_access(5555);
    $display("   Verify with new code (5555): %s", 
             access_result ? "PASS" : "FAIL");
    $display();
    
    // Display secure information
    $display("6. Displaying secure information:");
    my_secure_data.display_info();
    $display();
    
    // Test invalid input
    $display("7. Testing invalid input:");
    my_secure_data.set_secret_code(-100);
    $display();
    
    $display("=== Secure Data Class Test Complete ===");
    
    #1;
    $finish;
  end
  
endmodule