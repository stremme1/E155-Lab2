// Emmett Stralka estralka@hmc.edu
// 09/03/25
// Testbench for Lab2_ES module: Tests ONLY select0 and select1 multiplexing behavior


module Lab2_ES_tb();
    // Test signals
    logic clk;                             // Test clock
    logic reset;                           // Reset signal
    logic [3:0] s0, s1;                   // Input numbers
    logic [6:0] seg;                      // Seven-segment output
    logic [4:0] led;                      // LED output
    logic select0, select1;               // Power multiplexing signals (what we're testing)
    
    // Test control signals
    logic test_passed = 1'b1;             // Overall test result
    integer error_count = 0;              // Error counter
    
    // Generate test clock (fast enough to see multiplexing)
    always begin
        clk = 1; #5;  // 100 MHz clock
        clk = 0; #5;
    end
    
    // Instantiate device under test
    Lab2_ES dut(
        .clk(clk),
        .reset(reset),
        .s0(s0),
        .s1(s1),
        .seg(seg),
        .led(led),
        .select0(select0),
        .select1(select1)
    );
    
    // Initialize test sequence
    initial begin
        $display("=== Lab2_ES Multiplexing Testbench Starting ===");
        $display("Testing ONLY select0 and select1 multiplexing behavior");
        
        // Initialize all signals
        reset = 0;        // Start with reset asserted
        s0 = 4'b0000;     // Initialize inputs
        s1 = 4'b0000;
        
        // Release reset after a few clock cycles
        repeat(5) @(posedge clk);
        reset = 1;        // Release reset
        $display("Reset released at time %t", $time);
        
        // Wait for first select signal transition to establish baseline
        @(posedge select0 or posedge select1);
        $display("First select0 value: %b, select1: %b at time %t", select0, select1, $time);
        
        // Test different input combinations
        repeat(1000) @(posedge clk);  // Wait for several multiplexing cycles
        s0 = 4'b0101;     // Test with 5
        s1 = 4'b1010;     // Test with 10
        $display("Changed inputs: s0=%b, s1=%b at time %t", s0, s1, $time);
        
        repeat(1000) @(posedge clk);  // Wait for several multiplexing cycles
        s0 = 4'b1111;     // Test with 15
        s1 = 4'b1111;     // Test with 15
        $display("Changed inputs: s0=%b, s1=%b at time %t", s0, s1, $time);
        
        repeat(1000) @(posedge clk);  // Final observation period
        
        // Test completion
        if (test_passed && error_count == 0) begin
            $display("=== MULTIPLEXING TEST PASSED ===");
            $display("All select0/select1 multiplexing tests completed successfully");
        end else begin
            $display("=== MULTIPLEXING TEST FAILED ===");
            $display("Error count: %d", error_count);
        end
        
        $finish;
    end
    
    // Monitor select signal transitions for optimization analysis
    always @(posedge select0 or negedge select0) begin
        if (select0 !== 1'bx) begin  // Only log when signal is driven
            $display("Time %t: select0 transition to %b, select1=%b", $time, select0, select1);
        end
    end
    
    always @(posedge select1 or negedge select1) begin
        if (select1 !== 1'bx) begin  // Only log when signal is driven
            $display("Time %t: select1 transition to %b, select0=%b", $time, select1, select0);
        end
    end
    
    // Continuous assertion checking for select signals (combinational)
    always @(*) begin
        if (select0 !== 1'bx && select1 !== 1'bx) begin  // Only check when signals are driven
            // Verify select0 and select1 are always opposite (180-degree phase shift)
            if (select0 !== ~select1) begin
                $error("Phase relationship error: select0=%b, select1=%b (should be opposite)", select0, select1);
                error_count = error_count + 1;
                test_passed = 1'b0;
            end
        end
    end
    
    // Monitor for any X or Z values on select signals
    always @(select0, select1) begin
        if (select0 === 1'bx || select0 === 1'bz) begin
            $warning("select0 has invalid value: %b at time %t", select0, $time);
        end
        if (select1 === 1'bx || select1 === 1'bz) begin
            $warning("select1 has invalid value: %b at time %t", select1, $time);
        end
    end
    

endmodule
