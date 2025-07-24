// database_record_design.sv
// Chapter 11 Example 25: Simple Database Record with Linked Data

module database_record_module;
  
  // User record structure using packed struct
  typedef struct packed {
    bit [31:0] user_id;
    bit [31:0] name_len;
    bit [31:0] email_len;
    bit        valid;
  } user_record_t;
  
  // Database record structure with reference to user
  typedef struct packed {
    bit [31:0]     record_id;
    bit [31:0]     table_name_len;
    bit [31:0]     linked_user_id;  // Reference by ID instead of pointer
    bit            active;
    bit            has_linked_user;
  } database_record_t;
  
  // Memory arrays to simulate database storage
  user_record_t     user_storage[1100:0];    // User records storage
  string            user_names[1100:0];      // User names (separate array)
  string            user_emails[1100:0];     // User emails (separate array)
  database_record_t db_records[600:0];       // Database records storage
  string            table_names[600:0];      // Table names (separate array)
  
  // Initialize arrays
  initial begin
    for (int i = 0; i <= 1100; i++) begin
      user_storage[i].valid = 0;
    end
    for (int i = 0; i <= 600; i++) begin
      db_records[i].active = 0;
    end
  end
  
  // Task to create a user record
  task create_user_record(
    input int user_id,
    input string name,
    input string email
  );
    user_storage[user_id].user_id = user_id;
    user_storage[user_id].name_len = name.len();
    user_storage[user_id].email_len = email.len();
    user_storage[user_id].valid = 1;
    user_names[user_id] = name;
    user_emails[user_id] = email;
    $display("Created user record: ID=%0d, Name=%s, Email=%s", 
             user_id, name, email);
  endtask
  
  // Task to create a database record
  task create_database_record(
    input int record_id,
    input string table_name
  );
    db_records[record_id].record_id = record_id;
    db_records[record_id].table_name_len = table_name.len();
    db_records[record_id].linked_user_id = 0;
    db_records[record_id].active = 1;
    db_records[record_id].has_linked_user = 0;
    table_names[record_id] = table_name;
    $display("Created database record: ID=%0d, Table=%s", 
             record_id, table_name);
  endtask
  
  // Task to link user to database record
  task link_user_to_record(
    input int record_id,
    input int user_id
  );
    if (user_storage[user_id].valid && db_records[record_id].active) begin
      db_records[record_id].linked_user_id = user_id;
      db_records[record_id].has_linked_user = 1;
      $display("Linked user %0d (%s) to record %0d", 
               user_id, user_names[user_id], record_id);
    end else begin
      $display("ERROR: Cannot link - User %0d valid=%b, Record %0d active=%b", 
               user_id, user_storage[user_id].valid, 
               record_id, db_records[record_id].active);
    end
  endtask
  
  // Task to update user email (affects all linked records)
  task update_user_email(
    input int user_id,
    input string new_email
  );
    if (user_storage[user_id].valid) begin
      user_emails[user_id] = new_email;
      user_storage[user_id].email_len = new_email.len();
      $display("Updated email for user %0d to: %s", user_id, new_email);
      $display("  This affects ALL records linked to this user!");
    end else begin
      $display("ERROR: Invalid user ID %0d", user_id);
    end
  endtask
  
  // Task to copy database record (shallow copy - shares user reference)
  task copy_database_record(
    input int source_record_id,
    input int dest_record_id
  );
    db_records[dest_record_id] = db_records[source_record_id];
    db_records[dest_record_id].record_id = dest_record_id;
    table_names[dest_record_id] = table_names[source_record_id];
    $display("Copied record %0d to %0d (SHALLOW COPY - shares user link)", 
             source_record_id, dest_record_id);
  endtask
  
  // Task to display user record
  task display_user_record(input int user_id, input string prefix);
    if (user_storage[user_id].valid) begin
      $display("%sUser ID: %0d, Name: %s, Email: %s", 
               prefix, user_id, user_names[user_id], user_emails[user_id]);
    end else begin
      $display("%sUser ID: %0d - INVALID", prefix, user_id);
    end
  endtask
  
  // Task to display database record
  task display_database_record(input int record_id, input string prefix);
    if (db_records[record_id].active) begin
      $display("%sRecord ID: %0d, Table: %s, Active: %b", 
               prefix, record_id, table_names[record_id], 
               db_records[record_id].active);
      if (db_records[record_id].has_linked_user) begin
        $display("%s  Linked User:", prefix);
        display_user_record(db_records[record_id].linked_user_id, 
                           {prefix, "    "});
      end else begin
        $display("%s  No linked user", prefix);
      end
    end else begin
      $display("%sRecord ID: %0d - INACTIVE", prefix, record_id);
    end
  endtask
  
  initial begin
    $display("Database Record Design Module Loaded");
    $display("Initializing storage arrays...");
  end
  
endmodule