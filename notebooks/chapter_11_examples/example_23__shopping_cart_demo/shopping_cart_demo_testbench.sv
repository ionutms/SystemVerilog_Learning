// shopping_cart_demo_testbench.sv
module shopping_cart_test_bench;
  import item_pkg::*;
  import shopping_cart_pkg::*;
  
  // Instantiate design under test
  shopping_cart_demo DESIGN_INSTANCE_NAME();
  
  // Class handle declarations
  ShoppingCart alice_cart;
  ShoppingCart bob_shallow;
  ShoppingCart charlie_deep;
  Item laptop;
  Item mouse;
  Item keyboard;
  
  initial begin
    // Dump waves
    $dumpfile("shopping_cart_test_bench.vcd");
    $dumpvars(0, shopping_cart_test_bench);
    
    // Create original cart for Alice
    alice_cart = new("Alice");
    
    // Create some items
    laptop = new("Gaming Laptop", 999.99, 1);
    mouse = new("Wireless Mouse", 29.99, 2);  
    keyboard = new("Mechanical Keyboard", 89.99, 1);
    
    // Add items to Alice's cart
    $display("1. Building Alice's original cart:");
    alice_cart.addItem(laptop);
    alice_cart.addItem(mouse);
    alice_cart.addItem(keyboard);
    alice_cart.displayCart();
    
    // Demonstrate shallow copy
    $display("2. Creating Bob's cart via SHALLOW copy:");
    bob_shallow = alice_cart.shallowCopy("Bob");
    bob_shallow.displayCart();
    
    // Demonstrate deep copy  
    $display("3. Creating Charlie's cart via DEEP copy:");
    charlie_deep = alice_cart.deepCopy("Charlie");
    charlie_deep.displayCart();
    
    // Modify item in Alice's cart to show shallow copy effect
    $display("4. Alice modifies mouse quantity (affects Bob's shallow copy):");
    alice_cart.modifyItemQuantity(1, 5);  // Change mouse quantity
    
    $display("Alice's cart after modification:");
    alice_cart.displayCart();
    
    $display("Bob's cart (shallow copy - SHARES same items):");
    bob_shallow.displayCart();
    
    $display("Charlie's cart (deep copy - INDEPENDENT items):");
    charlie_deep.displayCart();
    
    // Modify item in Bob's cart to further demonstrate sharing
    $display("5. Bob modifies laptop quantity (affects Alice's original):");
    bob_shallow.modifyItemQuantity(0, 2);  // Change laptop quantity
    
    $display("Alice's cart (affected by Bob's change):");
    alice_cart.displayCart();
    
    $display("Bob's cart:");
    bob_shallow.displayCart();
    
    $display("Charlie's cart (still independent):");
    charlie_deep.displayCart();
    
    // Modify Charlie's cart to show independence
    $display("6. Charlie modifies keyboard quantity (independent):");
    charlie_deep.modifyItemQuantity(2, 3);  // Change keyboard quantity
    
    $display("Final cart states:");
    alice_cart.displayCart();
    bob_shallow.displayCart(); 
    charlie_deep.displayCart();
    
    $display("=== Demo Complete ===");
    $display("Key Learning: Shallow copy shares object references,");
    $display("             Deep copy creates independent objects.");
    
    #1;  // Wait for a time unit
  end
endmodule