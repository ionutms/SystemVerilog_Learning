// grade_evaluator.sv
module grade_evaluator_module;

  // Function with complex conditional logic and multiple exit points
  function automatic string determine_letter_grade(input int numeric_score);
    // Early exit for invalid scores
    if (numeric_score < 0) begin
      return "INVALID_NEGATIVE";
    end
    
    if (numeric_score > 100) begin
      return "INVALID_EXCEEDS";
    end
    
    // Complex conditional logic with multiple exit points
    if (numeric_score >= 90) begin
      if (numeric_score >= 97) begin
        return "A+";  // Exit point 1
      end else if (numeric_score >= 93) begin
        return "A";   // Exit point 2
      end else begin
        return "A-";  // Exit point 3
      end
    end else if (numeric_score >= 80) begin
      if (numeric_score >= 87) begin
        return "B+";  // Exit point 4
      end else if (numeric_score >= 83) begin
        return "B";   // Exit point 5
      end else begin
        return "B-";  // Exit point 6
      end
    end else if (numeric_score >= 70) begin
      if (numeric_score >= 77) begin
        return "C+";  // Exit point 7
      end else if (numeric_score >= 73) begin
        return "C";   // Exit point 8
      end else begin
        return "C-";  // Exit point 9
      end
    end else if (numeric_score >= 60) begin
      return "D";     // Exit point 10
    end else begin
      return "F";     // Exit point 11
    end
  endfunction

  // Function with pass/fail determination and conditional bonus
  function automatic string calculate_final_status(input int base_score,
                                                  input bit extra_credit_flag,
                                                  input int bonus_points);
    int adjusted_score;
    string letter_grade;
    
    // Early exit for invalid inputs
    if (base_score < 0 || bonus_points < 0) begin
      return "ERROR_INVALID_INPUT";
    end
    
    // Calculate adjusted score with conditional logic
    adjusted_score = base_score;
    if (extra_credit_flag) begin
      adjusted_score = adjusted_score + bonus_points;
      if (adjusted_score > 100) begin
        adjusted_score = 100;  // Cap at 100
      end
    end
    
    // Get letter grade using the other function
    letter_grade = determine_letter_grade(adjusted_score);
    
    // Multiple exit points based on performance
    if (letter_grade == "F") begin
      return "FAIL_RETAKE_REQUIRED";
    end else if (letter_grade == "D") begin
      return "PASS_BARELY_ACCEPTABLE";
    end else if (letter_grade[0] == "C") begin
      return "PASS_SATISFACTORY";
    end else if (letter_grade[0] == "B") begin
      return "PASS_GOOD_WORK";
    end else if (letter_grade[0] == "A") begin
      return "PASS_EXCELLENT";
    end else begin
      return "ERROR_UNKNOWN_GRADE";
    end
  endfunction

  initial begin
    $display("Grade Evaluator - Conditional Processing Functions Demo");
    $display("=========================================================");
    $display();
  end

endmodule