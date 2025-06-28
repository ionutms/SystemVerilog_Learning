// vector_math_operations_testbench.sv
module vector_math_testbench;

  // Instantiate design under test
  vector_math_calculator VECTOR_CALC_INSTANCE();

  // Import types from design module
  typedef struct packed {
    logic signed [15:0] x_component;
    logic signed [15:0] y_component;
    logic signed [15:0] z_component;
  } vector_3d_packed_t;

  typedef logic signed [15:0] vector_array_t [2:0];

  // Test variables
  vector_3d_packed_t first_test_vector, second_test_vector;
  vector_3d_packed_t addition_result;
  vector_array_t array_vector_a, array_vector_b;
  vector_array_t scaling_result;
  logic signed [31:0] dot_product_value;
  logic signed [7:0] multiplication_factor;

  initial begin
    // Setup VCD dumping
    $dumpfile("vector_math_testbench.vcd");
    $dumpvars(0, vector_math_testbench);

    $display("=== Vector Mathematics Operations Testbench ===");
    $display();

    // Test 1: Vector addition with packed structures
    $display("Test 1: Adding packed vectors");
    first_test_vector.x_component = 16'd10;
    first_test_vector.y_component = 16'd20;
    first_test_vector.z_component = 16'd30;
    
    second_test_vector.x_component = 16'd5;
    second_test_vector.y_component = 16'd15;
    second_test_vector.z_component = 16'd25;

    addition_result = VECTOR_CALC_INSTANCE.add_vectors_packed(
      first_test_vector, second_test_vector);
    
    $display("Vector A: (%0d, %0d, %0d)", 
             first_test_vector.x_component,
             first_test_vector.y_component,
             first_test_vector.z_component);
    $display("Vector B: (%0d, %0d, %0d)", 
             second_test_vector.x_component,
             second_test_vector.y_component,
             second_test_vector.z_component);
    $display("Sum Result: (%0d, %0d, %0d)", 
             addition_result.x_component,
             addition_result.y_component,
             addition_result.z_component);
    $display();

    // Test 2: Vector scaling with arrays
    $display("Test 2: Scaling vector using arrays");
    array_vector_a[0] = 16'd4;
    array_vector_a[1] = 16'd6;
    array_vector_a[2] = 16'd8;
    multiplication_factor = 8'd3;

    scaling_result = VECTOR_CALC_INSTANCE.scale_vector_array(
      array_vector_a, multiplication_factor);

    $display("Original Vector: [%0d, %0d, %0d]", 
             array_vector_a[0], array_vector_a[1], array_vector_a[2]);
    $display("Scale Factor: %0d", multiplication_factor);
    $display("Scaled Result: [%0d, %0d, %0d]", 
             scaling_result[0], scaling_result[1], scaling_result[2]);
    $display();

    // Test 3: Dot product calculation
    $display("Test 3: Computing dot product");
    array_vector_b[0] = 16'd2;
    array_vector_b[1] = 16'd3;
    array_vector_b[2] = 16'd4;

    dot_product_value = VECTOR_CALC_INSTANCE.compute_dot_product(
      array_vector_a, array_vector_b);

    $display("Vector A: [%0d, %0d, %0d]", 
             array_vector_a[0], array_vector_a[1], array_vector_a[2]);
    $display("Vector B: [%0d, %0d, %0d]", 
             array_vector_b[0], array_vector_b[1], array_vector_b[2]);
    $display("Dot Product: %0d", dot_product_value);
    $display();

    // Test 4: Format conversion
    $display("Test 4: Converting packed to array format");
    array_vector_a = VECTOR_CALC_INSTANCE.packed_to_array_converter(
      first_test_vector);
    
    $display("Packed Vector: (%0d, %0d, %0d)", 
             first_test_vector.x_component,
             first_test_vector.y_component,
             first_test_vector.z_component);
    $display("Converted Array: [%0d, %0d, %0d]", 
             array_vector_a[0], array_vector_a[1], array_vector_a[2]);

    $display();
    $display("=== All Vector Operations Tests Completed ===");

    #10 $finish;
  end

endmodule