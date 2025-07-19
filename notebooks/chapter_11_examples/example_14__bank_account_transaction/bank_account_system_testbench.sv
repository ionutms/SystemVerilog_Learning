// bank_account_system_testbench.sv
module bank_account_test_bench;
  import bank_account_pkg::*;

  // Instantiate design under test
  bank_account_system BANK_SYSTEM_INSTANCE();

  // Test variables
  BankAccount alice_account;
  BankAccount bob_account;
  BankAccount charlie_account;
  real balance_result;
  bit transfer_result;

  initial begin
    // Setup simulation
    $dumpfile("bank_account_test_bench.vcd");
    $dumpvars(0, bank_account_test_bench);
    
    $display("============================================================");
    $display("Starting Bank Account System Test");
    $display("============================================================");
    
    // Test 1: Create accounts
    $display("\n--- Test 1: Creating Bank Accounts ---");
    alice_account = new("Alice Johnson", 1000.0);
    #10;
    bob_account = new("Bob Smith", 500.0);
    #10;
    charlie_account = new("Charlie Brown");  // Start with $0
    #10;
    
    // Test 2: Basic deposits and withdrawals
    $display("\n--- Test 2: Basic Transactions ---");
    balance_result = alice_account.deposit(250.0, "Salary deposit");
    #10;
    balance_result = bob_account.withdraw(100.0, "ATM withdrawal");
    #10;
    balance_result = charlie_account.deposit(300.0, "Birthday money");
    #10;
    
    // Test 3: Transfer operations
    $display("\n--- Test 3: Transfer Operations ---");
    transfer_result = alice_account.transfer_to(bob_account, 200.0, 
                                                "Loan repayment");
    #10;
    transfer_result = bob_account.transfer_to(charlie_account, 150.0, "Gift");
    #10;
    
    // Test 4: Error conditions
    $display("\n--- Test 4: Error Conditions ---");
    balance_result = charlie_account.withdraw(1000.0, 
                                              "Insufficient funds test");
    #10;
    balance_result = alice_account.deposit(-50.0, "Invalid deposit test");
    #10;
    
    // Test 5: Display account summaries
    $display("\n--- Test 5: Account Summaries ---");
    alice_account.display_account();
    alice_account.display_transactions();
    
    bob_account.display_account();
    bob_account.display_transactions();
    
    charlie_account.display_account();
    charlie_account.display_transactions();
    
    // Test 6: Final balance checks
    $display("\n--- Test 6: Final Balance Verification ---");
    $display("Alice's final balance: $%.2f", alice_account.get_balance());
    $display("Bob's final balance: $%.2f", bob_account.get_balance());
    $display("Charlie's final balance: $%.2f", charlie_account.get_balance());
    
    $display("\n============================================================");
    $display("Bank Account System Test Completed");
    $display("============================================================");
    
    #20;
    $finish;
  end

endmodule