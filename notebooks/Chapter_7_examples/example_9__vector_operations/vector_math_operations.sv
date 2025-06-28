// vector_math_operations.sv
module vector_math_calculator();

  // Define packed structure for 3D vector
  typedef struct packed {
    logic signed [15:0] x_component;
    logic signed [15:0] y_component;
    logic signed [15:0] z_component;
  } vector_3d_packed_t;

  // Define array type for vector operations
  typedef logic signed [15:0] vector_array_t [2:0];

  // Function: Add two 3D vectors returning packed structure
  function vector_3d_packed_t add_vectors_packed(
    input vector_3d_packed_t first_vector,
    input vector_3d_packed_t second_vector
  );
    vector_3d_packed_t result_vector;
    result_vector.x_component = first_vector.x_component + 
                               second_vector.x_component;
    result_vector.y_component = first_vector.y_component + 
                               second_vector.y_component;
    result_vector.z_component = first_vector.z_component + 
                               second_vector.z_component;
    return result_vector;
  endfunction

  // Function: Multiply vector by scalar returning array
  function vector_array_t scale_vector_array(
    input vector_array_t input_vector,
    input logic signed [7:0] scale_factor
  );
    vector_array_t scaled_result;
    scaled_result[0] = input_vector[0] * scale_factor;
    scaled_result[1] = input_vector[1] * scale_factor;
    scaled_result[2] = input_vector[2] * scale_factor;
    return scaled_result;
  endfunction

  // Function: Calculate dot product returning single value
  function logic signed [31:0] compute_dot_product(
    input vector_array_t vector_a,
    input vector_array_t vector_b
  );
    logic signed [31:0] dot_product_result;
    dot_product_result = (vector_a[0] * vector_b[0]) +
                        (vector_a[1] * vector_b[1]) +
                        (vector_a[2] * vector_b[2]);
    return dot_product_result;
  endfunction

  // Function: Convert packed to array format
  function vector_array_t packed_to_array_converter(
    input vector_3d_packed_t packed_vector
  );
    vector_array_t array_result;
    array_result[0] = packed_vector.x_component;
    array_result[1] = packed_vector.y_component;
    array_result[2] = packed_vector.z_component;
    return array_result;
  endfunction

  initial begin
    $display("Vector Operations Functions Module Loaded");
    $display("Supports: Addition, Scaling, Dot Product, Conversion");
  end

endmodule