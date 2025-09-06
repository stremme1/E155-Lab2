// Emmett Stralka estralka@hmc.edu
// 09/03/25
// Testbench for five_bit_adder module

module five_bit_adder_tb();
    logic [3:0] s1, s2;
    logic [4:0] sum, sum_expected;
    logic [31:0] vectornum, errors;
    logic [12:0] testvectors[1000:0]; // s1(4) + s2(4) + sum_expected(5) = 13 bits

    // Instantiate device under test
    five_bit_adder dut(
        s1,
        s2,
        sum
    );
    
    // Load test vectors and initialize
    initial begin
        $readmemb("five_bit_adder.tv", testvectors);
        vectornum = 0; errors = 0;
    end
    
    // Apply test vectors and check results
    always begin
        #10; // Wait for propagation
        {s1, s2, sum_expected} = testvectors[vectornum];
        
        #5; // Wait for additional propagation
        if (sum !== sum_expected) begin
            $display("Error at vector %0d: s1=%b s2=%b | sum out %b expected %b", 
                      vectornum, s1, s2, sum, sum_expected);
            errors = errors + 1;
        end
        
        vectornum = vectornum + 1;
        if (testvectors[vectornum] === 13'bx) begin
            $display("%d tests completed with %d errors", vectornum, errors);
            $stop;
        end
    end
endmodule
