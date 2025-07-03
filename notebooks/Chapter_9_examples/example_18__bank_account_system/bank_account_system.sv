// bank_account_system.sv
package bank_pkg;
  
  class BankAccount;
    // Static data members - shared across all instances
    static int total_accounts = 0;           // Total number of accounts
    static real total_bank_balance = 0.0;    // Sum of all account balances
    static string bank_name = "SystemVerilog Bank";
    
    // Instance data members - unique to each account
    int account_number;                      // Individual account number
    string account_holder;                   // Account holder name
    real balance;                           // Individual account balance
    
    // Constructor
    function new(string holder_name, real initial_balance = 0.0);
      total_accounts++;                      // Increment static counter
      account_number = total_accounts;       // Assign unique account number
      account_holder = holder_name;
      balance = initial_balance;
      total_bank_balance += initial_balance; // Add to total bank balance
      
      $display("Account created: #%0d for %s with balance $%.2f", 
               account_number, account_holder, balance);
    endfunction
    
    // Method to deposit money
    function void deposit(real amount);
      if (amount > 0) begin
        balance += amount;
        total_bank_balance += amount;        // Update static total
        $display("Deposited $%.2f to account #%0d. New balance: $%.2f", 
                 amount, account_number, balance);
      end else begin
        $display("Invalid deposit amount: $%.2f", amount);
      end
    endfunction
    
    // Method to withdraw money
    function void withdraw(real amount);
      if (amount > 0 && amount <= balance) begin
        balance -= amount;
        total_bank_balance -= amount;        // Update static total
        $display("Withdrew $%.2f from account #%0d. New balance: $%.2f", 
                 amount, account_number, balance);
      end else begin
        $display("Invalid withdrawal: $%.2f (available: $%.2f)", 
                 amount, balance);
      end
    endfunction
    
    // Method to display account info
    function void display_account();
      $display("Account #%0d: %s - Balance: $%.2f", 
               account_number, account_holder, balance);
    endfunction
    
    // Static method to display bank statistics
    static function void display_bank_stats();
      $display("=== %s Statistics ===", bank_name);
      $display("Total Accounts: %0d", total_accounts);
      $display("Total Bank Balance: $%.2f", total_bank_balance);
      $display("Average Balance: $%.2f", 
               total_accounts > 0 ? total_bank_balance / total_accounts : 0.0);
    endfunction
    
  endclass
  
endpackage

module bank_account_system;
  // This module serves as a container for the BankAccount class
  // The actual functionality is demonstrated in the testbench
endmodule