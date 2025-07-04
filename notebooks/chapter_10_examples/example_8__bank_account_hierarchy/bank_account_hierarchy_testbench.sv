// bank_account_hierarchy_testbench.sv
module bank_account_test_module;
  import bank_account_pkg::*;
  
  // Instantiate design under test
  bank_account_hierarchy_module BANK_ACCOUNT_INSTANCE();
  
  // Test variables at module level
  Account basic_account;
  SavingsAccount savings_account;
  Account poly_account;
  
  initial begin
    // Dump waves
    $dumpfile("bank_account_test_module.vcd");
    $dumpvars(0, bank_account_test_module);
    
    $display("=== Bank Account Hierarchy Test ===");
    $display();
    
    // Test 1: Create basic account
    $display("--- Test 1: Basic Account Operations ---");
    basic_account = new("ACC12345", 1000.0);
    basic_account.display_info();
    basic_account.deposit(250.0);
    /* verilator lint_off IGNOREDRETURN */
    basic_account.withdraw(150.0);
    /* verilator lint_on IGNOREDRETURN */
    basic_account.display_info();
    $display();
    
    // Test 2: Create savings account
    $display("--- Test 2: Savings Account Operations ---");
    savings_account = new("SAV67890", 500.0, 0.05);
    savings_account.display_info();
    savings_account.deposit(200.0);
    savings_account.calculate_interest();
    savings_account.display_info();
    $display();
    
    // Test 3: Demonstrate inheritance and super usage
    $display("--- Test 3: Inheritance and Super Keyword ---");
    $display("Depositing to savings account (shows super.deposit()):");
    savings_account.deposit(100.0);
    $display();
    
    // Test 4: Interest rate operations
    $display("--- Test 4: Interest Rate Management ---");
    savings_account.set_interest_rate(0.03);
    savings_account.calculate_interest();
    savings_account.display_info();
    $display();
    
    // Test 5: Error handling
    $display("--- Test 5: Error Handling ---");
    basic_account.deposit(-50.0);  // Should show error
    /* verilator lint_off IGNOREDRETURN */
    basic_account.withdraw(2000.0);  // Should show error
    /* verilator lint_on IGNOREDRETURN */
    savings_account.set_interest_rate(-0.01);  // Should show error
    $display();
    
    // Test 6: Polymorphism demonstration
    $display("--- Test 6: Polymorphism ---");
    poly_account = savings_account;  // Assign savings account to base ref
    poly_account.display_info();  // Should call overridden method
    $display();
    
    $display("=== All tests completed ===");
    $display();
    
    #10;  // Wait for a few time units
    $finish;
  end
  
endmodule