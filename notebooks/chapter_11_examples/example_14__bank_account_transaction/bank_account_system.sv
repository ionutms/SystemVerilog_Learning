// bank_account_system.sv
package bank_account_pkg;

  // Transaction types enumeration
  typedef enum {
    DEPOSIT,
    WITHDRAWAL,
    TRANSFER_IN,
    TRANSFER_OUT
  } transaction_type_t;

  // BankAccount class with nested Transaction class
  class BankAccount;
    
    // Nested Transaction class for internal tracking
    class Transaction;
      transaction_type_t trans_type;
      real amount;
      string description;
      time timestamp;
      
      // Transaction constructor
      function new(transaction_type_t t_type, real t_amount, 
                   string t_desc = "");
        this.trans_type = t_type;
        this.amount = t_amount;
        this.description = t_desc;
        this.timestamp = $time;
      endfunction
      
      // Display transaction details
      function void display();
        string type_str;
        case (trans_type)
          DEPOSIT:      type_str = "DEPOSIT";
          WITHDRAWAL:   type_str = "WITHDRAWAL";
          TRANSFER_IN:  type_str = "TRANSFER_IN";
          TRANSFER_OUT: type_str = "TRANSFER_OUT";
        endcase
        $display("  [%0t] %s: $%.2f - %s", 
                 timestamp, type_str, amount, description);
      endfunction
    endclass
    
    // Bank account properties
    string account_holder;
    int account_number;
    real balance;
    Transaction transaction_history[$];
    static int next_account_num = 1000;
    
    // BankAccount constructor
    function new(string holder_name, real initial_balance = 0.0);
      this.account_holder = holder_name;
      this.account_number = next_account_num++;
      this.balance = initial_balance;
      
      // Record initial deposit if any
      if (initial_balance > 0) begin
        Transaction initial_trans = new(DEPOSIT, initial_balance, 
                                        "Initial deposit");
        transaction_history.push_back(initial_trans);
      end
      
      $display("Account created for %s (Account #%0d) with balance $%.2f",
               holder_name, account_number, balance);
    endfunction
    
    // Deposit money
    function real deposit(real amount, string desc = "Deposit");
      if (amount > 0) begin
        Transaction new_trans = new(DEPOSIT, amount, desc);
        transaction_history.push_back(new_trans);
        balance += amount;
        $display("Deposited $%.2f to Account #%0d. New balance: $%.2f",
                 amount, account_number, balance);
      end else begin
        $display("Invalid deposit amount: $%.2f", amount);
      end
      return balance;
    endfunction
    
    // Withdraw money
    function real withdraw(real amount, string desc = "Withdrawal");
      if (amount > 0 && amount <= balance) begin
        Transaction new_trans = new(WITHDRAWAL, amount, desc);
        transaction_history.push_back(new_trans);
        balance -= amount;
        $display("Withdrew $%.2f from Account #%0d. New balance: $%.2f",
                 amount, account_number, balance);
      end else if (amount > balance) begin
        $display("Insufficient funds! Balance: $%.2f, Requested: $%.2f",
                 balance, amount);
      end else begin
        $display("Invalid withdrawal amount: $%.2f", amount);
      end
      return balance;
    endfunction
    
    // Transfer money to another account
    function bit transfer_to(BankAccount destination, real amount, 
                            string desc = "Transfer");
      string out_desc, in_desc;
      Transaction out_trans, in_trans;
      
      if (amount > 0 && amount <= balance) begin
        // Create description strings
        out_desc = $sformatf("Transfer to Account #%0d - %s",
                            destination.account_number, desc);
        in_desc = $sformatf("Transfer from Account #%0d - %s",
                           account_number, desc);
        
        // Create transactions
        out_trans = new(TRANSFER_OUT, amount, out_desc);
        in_trans = new(TRANSFER_IN, amount, in_desc);
        
        // Deduct from this account
        transaction_history.push_back(out_trans);
        balance -= amount;
        
        // Add to destination account  
        destination.transaction_history.push_back(in_trans);
        destination.balance += amount;
        
        $display("Transferred $%.2f from Account #%0d to Account #%0d",
                 amount, account_number, destination.account_number);
        return 1'b1;  // Success
      end else begin
        $display("Transfer failed: Invalid amount or insufficient funds");
        return 1'b0;  // Failure
      end
    endfunction
    
    // Get current balance
    function real get_balance();
      return balance;
    endfunction
    
    // Display account information
    function void display_account();
      $display("\n=== Account Information ===");
      $display("Account Holder: %s", account_holder);
      $display("Account Number: %0d", account_number);
      $display("Current Balance: $%.2f", balance);
    endfunction
    
    // Display transaction history
    function void display_transactions();
      $display("\n=== Transaction History ===");
      if (transaction_history.size() == 0) begin
        $display("No transactions recorded.");
      end else begin
        foreach (transaction_history[i]) begin
          transaction_history[i].display();
        end
      end
    endfunction
    
  endclass

endpackage

module bank_account_system;
  import bank_account_pkg::*;
  
  initial begin
    $display("Bank Account System Module Loaded");
    $display("Use testbench to interact with the system");
  end
  
endmodule