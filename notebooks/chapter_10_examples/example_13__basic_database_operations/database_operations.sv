// database_operations.sv
// Chapter 10 Example 13: Basic Database Operations

package database_pkg;

  // Base database class with pure virtual methods
  virtual class database_base;
    protected string connection_string;
    protected bit is_connected;
    
    function new(string conn_str);
      this.connection_string = conn_str;
      this.is_connected = 0;
    endfunction
    
    // Pure virtual methods that must be implemented by derived classes
    pure virtual function bit connect();
    pure virtual function string query(string sql_command);
    pure virtual function void disconnect();
    
    // Common method for all database types
    function bit is_connection_active();
      return this.is_connected;
    endfunction
    
    function string get_connection_string();
      return this.connection_string;
    endfunction
  endclass

  // MySQL database implementation
  class mysql_database extends database_base;
    
    function new(string conn_str);
      super.new(conn_str);
    endfunction
    
    virtual function bit connect();
      $display("[MySQL] Connecting to database: %s", connection_string);
      this.is_connected = 1;
      $display("[MySQL] Connection established successfully");
      return 1;
    endfunction
    
    virtual function string query(string sql_command);
      string result;
      if (!is_connected) begin
        $display("[MySQL] Error: Not connected to database");
        return "ERROR: Not connected";
      end
      
      $display("[MySQL] Executing query: %s", sql_command);
      
      // Simulate different query results
      if (sql_command.substr(0, 5) == "SELECT") begin
        result = "MySQL Result: Found 3 rows";
      end else if (sql_command.substr(0, 5) == "INSERT") begin
        result = "MySQL Result: 1 row inserted";
      end else if (sql_command.substr(0, 5) == "UPDATE") begin
        result = "MySQL Result: 2 rows updated";
      end else begin
        result = "MySQL Result: Query executed";
      end
      
      $display("[MySQL] Query result: %s", result);
      return result;
    endfunction
    
    virtual function void disconnect();
      if (is_connected) begin
        $display("[MySQL] Disconnecting from database");
        this.is_connected = 0;
        $display("[MySQL] Disconnected successfully");
      end else begin
        $display("[MySQL] Already disconnected");
      end
    endfunction
  endclass

  // SQLite database implementation
  class sqlite_database extends database_base;
    
    function new(string conn_str);
      super.new(conn_str);
    endfunction
    
    virtual function bit connect();
      $display("[SQLite] Opening database file: %s", connection_string);
      this.is_connected = 1;
      $display("[SQLite] Database file opened successfully");
      return 1;
    endfunction
    
    virtual function string query(string sql_command);
      string result;
      if (!is_connected) begin
        $display("[SQLite] Error: Database file not opened");
        return "ERROR: Not connected";
      end
      
      $display("[SQLite] Executing query: %s", sql_command);
      
      // Simulate different query results
      if (sql_command.substr(0, 5) == "SELECT") begin
        result = "SQLite Result: Found 5 rows";
      end else if (sql_command.substr(0, 5) == "INSERT") begin
        result = "SQLite Result: 1 row inserted";
      end else if (sql_command.substr(0, 5) == "DELETE") begin
        result = "SQLite Result: 1 row deleted";
      end else begin
        result = "SQLite Result: Query executed";
      end
      
      $display("[SQLite] Query result: %s", result);
      return result;
    endfunction
    
    virtual function void disconnect();
      if (is_connected) begin
        $display("[SQLite] Closing database file");
        this.is_connected = 0;
        $display("[SQLite] Database file closed successfully");
      end else begin
        $display("[SQLite] Database file already closed");
      end
    endfunction
  endclass

endpackage

module database_operations;
  import database_pkg::*;
  
  initial begin
    $display("=== Database Operations Example ===");
    $display();
  end
  
endmodule