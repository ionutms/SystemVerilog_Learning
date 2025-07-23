// shopping_cart_demo.sv
package item_pkg;
  // Item class representing products in shopping cart
  class Item;
    string name;
    real price;
    int quantity;
    
    function new(string item_name = "Unknown", real item_price = 0.0, 
                 int item_quantity = 1);
      this.name = item_name;
      this.price = item_price;
      this.quantity = item_quantity;
    endfunction
    
    function string toString();
      return $sformatf("%s ($%.2f x %0d)", name, price, quantity);
    endfunction
    
    function real getTotalPrice();
      return price * quantity;
    endfunction
  endclass
endpackage

package shopping_cart_pkg;
  import item_pkg::*;
  
  // ShoppingCart class with shallow and deep copy capabilities
  class ShoppingCart;
    string owner_name;
    Item items[$];
    
    function new(string owner = "Anonymous");
      this.owner_name = owner;
    endfunction
    
    // Add item to cart
    function void addItem(Item item);
      items.push_back(item);
      $display("[%s] Added: %s", owner_name, item.toString());
    endfunction
    
    // Shallow copy - shares the same item references
    function ShoppingCart shallowCopy(string new_owner);
      ShoppingCart copy_cart = new(new_owner);
      copy_cart.items = this.items;  // Shallow copy - same references
      $display("[SHALLOW] Copied cart from %s to %s", 
               owner_name, new_owner);
      return copy_cart;
    endfunction
    
    // Deep copy - creates new item instances
    function ShoppingCart deepCopy(string new_owner);
      ShoppingCart copy_cart = new(new_owner);
      Item new_item;
      
      foreach(items[i]) begin
        new_item = new(items[i].name, items[i].price, items[i].quantity);
        copy_cart.items.push_back(new_item);
      end
      $display("[DEEP] Copied cart from %s to %s", 
               owner_name, new_owner);
      return copy_cart;
    endfunction
    
    // Display cart contents
    function void displayCart();
      real total = 0.0;
      $display("\n=== %s's Shopping Cart ===", owner_name);
      if (items.size() == 0) begin
        $display("Cart is empty");
      end else begin
        foreach(items[i]) begin
          $display("%0d. %s", i+1, items[i].toString());
          total += items[i].getTotalPrice();
        end
        $display("Total: $%.2f", total);
      end
      $display("========================\n");
    endfunction
    
    // Modify item quantity (to demonstrate shallow vs deep copy behavior)
    function void modifyItemQuantity(int index, int new_quantity);
      if (index >= 0 && index < items.size()) begin
        $display("[%s] Changing %s quantity from %0d to %0d", 
                 owner_name, items[index].name, 
                 items[index].quantity, new_quantity);
        items[index].quantity = new_quantity;
      end else begin
        $display("[%s] Invalid item index: %0d", owner_name, index);
      end
    endfunction
  endclass
endpackage

module shopping_cart_demo;
  import item_pkg::*;
  import shopping_cart_pkg::*;
  
  initial begin
    $display("=== Shopping Cart Shallow vs Deep Copy Demo ===\n");
  end
endmodule