// bank_account_system_testbench.sv
// No include needed - compile both files together

module bank_account_testbench;
  
  // Import the package
  import bank_pkg::*;
  
  // Declare account handles
  BankAccount alice_account, bob_account, charlie_account;
  
  initial begin
    // Dump waves for Verilator
    $dumpfile("bank_account_testbench.vcd");
    $dumpvars(0, bank_account_testbench);
    
    $display("=== Bank Account System Demo ===");
    $display("Demonstrating static vs instance data members");
    $display();
    
    // Show initial bank statistics (before any accounts)
    $display("Initial bank state:");
    BankAccount::display_bank_stats();
    $display();
    
    // Create first account
    $display("Creating accounts...");
    alice_account = new("Alice Johnson", 1000.0);
    
    // Show how static members are updated
    $display("After creating Alice's account:");
    BankAccount::display_bank_stats();
    $display();
    
    // Create second account
    bob_account = new("Bob Smith", 500.0);
    
    // Create third account
    charlie_account = new("Charlie Brown", 750.0);
    $display();
    
    // Show updated bank statistics
    $display("After creating all accounts:");
    BankAccount::display_bank_stats();
    $display();
    
    // Display individual account information
    $display("Individual account details:");
    alice_account.display_account();
    bob_account.display_account();
    charlie_account.display_account();
    $display();
    
    // Perform some transactions
    $display("Performing transactions...");
    alice_account.deposit(200.0);
    bob_account.withdraw(100.0);
    charlie_account.deposit(50.0);
    $display();
    
    // Show how static total_bank_balance is updated
    $display("After transactions:");
    BankAccount::display_bank_stats();
    $display();
    
    // Show individual balances (instance members)
    $display("Updated individual account details:");
    alice_account.display_account();
    bob_account.display_account();
    charlie_account.display_account();
    $display();
    
    // Demonstrate that each account has its own instance data
    $display("=== Key Observations ===");
    $display("1. Static members (total_accounts, total_bank_balance):");
    $display("   - Shared across ALL account instances");
    $display("   - Updated when ANY account is modified");
    $display("   - Can be accessed via class name: BankAccount::total_accounts");
    $display();
    $display("2. Instance members (account_number, balance, account_holder):");
    $display("   - Unique to each account object");
    $display("   - Alice's balance: $%.2f", alice_account.balance);
    $display("   - Bob's balance: $%.2f", bob_account.balance);
    $display("   - Charlie's balance: $%.2f", charlie_account.balance);
    $display();
    
    // Final bank statistics
    $display("Final bank statistics:");
    BankAccount::display_bank_stats();
    
    #10;  // Wait before finishing
    $display("Simulation completed!");
    $finish;
  end
  
endmodule