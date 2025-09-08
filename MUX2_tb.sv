// Emmett Stralka estralka@hmc.edu
// 09/03/25
// Testbench for MUX2 module

module MUX2_tb();
    // Test signals
    logic [6:0] d0, d1, y, y_expected;     // Input and output test vectors
    logic select;                          // Select signal test vector
    logic [31:0] vectornum, errors;        // Test vector counter and error counter
    logic [21:0] testvectors[1000:0];     // Test vector array: d0(7) + d1(7) + select(1) + y_expected(7) = 22 bits

    // Instantiate device under test
    MUX2 dut(
        .d0(d0),
        .d1(d1),
        .select(select),
        .y(y)
    );

    // Load test vectors and initialize testbench
    initial begin
        $readmemb("MUX2.tv", testvectors);
        vectornum = 0; errors = 0;  // Initialize counters
    end
    
    // Apply test vectors and check results
    always begin
        #10; // Wait for signal propagation
        {d0, d1, select, y_expected} = testvectors[vectornum];
        
        #5; // Wait for additional propagation delay
        if (y !== y_expected) begin
            $display("Error at vector %0d: d0=%b d1=%b select=%b | output %b expected %b", 
                      vectornum, d0, d1, select, y, y_expected);
            errors = errors + 1;
        end
        
        vectornum = vectornum + 1;
        if (testvectors[vectornum] === 22'bx) begin
            $display("%d tests completed with %d errors", vectornum, errors);
            $finish;  // Finish simulation when all test vectors are processed
        end
    end
endmodule
