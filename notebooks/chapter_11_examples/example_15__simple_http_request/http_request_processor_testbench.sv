// http_request_processor_testbench.sv
module http_request_testbench;
  import http_protocol_pkg::*;

  // Instantiate design under test
  http_request_processor HTTP_PROCESSOR_INSTANCE();

  // Test variables
  HttpRequest test_request;
  HttpHeader test_header;
  HttpBody test_body;
  string result_string;
  
  initial begin
    // Dump waves for Verilator
    $dumpfile("http_request_testbench.vcd");
    $dumpvars(0, http_request_testbench);
    
    $display("=== HTTP Request Processor Testbench ===\n");
    
    // Test 1: Individual Header class
    $display("Test 1: HTTP Header Class");
    test_header = new("Authorization", "Bearer token123");
    $display("Header: %s", test_header.to_string());
    $display("Valid: %s\n", test_header.is_valid() ? "Yes" : "No");
    
    // Test 2: Individual Body class
    $display("Test 2: HTTP Body Class");
    test_body = new("{\"status\": \"success\", \"data\": [1,2,3]}");
    $display("Body Info:");
    $display("%s\n", test_body.to_string());
    
    // Test 3: Complete HTTP Request - GET
    $display("Test 3: Complete GET Request");
    test_request = new("GET", "/health", "HTTP/1.1");
    test_request.add_header("Host", "localhost:8080");
    test_request.add_header("Connection", "keep-alive");
    test_request.add_header("Cache-Control", "no-cache");
    
    result_string = test_request.to_string();
    $display("GET Request:\n%s", result_string);
    $display("Headers: %0d, Valid: %s\n", 
             test_request.get_header_count(),
             test_request.is_valid() ? "Yes" : "No");
    
    // Test 4: Complete HTTP Request - POST with JSON
    $display("Test 4: POST Request with JSON Body");
    test_request = new("POST", "/api/login", "HTTP/1.1");
    test_request.add_header("Host", "secure.example.com");
    test_request.add_header("Content-Type", "application/json");
    test_request.add_header("Accept", "application/json");
    test_request.set_body("{\"username\": \"admin\", \"password\": \"secret\"}");
    
    result_string = test_request.to_string();
    $display("POST Request:\n%s", result_string);
    $display("Headers: %0d, Valid: %s\n", 
             test_request.get_header_count(),
             test_request.is_valid() ? "Yes" : "No");
    
    // Test 5: PUT Request with XML body
    $display("Test 5: PUT Request with XML Body");
    test_request = new("PUT", "/api/config/settings", "HTTP/1.1");
    test_request.add_header("Host", "config.example.com");
    test_request.add_header("Content-Type", "application/xml");
    test_request.add_header("Authorization", "Basic YWRtaW46cGFzcw==");
    test_request.set_body("<config><timeout>30</timeout></config>");
    
    result_string = test_request.to_string();
    $display("PUT Request:\n%s", result_string);
    $display("Headers: %0d, Valid: %s\n", 
             test_request.get_header_count(),
             test_request.is_valid() ? "Yes" : "No");
    
    // Test 6: Invalid request test
    $display("Test 6: Invalid Request Test");
    test_request = new("", "", "");  // Empty parameters
    $display("Empty Request Valid: %s", 
             test_request.is_valid() ? "Yes" : "No");
    
    $display("\n=== All HTTP Tests Completed Successfully ===");
    
    #10;  // Wait for simulation time
  end

endmodule