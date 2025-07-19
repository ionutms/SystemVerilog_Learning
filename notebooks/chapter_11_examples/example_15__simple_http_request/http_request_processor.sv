// http_request_processor.sv
package http_protocol_pkg;

  // HTTP Header class - represents key-value pairs
  class HttpHeader;
    string name;
    string value;

    function new(string name = "", string value = "");
      this.name = name;
      this.value = value;
    endfunction

    function string to_string();
      return $sformatf("%s: %s", name, value);
    endfunction

    function bit is_valid();
      return (name.len() > 0) && (value.len() > 0);
    endfunction
  endclass

  // HTTP Body class - represents request/response body
  class HttpBody;
    string content;
    int content_length;

    function new(string content = "");
      this.content = content;
      this.content_length = content.len();
    endfunction

    function string to_string();
      return $sformatf("Content-Length: %0d\n%s", 
                       content_length, content);
    endfunction

    function void set_content(string new_content);
      this.content = new_content;
      this.content_length = new_content.len();
    endfunction
  endclass

  // HTTP Request class - main class with nested structures
  class HttpRequest;
    string method;         // GET, POST, PUT, etc.
    string uri;           // Request URI
    string version;       // HTTP version
    HttpHeader headers[$]; // Dynamic array of headers
    HttpBody body;        // Request body

    function new(string method = "GET", string uri = "/", 
                 string version = "HTTP/1.1");
      this.method = method;
      this.uri = uri;
      this.version = version;
      this.body = new();
    endfunction

    function void add_header(string name, string value);
      HttpHeader header = new(name, value);
      headers.push_back(header);
    endfunction

    function void set_body(string content);
      body.set_content(content);
      // Automatically update Content-Length header
      add_header("Content-Length", $sformatf("%0d", content.len()));
    endfunction

    function string to_string();
      string result;
      
      // Request line
      result = $sformatf("%s %s %s\n", method, uri, version);
      
      // Headers
      foreach(headers[i]) begin
        if (headers[i].is_valid())
          result = {result, headers[i].to_string(), "\n"};
      end
      
      // Empty line between headers and body
      result = {result, "\n"};
      
      // Body (if present)
      if (body.content_length > 0)
        result = {result, body.content};
        
      return result;
    endfunction

    function bit is_valid();
      return (method.len() > 0) && (uri.len() > 0) && 
             (version.len() > 0);
    endfunction

    function int get_header_count();
      return headers.size();
    endfunction
  endclass

endpackage

// Main design module - HTTP Request Processor
module http_request_processor();
  import http_protocol_pkg::*;
  
  HttpRequest request;
  
  initial begin
    $display("=== HTTP Request Processor Example ===\n");
    
    // Create a simple GET request
    request = new("GET", "/api/users", "HTTP/1.1");
    request.add_header("Host", "api.example.com");
    request.add_header("User-Agent", "SystemVerilog/1.0");
    request.add_header("Accept", "application/json");
    
    $display("Simple GET Request:");
    $display("%s", request.to_string());
    $display("Valid: %s\n", request.is_valid() ? "Yes" : "No");
    
    // Create a POST request with body
    request = new("POST", "/api/users", "HTTP/1.1");
    request.add_header("Host", "api.example.com");
    request.add_header("User-Agent", "SystemVerilog/1.0");
    request.add_header("Content-Type", "application/json");
    request.set_body("{\"name\": \"John\", \"email\": \"john@example.com\"}");
    
    $display("POST Request with Body:");
    $display("%s", request.to_string());
    $display("Header Count: %0d", request.get_header_count());
    $display("Valid: %s\n", request.is_valid() ? "Yes" : "No");
  end

endmodule