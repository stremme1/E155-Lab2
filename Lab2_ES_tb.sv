// Emmett Stralka estralka@hmc.edu
// 09/03/25
// Testbench for Lab2_ES module

module Lab2_ES_tb();
    logic clk, reset;
    logic [3:0] s0, s1;
    logic [6:0] seg, seg_expected;
    logic [4:0] led, led_expected;
    logic select0, select1;
    logic [31:0] vectornum, errors;
    logic [26:0] testvectors[10000:0]; // Size for: s0(4) + s1(4) + seg_expected(7) + select0(1) + select1(1) + led(5) + led_expected(5) = 27 bits

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
    
    // Generate clock (12 MHz - same as main design input clock)
    always begin
        clk = 1; #41.67; clk = 0; #41.67; // 12 MHz = 83.33ns period, 41.67ns half period
    end

    // Load test vectors and initialize
    initial begin
        $readmemb("Lab2_ES.tv", testvectors);
        vectornum = 0; errors = 0;
        reset = 1;
        #100; // Hold reset for a few clock cycles
        reset = 0;
    end
    
    // Apply test vectors and check results
    always @(posedge clk) begin
        if (!reset) begin
            // Test vector format: {s0[3:0], s1[3:0], seg_expected[6:0], select0, select1, led[4:0], led_expected[4:0]}
            {s0, s1, seg_expected, select0, select1, led, led_expected} = testvectors[vectornum];
            
            // Wait for propagation
            #1;
            
            // Check LED output
            if (led !== led_expected) begin
                $display("Error at vector %0d: s0=%b s1=%b | led out %b expected %b", 
                          vectornum, s0, s1, led, led_expected);
                errors = errors + 1;
            end
            
            // Check seven-segment output
            if (seg !== seg_expected) begin
                $display("Error at vector %0d: s0=%b s1=%b | seg out %b expected %b", 
                          vectornum, s0, s1, seg, seg_expected);
                errors = errors + 1;
            end
            
            // Check PNP control signals (should be complementary)
            if (select0 === select1) begin
                $display("Error at vector %0d: select0 and select1 should be complementary! select0=%b select1=%b", 
                          vectornum, select0, select1);
                errors = errors + 1;
            end
            
            vectornum = vectornum + 1;
            if (testvectors[vectornum] === 27'bx) begin
                $display("%d tests completed with %d errors", vectornum, errors);
                $finish;
            end
        end
    end
endmodule
