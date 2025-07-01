// multi_type_container.sv
module multi_type_container;

  // Enumeration for data types
  typedef enum logic [1:0] {
    TYPE_INTEGER = 2'b00,
    TYPE_STRING  = 2'b01,
    TYPE_FLOAT   = 2'b10,
    TYPE_EMPTY   = 2'b11
  } data_type_e;

  // Union for different data types
  typedef union packed {
    logic [63:0] integer_value;  // 64-bit to match union size
    logic [63:0] string_hash;    // 64-bit to match union size
    logic [63:0] float_bits;     // Store float as 64-bit pattern to match $realtobits
  } data_value_u;

  // Container structure
  typedef struct {
    data_type_e  data_type;
    data_value_u data_value;
    string       string_data; // Keep actual string separately
    real         float_data;  // Keep actual float separately
  } data_container_t;

  // Container instance
  data_container_t container;

  // Initialize container
  initial begin
    container.data_type = TYPE_EMPTY;
    container.string_data = "";
    container.float_data = 0.0;
  end

  // Function to store integer value
  function void store_integer(int value);
    container.data_type = TYPE_INTEGER;
    container.data_value.integer_value = 64'(value); // Explicit cast to 64-bit
    $display("Stored integer: %0d", value);
  endfunction

  // Function to store string value
  function void store_string(string value);
    container.data_type = TYPE_STRING;
    container.string_data = value;
    container.data_value.string_hash = 64'(value.len()); // Explicit cast to 64-bit
    $display("Stored string: %s", value);
  endfunction

  // Function to store float value
  function void store_float(real value);
    container.data_type = TYPE_FLOAT;
    container.float_data = value;
    container.data_value.float_bits = $realtobits(value);
    $display("Stored float: %0.2f", value);
  endfunction

  // Function to safely retrieve and display current value
  function void display_container();
    case (container.data_type)
      TYPE_INTEGER: begin
        $display("Container holds integer: %0d", 
                 int'(container.data_value.integer_value)); // Cast back to int for display
      end
      TYPE_STRING: begin
        $display("Container holds string: %s", container.string_data);
      end
      TYPE_FLOAT: begin
        $display("Container holds float: %0.2f", container.float_data);
      end
      TYPE_EMPTY: begin
        $display("Container is empty");
      end
      default: begin
        $display("Container holds unknown type");
      end
    endcase
  endfunction

  // Function to get container type as string
  function string get_container_type();
    case (container.data_type)
      TYPE_INTEGER: return "integer";
      TYPE_STRING:  return "string";
      TYPE_FLOAT:   return "float";
      TYPE_EMPTY:   return "empty";
      default:      return "unknown";
    endcase
  endfunction

  // Function to check if container is empty
  function bit is_empty();
    return (container.data_type == TYPE_EMPTY);
  endfunction

  // Function to clear container
  function void clear_container();
    container.data_type = TYPE_EMPTY;
    container.string_data = "";
    container.float_data = 0.0;
    $display("Container cleared");
  endfunction

endmodule