// Emmett Stralka estralka@hmc.edu
// 09/03/25
// Testbench for MUX2 module

module MUX2_tb();
    logic [6:0] d0, d1, y, y_expected;
    logic select;
    logic [31:0] vectornum, errors;
    logic [21:0] testvectors[1000:0]; // d0(7) + d1(7) + select(1) + y_expected(7) = 22 bits

    // Instantiate device under test
    MUX2 dut(
        d0,
        d1,
        select,
        y
    );
    
    // Load test vectors and initialize
    initial begin
        $readmemb("MUX2.tv", testvectors);
        vectornum = 0; errors = 0;
    end
    
    // Apply test vectors and check results
    always begin
        #10; // Wait for propagation
        {d0, d1, select, y_expected} = testvectors[vectornum];
        
        #5; // Wait for additional propagation
        if (y !== y_expected) begin
            $display("Error at vector %0d: d0=%b d1=%b select=%b | y out %b expected %b", 
                      vectornum, d0, d1, select, y, y_expected);
            errors = errors + 1;
        end
        
        vectornum = vectornum + 1;
        if (testvectors[vectornum] === 22'bx) begin
            $display("%d tests completed with %d errors", vectornum, errors);
            $stop;
        end
    end
endmodule
