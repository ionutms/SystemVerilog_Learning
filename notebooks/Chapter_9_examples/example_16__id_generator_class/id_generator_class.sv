// id_generator_class.sv
// ID Generator Class using static properties for unique IDs and object count

class id_generator_class;
  // Static properties - shared across all instances
  static int next_id = 1;           // Next ID to assign
  static int total_objects = 0;     // Total objects created
  
  // Instance properties
  int object_id;                    // Unique ID for this instance
  string object_name;               // Name of the object
  
  // Constructor
  function new(string name = "unnamed");
    object_id = next_id++;          // Assign unique ID and increment
    object_name = name;             // Set object name
    total_objects++;                // Increment total object count
    
    $display("Created object: %s with ID: %0d", object_name, object_id);
  endfunction
  
  // Static function to get total object count
  static function int get_total_objects();
    return total_objects;
  endfunction
  
  // Static function to get next ID that will be assigned
  static function int get_next_id();
    return next_id;
  endfunction
  
  // Instance method to display object info
  function void display_info();
    $display("Object Info - Name: %s, ID: %0d", object_name, object_id);
  endfunction
  
  // Static function to display class statistics
  static function void display_statistics();
    $display("=== ID Generator Statistics ===");
    $display("Total objects created: %0d", total_objects);
    $display("Next ID to assign: %0d", next_id);
    $display("===============================");
  endfunction
  
endclass