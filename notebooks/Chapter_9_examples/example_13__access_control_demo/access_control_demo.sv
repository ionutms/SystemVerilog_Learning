// access_control_demo.sv
// Example demonstrating access control with public, protected, and local
// members in SystemVerilog classes

// Base class demonstrating different access levels
class base_account_class;
  // Public members - accessible from anywhere
  int public_account_id;
  string public_account_name;
  
  // Protected members - accessible within class and derived classes
  protected real protected_balance;
  protected bit protected_active_flag;
  
  // Local (private) members - only accessible within this class
  local string local_pin_code;
  local int local_security_level;
  
  function new(int id, string name, real balance, string pin);
    public_account_id = id;
    public_account_name = name;
    protected_balance = balance;
    protected_active_flag = 1'b1;
    local_pin_code = pin;
    local_security_level = 3;
    $display("Base account created: ID=%0d, Name=%s", id, name);
  endfunction
  
  // Public method to display account info
  function void display_public_info();
    $display("Public Info - ID: %0d, Name: %s", 
             public_account_id, public_account_name);
  endfunction
  
  // Protected method - accessible to derived classes
  protected function real get_balance();
    return protected_balance;
  endfunction
  
  // Local method - only accessible within this class
  local function bit verify_pin(string pin);
    return (pin == local_pin_code);
  endfunction
  
  // Public method that uses local method internally
  function bit authenticate(string pin);
    if (verify_pin(pin)) begin
      $display("Authentication successful for %s", public_account_name);
      return 1'b1;
    end else begin
      $display("Authentication failed for %s", public_account_name);
      return 1'b0;
    end
  endfunction
endclass

// Derived class inheriting from base class
class savings_account_class extends base_account_class;
  real interest_rate;
  
  function new(int id, string name, real balance, string pin, real rate);
    super.new(id, name, balance, pin);
    interest_rate = rate;
    $display("Savings account created with interest rate: %0.2f%%", 
             rate * 100);
  endfunction
  
  // Can access protected members from base class
  function void calculate_interest();
    real interest = protected_balance * interest_rate;
    protected_balance += interest;
    $display("Interest calculated: %0.2f, New balance: %0.2f", 
             interest, protected_balance);
  endfunction
  
  // Can access protected methods from base class
  function void show_balance();
    $display("Current balance: %0.2f", get_balance());
  endfunction
  
  // Cannot access local members from base class
  // This would cause a compilation error:
  // function void illegal_access();
  //   $display("PIN: %s", local_pin_code);  // ERROR!
  // endfunction
endclass