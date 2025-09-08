// Emmett Stralka estralka@hmc.edu
// 09/03/25
// Testbench to compare actual select signals with expected signals

module select_signals_compare_tb();
    // Test signals
    logic clk;                             // Test clock
    logic select0, select1;                // Actual multiplexing signals
    logic select0_expected, select1_expected; // Expected signals
    
    // Test control
    logic test_passed = 1'b1;
    integer error_count = 0;
    
    // Generate test clock (100 MHz for simulation)
    always begin
        clk = 1; #5;  // 100 MHz clock
        clk = 0; #5;
    end
    
    // Instantiate the actual select signals generator
    select_signals_generator actual_signals (
        .clk(clk),
        .select0(select0),
        .select1(select1)
    );
    
    // Instantiate the expected signals generator
    select_signals_expected expected_signals (
        .clk(clk),
        .select0_expected(select0_expected),
        .select1_expected(select1_expected)
    );
    
    // Initialize and run test
    initial begin
        $display("=== Select Signals Comparison Testbench ===");
        $display("Comparing actual vs expected select0 and select1 signals");
        
        // Run for 100ms to see multiple cycles
        #100_000_000;  // 100ms at 100MHz
        
        if (test_passed && error_count == 0) begin
            $display("=== COMPARISON TEST PASSED ===");
            $display("All signals match expected values perfectly");
        end else begin
            $display("=== COMPARISON TEST FAILED ===");
            $display("Error count: %d", error_count);
        end
        
        $finish;
    end
    
    // Continuous comparison of actual vs expected signals
    always @(*) begin
        if (select0 !== select0_expected) begin
            $error("select0 mismatch: actual=%b, expected=%b at time %t", 
                   select0, select0_expected, $time);
            error_count = error_count + 1;
            test_passed = 1'b0;
        end
        
        if (select1 !== select1_expected) begin
            $error("select1 mismatch: actual=%b, expected=%b at time %t", 
                   select1, select1_expected, $time);
            error_count = error_count + 1;
            test_passed = 1'b0;
        end
    end
    
    // Monitor signal transitions
    always @(posedge select0) begin
        $display("Time %t: select0 -> 1, select1 -> 0 (expected: %b, %b)", 
                 $time, select0_expected, select1_expected);
    end
    
    always @(negedge select0) begin
        $display("Time %t: select0 -> 0, select1 -> 1 (expected: %b, %b)", 
                 $time, select0_expected, select1_expected);
    end

endmodule
