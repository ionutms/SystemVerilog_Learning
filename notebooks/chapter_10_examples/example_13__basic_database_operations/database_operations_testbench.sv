// database_operations_testbench.sv
// Testbench for Chapter 10 Example 13: Basic Database Operations

module database_testbench;
  import database_pkg::*;
  
  // Instantiate the design under test
  database_operations DUT();
  
  // Test variables
  mysql_database mysql_db;
  sqlite_database sqlite_db;
  database_base db_handle;
  string query_result;
  bit connection_result;
  
  initial begin
    // Setup waveform dumping
    $dumpfile("database_testbench.vcd");
    $dumpvars(0, database_testbench);
    
    $display("=== Testing Database Operations ===");
    $display();
    
    // Test MySQL database
    $display("--- Testing MySQL Database ---");
    mysql_db = new("server=localhost;database=test;user=admin");
    
    // Test connection
    connection_result = mysql_db.connect();
    if (connection_result) begin
      $display("MySQL connection status: %s", 
               mysql_db.is_connection_active() ? "ACTIVE" : "INACTIVE");
    end
    
    // Test queries
    query_result = mysql_db.query("SELECT * FROM users");
    query_result = mysql_db.query("INSERT INTO users VALUES (1, 'John')");
    query_result = mysql_db.query("UPDATE users SET name='Jane' WHERE id=1");
    
    // Test disconnection
    mysql_db.disconnect();
    $display("MySQL connection status after disconnect: %s", 
             mysql_db.is_connection_active() ? "ACTIVE" : "INACTIVE");
    
    $display();
    
    // Test SQLite database
    $display("--- Testing SQLite Database ---");
    sqlite_db = new("./test_database.db");
    
    // Test connection
    connection_result = sqlite_db.connect();
    if (connection_result) begin
      $display("SQLite connection status: %s", 
               sqlite_db.is_connection_active() ? "ACTIVE" : "INACTIVE");
    end
    
    // Test queries
    query_result = sqlite_db.query("SELECT * FROM products");
    query_result = sqlite_db.query("INSERT INTO products VALUES (1, 'Widget')");
    query_result = sqlite_db.query("DELETE FROM products WHERE id=1");
    
    // Test disconnection
    sqlite_db.disconnect();
    $display("SQLite connection status after disconnect: %s", 
             sqlite_db.is_connection_active() ? "ACTIVE" : "INACTIVE");
    
    $display();
    
    // Test polymorphism - using base class handle
    $display("--- Testing Polymorphism ---");
    
    // Point to MySQL database
    db_handle = mysql_db;
    $display("Using base class handle with MySQL:");
    connection_result = db_handle.connect();
    query_result = db_handle.query("SELECT COUNT(*) FROM orders");
    db_handle.disconnect();
    
    $display();
    
    // Point to SQLite database
    db_handle = sqlite_db;
    $display("Using base class handle with SQLite:");
    connection_result = db_handle.connect();
    query_result = db_handle.query("SELECT COUNT(*) FROM inventory");
    db_handle.disconnect();
    
    $display();
    
    // Test error handling - query without connection
    $display("--- Testing Error Handling ---");
    query_result = mysql_db.query("SELECT * FROM test_table");
    query_result = sqlite_db.query("SELECT * FROM test_table");
    
    $display();
    $display("=== Database Operations Test Complete ===");
    
    #10;
    $finish;
  end
  
endmodule