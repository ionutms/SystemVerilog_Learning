// temperature_monitor.sv
module temperature_monitor_module;
  
  // Observer types
  typedef enum logic [1:0] {
    DISPLAY_TYPE = 2'b00,
    ALARM_TYPE   = 2'b01,
    INACTIVE     = 2'b10
  } observer_type_t;
  
  // Observer data structure
  typedef struct packed {
    observer_type_t obs_type;
    logic [31:0] threshold;
    logic active;
  } observer_t;
  
  // Temperature sensor with observer pattern
  parameter MAX_OBSERVERS = 4;
  observer_t observers [MAX_OBSERVERS-1:0];
  logic [31:0] observer_names [MAX_OBSERVERS-1:0];
  logic [31:0] observer_count;
  logic [31:0] current_temperature;
  
  // Observer management functions
  function void add_display_observer(logic [31:0] observer_id);
    if (observer_count < MAX_OBSERVERS) begin
      observers[observer_count[1:0]].obs_type = DISPLAY_TYPE;
      observers[observer_count[1:0]].threshold = 0;
      observers[observer_count[1:0]].active = 1'b1;
      observer_names[observer_count[1:0]] = observer_id;
      observer_count++;
      $display("Display observer %0d added. Total: %0d", 
               observer_id, observer_count);
    end else begin
      $display("Error: Maximum observers reached");
    end
  endfunction
  
  function void add_alarm_observer(logic [31:0] alarm_threshold);
    if (observer_count < MAX_OBSERVERS) begin
      observers[observer_count[1:0]].obs_type = ALARM_TYPE;
      observers[observer_count[1:0]].threshold = alarm_threshold;
      observers[observer_count[1:0]].active = 1'b1;
      observer_names[observer_count[1:0]] = 32'hA1A2;
      observer_count++;
      $display("Alarm observer added (threshold: %0d°C). Total: %0d", 
               alarm_threshold, observer_count);
    end else begin
      $display("Error: Maximum observers reached");
    end
  endfunction
  
  function void remove_observer(logic [31:0] observer_id);
    for (int i = 0; i < observer_count; i++) begin
      if (observers[i].active && observer_names[i] == observer_id) begin
        observers[i].active = 1'b0;
        // Shift remaining observers down
        for (int j = i; j < observer_count - 1; j++) begin
          observers[j] = observers[j + 1];
          observer_names[j] = observer_names[j + 1];
        end
        observer_count--;
        $display("Observer %0d removed. Total: %0d", observer_id, 
                 observer_count);
        return;
      end
    end
    $display("Observer %0d not found", observer_id);
  endfunction
  
  function void set_temperature(logic [31:0] new_temperature);
    current_temperature = new_temperature;
    notify_observers();
  endfunction
  
  function logic [31:0] get_temperature();
    return current_temperature;
  endfunction
  
  function void notify_observers();
    $display("\n--- Notifying %0d observers ---", observer_count);
    for (int i = 0; i < observer_count; i++) begin
      if (observers[i].active) begin
        case (observers[i].obs_type)
          DISPLAY_TYPE: begin
            $display("[Display_%0d] Temperature updated: %0d°C", 
                     observer_names[i], current_temperature);
          end
          ALARM_TYPE: begin
            if (current_temperature > observers[i].threshold)
              $display("[ALARM] High temperature: %0d°C (threshold: %0d°C)", 
                       current_temperature, observers[i].threshold);
            else
              $display("[ALARM] Temperature normal: %0d°C", 
                       current_temperature);
          end
          default: begin
            $display("[Unknown] Observer type not recognized");
          end
        endcase
      end
    end
    $display("--- Notification complete ---\n");
  endfunction
  
  // Initialize
  initial begin
    observer_count = 0;
    current_temperature = 0;
    for (int i = 0; i < MAX_OBSERVERS; i++) begin
      observers[i].active = 1'b0;
      observer_names[i] = 0;
    end
    $display("Temperature Monitor with Observer Pattern Initialized");
  end

endmodule