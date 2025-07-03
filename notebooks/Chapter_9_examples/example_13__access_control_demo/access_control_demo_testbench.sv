// access_control_demo_testbench.sv
// Testbench demonstrating access control visibility rules

module access_control_testbench;
  
  base_account_class base_account;
  savings_account_class savings_account;
  
  initial begin
    // Dump waves
    $dumpfile("access_control_testbench.vcd");
    $dumpvars(0, access_control_testbench);
    
    $display("=== Access Control Demo ===");
    $display();
    
    // Create base account
    $display("--- Creating Base Account ---");
    base_account = new(1001, "John Doe", 1000.50, "1234");
    
    // Access public members - this works
    $display("Accessing public members:");
    $display("  Account ID: %0d", base_account.public_account_id);
    $display("  Account Name: %s", base_account.public_account_name);
    
    // Call public method
    base_account.display_public_info();
    
    // Test authentication (uses local method internally)
    $display("\n--- Testing Authentication ---");
    if (base_account.authenticate("1234")) begin  // Correct PIN
      $display("Access granted with correct PIN");
    end
    if (!base_account.authenticate("5678")) begin  // Wrong PIN
      $display("Access denied with incorrect PIN");
    end
    
    $display();
    
    // Create savings account (derived class)
    $display("--- Creating Savings Account ---");
    savings_account = new(2001, "Jane Smith", 2500.75, "9876", 0.05);
    
    // Access public members of derived class
    $display("Accessing public members of derived class:");
    $display("  Account ID: %0d", savings_account.public_account_id);
    $display("  Account Name: %s", savings_account.public_account_name);
    
    // Call methods that access protected members
    $display("\n--- Testing Protected Access ---");
    savings_account.show_balance();
    savings_account.calculate_interest();
    savings_account.show_balance();
    
    $display();
    
    // The following would cause compilation errors:
    // $display("Balance: %0.2f", base_account.protected_balance);     // ERROR!
    // $display("PIN: %s", base_account.local_pin_code);              // ERROR!
    // base_account.verify_pin("1234");                               // ERROR!
    
    $display("--- Access Control Rules Summary ---");
    $display("Public members: Accessible from anywhere");
    $display("Protected members: Accessible within class and derived classes");
    $display("Local members: Only accessible within the defining class");
    $display("Derived classes can access protected but not local members");
    
    $display();
    $display("=== Demo Complete ===");
    
    #10;
  end
  
endmodule