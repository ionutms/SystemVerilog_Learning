// generic_data_container.sv
// Generic data storage using tagged unions for various data formats

module data_container_module ();

  // Define data types that can be stored
  typedef enum {
    DATA_INTEGER,
    DATA_REAL,
    DATA_STRING,
    DATA_BITS
  } data_type_t;

  // Union for storing different data formats
  typedef union packed {
    int       integer_data;       // Integer storage
    bit [31:0] bits_data;        // Bit vector storage
  } storage_data_t;
  
  // Separate storage for non-packed types
  typedef struct {
    real      real_value;         // Real number storage
    string    string_value;       // String storage
  } extended_data_t;

  // Container structure with metadata
  typedef struct {
    data_type_t     data_type;      // Type identifier
    string          label;          // Data label/name
    time            timestamp;      // Creation timestamp
    storage_data_t  data;          // Packed data (int/bits)
    extended_data_t ext_data;      // Extended data (real/string)
  } data_container_t;

  // Storage array for multiple containers
  data_container_t storage_array[10];
  int storage_count = 0;

  // Function to store integer data
  function void store_integer(string label_name, int value);
    if (storage_count < 10) begin
      storage_array[storage_count].data_type = DATA_INTEGER;
      storage_array[storage_count].label = label_name;
      storage_array[storage_count].timestamp = $time;
      storage_array[storage_count].data.integer_data = value;
      storage_count++;
      $display("Stored integer: %s = %0d at time %0t", 
               label_name, value, $time);
    end
  endfunction

  // Function to store real data
  function void store_real(string label_name, real value);
    if (storage_count < 10) begin
      storage_array[storage_count].data_type = DATA_REAL;
      storage_array[storage_count].label = label_name;
      storage_array[storage_count].timestamp = $time;
      storage_array[storage_count].ext_data.real_value = value;
      storage_count++;
      $display("Stored real: %s = %0.2f at time %0t", 
               label_name, value, $time);
    end
  endfunction

  // Function to store string data
  function void store_string(string label_name, string value);
    if (storage_count < 10) begin
      storage_array[storage_count].data_type = DATA_STRING;
      storage_array[storage_count].label = label_name;
      storage_array[storage_count].timestamp = $time;
      storage_array[storage_count].ext_data.string_value = value;
      storage_count++;
      $display("Stored string: %s = '%s' at time %0t", 
               label_name, value, $time);
    end
  endfunction

  // Function to store bit vector data
  function void store_bits(string label_name, bit [31:0] value);
    if (storage_count < 10) begin
      storage_array[storage_count].data_type = DATA_BITS;
      storage_array[storage_count].label = label_name;
      storage_array[storage_count].timestamp = $time;
      storage_array[storage_count].data.bits_data = value;
      storage_count++;
      $display("Stored bits: %s = 0x%08h at time %0t", 
               label_name, value, $time);
    end
  endfunction

  // Function to retrieve and display stored data
  function void display_storage();
    $display("\n=== Data Container Storage Report ===");
    for (int i = 0; i < storage_count; i++) begin
      $display("Index %0d: Label='%s', Time=%0t", 
               i, storage_array[i].label, storage_array[i].timestamp);
      
      case (storage_array[i].data_type)
        DATA_INTEGER: begin
          $display("  Type: INTEGER, Value: %0d", 
                   storage_array[i].data.integer_data);
        end
        DATA_REAL: begin
          $display("  Type: REAL, Value: %0.2f", 
                   storage_array[i].ext_data.real_value);
        end
        DATA_STRING: begin
          $display("  Type: STRING, Value: '%s'", 
                   storage_array[i].ext_data.string_value);
        end
        DATA_BITS: begin
          $display("  Type: BITS, Value: 0x%08h", 
                   storage_array[i].data.bits_data);
        end
      endcase
      $display();
    end
  endfunction

  initial begin
    $display("Generic Data Storage Container Example");
    $display("=====================================");
    
    // Store different types of data
    #10 store_integer("counter_value", 42);
    #10 store_real("voltage_level", 3.14);
    #10 store_string("device_name", "FPGA_Board");
    #10 store_bits("control_reg", 32'hDEADBEEF);
    #10 store_integer("temperature", -25);
    
    // Display all stored data
    #10 display_storage();
  end

endmodule