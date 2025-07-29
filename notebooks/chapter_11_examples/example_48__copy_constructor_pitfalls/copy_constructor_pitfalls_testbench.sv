// copy_constructor_pitfalls_testbench.sv
module copy_constructor_testbench;
  import copy_constructor_pkg::*;

  initial begin
    // Dump waves
    $dumpfile("copy_constructor_testbench.vcd");
    $dumpvars(0, copy_constructor_testbench);
    
    $display("=== Copy Constructor Pitfalls Demo ===\n");
    
    // Test 1: Object Handle Sharing Pitfall (Real Shallow Copy Issue)
    $display("1. OBJECT HANDLE SHARING PITFALL:");
    $display("---------------------------------");
    begin
      ShallowCopyClass original = new("original");
      ShallowCopyClass shallow_copy;
      
      $display("Before shallow copy:");
      original.display("  ");
      
      shallow_copy = original.shallow_copy();
      shallow_copy.name = "shallow_copy";
      
      $display("After creating shallow copy:");
      original.display("  ");
      shallow_copy.display("  ");
      
      // Modify container through original - affects both objects!
      $display("Modifying container through original object...");
      original.modify_container(999);
      
      $display("After modifying container via original:");
      original.display("  ");
      shallow_copy.display("  "); // Shows same change - PITFALL!
      $display("  ^^ PITFALL: Both objects share same container handle!\n");
    end
    
    // Test 2: Correct Deep Copy with Object Handles
    $display("2. CORRECT DEEP COPY:");
    $display("--------------------");
    begin
      DeepCopyClass original = new("original");
      DeepCopyClass deep_copy;
      
      $display("Before deep copy:");
      original.display("  ");
      
      deep_copy = original.deep_copy();
      deep_copy.name = "deep_copy";
      
      $display("After creating deep copy:");
      original.display("  ");
      deep_copy.display("  ");
      
      // Modify container through original - doesn't affect copy
      $display("Modifying container through original object...");
      original.modify_container(999);
      
      $display("After modifying container via original:");
      original.display("  ");
      deep_copy.display("  "); // Remains unchanged - CORRECT!
      $display("  ^^ CORRECT: Objects have independent containers!\n");
    end
    
    // Test 3: Missing Copy Constructor Pitfall
    $display("3. MISSING COPY CONSTRUCTOR PITFALL:");
    $display("------------------------------------");
    begin
      NoCopyConstructorClass original = new("original");
      NoCopyConstructorClass attempted_copy;
      
      $display("Original object:");
      original.display("  ");
      
      // This is what users might try to do (doesn't work as expected)
      $display("Attempting: attempted_copy = original; (assignment)");
      attempted_copy = original;  // This just copies the handle!
      
      if (attempted_copy == original) begin
        $display("  ^^ PITFALL: Assignment copies handle, not object!");
        $display("  Both variables point to same object in memory!");
      end
      
      // Prove they're the same object
      $display("Modifying 'copy' affects original:");
      attempted_copy.name = "modified_via_copy";
      attempted_copy.modify_data(0, 777);
      
      $display("After modifying through 'copy':");
      original.display("  ");
      $display("  ^^ PITFALL: Original was modified too!\n");
    end
    
    // Test 4: Proper Copy Constructor
    $display("4. PROPER COPY CONSTRUCTOR:");
    $display("---------------------------");
    begin
      ProperCopyClass original = new("original");
      ProperCopyClass proper_copy;
      
      $display("Before proper copy:");
      original.display("  ");
      
      proper_copy = original.copy();  // Use explicit copy method
      proper_copy.name = "proper_copy";
      
      $display("After creating proper copy:");
      original.display("  ");
      proper_copy.display("  ");
      
      // Modify both array and container through original
      $display("Modifying original's data and container...");
      original.modify_data(0, 888);
      original.modify_container(777);
      
      $display("After modifications:");
      original.display("  ");
      proper_copy.display("  "); // Remains unchanged - CORRECT!
      $display("  ^^ CORRECT: Complete independence achieved!\n");
    end
    
    $display("=== Key Takeaways ===");
    $display("1. Object handles are shared in shallow copies - major pitfall");
    $display("2. Assignment (=) copies handles, not objects themselves");
    $display("3. Always provide explicit copy constructors/methods");
    $display("4. Deep copy must handle all object references recursively");
    $display("5. Arrays are deep-copied automatically in SystemVerilog");
    
    #1;
    $finish;
  end

endmodule