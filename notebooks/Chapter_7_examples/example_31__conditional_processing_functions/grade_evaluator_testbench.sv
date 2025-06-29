// grade_evaluator_testbench.sv
module grade_evaluator_testbench;

  // Instantiate design under test
  grade_evaluator_module GRADE_EVALUATOR_INSTANCE();

  initial begin
    // Dump waves
    $dumpfile("grade_evaluator_testbench.vcd");
    $dumpvars(0, grade_evaluator_testbench);

    $display("Testing conditional processing functions with multiple exits");
    $display("===========================================================");
    $display();

    // Test determine_letter_grade function - various exit points
    test_letter_grade_function();
    $display();

    // Test calculate_final_status function - complex conditional logic
    test_final_status_function();
    $display();

    $display("All conditional processing function tests completed!");
    $finish;
  end

  // Test task for letter grade function
  task test_letter_grade_function();
    string result;
    
    $display("Testing determine_letter_grade function:");
    $display("---------------------------------------");
    
    // Test edge cases and invalid inputs (early exits)
    result = GRADE_EVALUATOR_INSTANCE.determine_letter_grade(-5);
    $display("Score: -5   -> Grade: %s", result);
    
    result = GRADE_EVALUATOR_INSTANCE.determine_letter_grade(105);
    $display("Score: 105  -> Grade: %s", result);
    
    // Test various valid scores hitting different exit points
    result = GRADE_EVALUATOR_INSTANCE.determine_letter_grade(98);
    $display("Score: 98   -> Grade: %s", result);
    
    result = GRADE_EVALUATOR_INSTANCE.determine_letter_grade(95);
    $display("Score: 95   -> Grade: %s", result);
    
    result = GRADE_EVALUATOR_INSTANCE.determine_letter_grade(91);
    $display("Score: 91   -> Grade: %s", result);
    
    result = GRADE_EVALUATOR_INSTANCE.determine_letter_grade(88);
    $display("Score: 88   -> Grade: %s", result);
    
    result = GRADE_EVALUATOR_INSTANCE.determine_letter_grade(84);
    $display("Score: 84   -> Grade: %s", result);
    
    result = GRADE_EVALUATOR_INSTANCE.determine_letter_grade(81);
    $display("Score: 81   -> Grade: %s", result);
    
    result = GRADE_EVALUATOR_INSTANCE.determine_letter_grade(78);
    $display("Score: 78   -> Grade: %s", result);
    
    result = GRADE_EVALUATOR_INSTANCE.determine_letter_grade(75);
    $display("Score: 75   -> Grade: %s", result);
    
    result = GRADE_EVALUATOR_INSTANCE.determine_letter_grade(72);
    $display("Score: 72   -> Grade: %s", result);
    
    result = GRADE_EVALUATOR_INSTANCE.determine_letter_grade(65);
    $display("Score: 65   -> Grade: %s", result);
    
    result = GRADE_EVALUATOR_INSTANCE.determine_letter_grade(45);
    $display("Score: 45   -> Grade: %s", result);
  endtask

  // Test task for final status function
  task test_final_status_function();
    string result;
    
    $display("Testing calculate_final_status function:");
    $display("--------------------------------------");
    
    // Test invalid inputs (early exits)
    result = GRADE_EVALUATOR_INSTANCE.calculate_final_status(-10, 1'b0, 0);
    $display("Base:-10, Extra:No, Bonus:0  -> Status: %s", result);
    
    result = GRADE_EVALUATOR_INSTANCE.calculate_final_status(80, 1'b1, -5);
    $display("Base:80, Extra:Yes, Bonus:-5 -> Status: %s", result);
    
    // Test failing grade
    result = GRADE_EVALUATOR_INSTANCE.calculate_final_status(45, 1'b0, 0);
    $display("Base:45, Extra:No, Bonus:0   -> Status: %s", result);
    
    // Test barely passing
    result = GRADE_EVALUATOR_INSTANCE.calculate_final_status(62, 1'b0, 0);
    $display("Base:62, Extra:No, Bonus:0   -> Status: %s", result);
    
    // Test with extra credit helping
    result = GRADE_EVALUATOR_INSTANCE.calculate_final_status(55, 1'b1, 10);
    $display("Base:55, Extra:Yes, Bonus:10 -> Status: %s", result);
    
    // Test satisfactory performance
    result = GRADE_EVALUATOR_INSTANCE.calculate_final_status(76, 1'b0, 0);
    $display("Base:76, Extra:No, Bonus:0   -> Status: %s", result);
    
    // Test good performance
    result = GRADE_EVALUATOR_INSTANCE.calculate_final_status(85, 1'b0, 0);
    $display("Base:85, Extra:No, Bonus:0   -> Status: %s", result);
    
    // Test excellent performance
    result = GRADE_EVALUATOR_INSTANCE.calculate_final_status(94, 1'b0, 0);
    $display("Base:94, Extra:No, Bonus:0   -> Status: %s", result);
    
    // Test score capping with bonus
    result = GRADE_EVALUATOR_INSTANCE.calculate_final_status(95, 1'b1, 10);
    $display("Base:95, Extra:Yes, Bonus:10 -> Status: %s", result);
  endtask

endmodule