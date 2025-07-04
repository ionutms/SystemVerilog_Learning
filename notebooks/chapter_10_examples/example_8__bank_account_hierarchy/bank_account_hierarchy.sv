// bank_account_hierarchy.sv
package bank_account_pkg;

  // Base Account class
  class Account;
    protected real balance;
    protected string account_number;
    
    // Constructor
    function new(string acc_num = "00000", real initial_balance = 0.0);
      account_number = acc_num;
      balance = initial_balance;
      $display("Account created: %s with balance $%.2f", 
               account_number, balance);
    endfunction
    
    // Deposit money
    virtual function void deposit(real amount);
      if (amount > 0) begin
        balance += amount;
        $display("Deposited $%.2f to account %s. New balance: $%.2f",
                 amount, account_number, balance);
      end else begin
        $display("Error: Deposit amount must be positive");
      end
    endfunction
    
    // Withdraw money
    virtual function bit withdraw(real amount);
      if (amount > 0 && amount <= balance) begin
        balance -= amount;
        $display("Withdrew $%.2f from account %s. New balance: $%.2f",
                 amount, account_number, balance);
        return 1;
      end else begin
        $display("Error: Insufficient funds or invalid amount");
        return 0;
      end
    endfunction
    
    // Get current balance
    virtual function real get_balance();
      return balance;
    endfunction
    
    // Display account info
    virtual function void display_info();
      $display("Account: %s | Balance: $%.2f", account_number, balance);
    endfunction
  endclass

  // SavingsAccount class inherits from Account
  class SavingsAccount extends Account;
    protected real interest_rate;
    
    // Constructor
    function new(string acc_num = "SAV00000", real initial_balance = 0.0,
                 real rate = 0.02);
      super.new(acc_num, initial_balance);  // Call parent constructor
      interest_rate = rate;
      $display("Savings account created with %.2f%% interest rate",
               interest_rate * 100);
    endfunction
    
    // Override deposit to show savings account specific behavior
    virtual function void deposit(real amount);
      super.deposit(amount);  // Call parent deposit method
      $display("Thank you for saving with us!");
    endfunction
    
    // Add interest calculation method
    function void calculate_interest();
      real interest = balance * interest_rate;
      super.deposit(interest);  // Use parent deposit to add interest
      $display("Interest calculated: $%.2f added to savings account",
               interest);
    endfunction
    
    // Override display_info to show interest rate
    virtual function void display_info();
      super.display_info();  // Call parent display method
      $display("Interest Rate: %.2f%%", interest_rate * 100);
    endfunction
    
    // Set new interest rate
    function void set_interest_rate(real new_rate);
      if (new_rate >= 0) begin
        interest_rate = new_rate;
        $display("Interest rate updated to %.2f%%", interest_rate * 100);
      end else begin
        $display("Error: Interest rate cannot be negative");
      end
    endfunction
  endclass

endpackage

module bank_account_hierarchy_module;
  import bank_account_pkg::*;
  
  // Module just imports the package - testing done in testbench
  initial begin
    $display("Bank Account Hierarchy module loaded");
  end
  
endmodule