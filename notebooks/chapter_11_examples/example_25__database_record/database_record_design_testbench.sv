// database_record_design_testbench.sv
// Testbench for Chapter 11 Example 25: Database Record Copying Implications

module database_record_testbench;
  
  // Instantiate design under test
  database_record_module DESIGN_INSTANCE();
  
  initial begin
    // Setup VCD dumping
    $dumpfile("database_record_testbench.vcd");
    $dumpvars(0, database_record_testbench);
    
    $display("\n=== Chapter 11 Example 25: Database Record Copying ===");
    $display("Demonstrating copying implications with linked data\n");
    
    // Test 1: Create original user and database record
    $display("1. Creating original user and database record:");
    DESIGN_INSTANCE.create_user_record(1001, "Alice Johnson", 
                                       "alice@company.com");
    DESIGN_INSTANCE.create_database_record(501, "employees");
    DESIGN_INSTANCE.link_user_to_record(501, 1001);
    
    $display("\nOriginal state:");
    DESIGN_INSTANCE.display_database_record(501, "  ");
    
    // Test 2: Create a copy of the database record (shallow copy)
    $display("\n2. Creating copy of database record:");
    DESIGN_INSTANCE.copy_database_record(501, 502);
    
    $display("\nAfter copying (both records reference same user):");
    $display("Original record:");
    DESIGN_INSTANCE.display_database_record(501, "  ");
    $display("Copied record:");
    DESIGN_INSTANCE.display_database_record(502, "  ");
    
    // Test 3: Modify user data - affects both records
    $display("\n3. Modifying user email (affects both records):");
    DESIGN_INSTANCE.update_user_email(1001, "alice.johnson@company.com");
    
    $display("\nAfter modification - both records affected:");
    $display("Original record:");
    DESIGN_INSTANCE.display_database_record(501, "  ");
    $display("Copied record (notice email changed too!):");
    DESIGN_INSTANCE.display_database_record(502, "  ");
    
    // Test 4: Demonstrate proper deep copy approach
    $display("\n4. Demonstrating proper deep copy:");
    
    // Create new user with same data (deep copy of user)
    DESIGN_INSTANCE.create_user_record(1002, "Alice Johnson", 
                                       "alice.johnson@company.com");
    
    // Create new database record and link to new user
    DESIGN_INSTANCE.create_database_record(503, "employees");
    DESIGN_INSTANCE.link_user_to_record(503, 1002);
    
    $display("\nDeep copied record with independent user:");
    DESIGN_INSTANCE.display_database_record(503, "  ");
    
    // Test 5: Modify original user again to show independence
    $display("\n5. Modifying original user again:");
    DESIGN_INSTANCE.update_user_email(1001, "alice.new@company.com");
    
    $display("\nResults after modification:");
    $display("Original record (changed):");
    DESIGN_INSTANCE.display_database_record(501, "  ");
    $display("Shallow copied record (also changed):");
    DESIGN_INSTANCE.display_database_record(502, "  ");
    $display("Deep copied record (unchanged):");
    DESIGN_INSTANCE.display_database_record(503, "  ");
    
    // Test 6: Demonstrate multiple records sharing same user
    $display("\n6. Multiple records sharing same user:");
    DESIGN_INSTANCE.create_database_record(504, "projects");
    DESIGN_INSTANCE.create_database_record(505, "timesheets");
    DESIGN_INSTANCE.link_user_to_record(504, 1001);
    DESIGN_INSTANCE.link_user_to_record(505, 1001);
    
    $display("All records linked to user 1001:");
    DESIGN_INSTANCE.display_database_record(501, "  ");
    DESIGN_INSTANCE.display_database_record(502, "  ");
    DESIGN_INSTANCE.display_database_record(504, "  ");
    DESIGN_INSTANCE.display_database_record(505, "  ");
    
    $display("\n=== Key Learning Points ===");
    $display("- Shallow copy shares references to linked data");
    $display("- Changes to shared data affect all referencing records");
    $display("- Deep copy creates independent copies of linked data");
    $display("- Multiple records can reference the same shared data");
    $display("- Always consider data sharing implications in design");
    
    #10;
    $display("\nSimulation completed successfully!");
    $finish;
  end
  
endmodule