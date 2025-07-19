// transaction_copy_demo.sv - Basic Transaction Copy Implementation

package transaction_package;

  // Basic transaction class with ID and amount fields
  class basic_transaction;
    int transaction_id;
    real amount;
    string description;
    
    // Constructor with default values
    function new(int id = 0, real amt = 0.0, string desc = "");
      this.transaction_id = id;
      this.amount = amt;
      this.description = desc;
    endfunction
    
    // Shallow copy method - copies all field values
    function basic_transaction copy();
      basic_transaction copied_transaction;
      copied_transaction = new();
      copied_transaction.transaction_id = this.transaction_id;
      copied_transaction.amount = this.amount;
      copied_transaction.description = this.description;
      return copied_transaction;
    endfunction
    
    // Display transaction details
    function void display(string prefix = "");
      $display("%sTransaction ID: %0d, Amount: $%.2f, Desc: %s", 
               prefix, transaction_id, amount, description);
    endfunction
    
    // Compare two transactions for equality
    function bit is_equal(basic_transaction other);
      return (this.transaction_id == other.transaction_id &&
              this.amount == other.amount &&
              this.description == other.description);
    endfunction
    
  endclass

endpackage

module transaction_copy_demo;
  import transaction_package::*;
  
  initial begin
    $display("=== Basic Transaction Copy Demo ===");
    $display();
  end

endmodule