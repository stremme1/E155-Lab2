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
        clk,
        s0,
        s1,
        seg,
        led,
        select0,
        select1
    );
    
    // Generate clock (12 MHz - same as main design input clock)
    always begin
        clk = 1; #41.67; clk = 0; #41.67; // 12 MHz = 83.33ns period, 41.67ns half period
    end

    // Clock divider to match the 100 Hz select signal rate
    localparam int HALF_PERIOD = 60_000; // Same as main design
    logic [23:0] divcnt = 0;
    logic test_clk = 0;

    always_ff @(posedge clk) begin
        if (divcnt == HALF_PERIOD - 1) begin
            divcnt <= 0;
            test_clk <= ~test_clk; // 100 Hz test clock
        end else begin
            divcnt <= divcnt + 1;
        end
    end
    
    // Load test vectors and initialize
    initial begin
        $readmemb("Lab2_ES_tb.tv", testvectors);
        // Strip underscores from test vectors for processing
        for (int i = 0; i < 10000; i++) begin
            if (testvectors[i] !== 27'bx) begin
                // Convert to string, remove underscores, convert back to binary
                string tv_str;
                $sformat(tv_str, "%b", testvectors[i]);
                tv_str = tv_str.replace("_", "");
                testvectors[i] = tv_str.atoi();
            end
        end
        vectornum = 0; errors = 0;
        reset = 1; #22; reset = 0;
    end
    
    // Apply test vectors on rising edge of 100 Hz test clock
    always @(posedge test_clk) begin
        if (!reset) begin
            // Test vector format: {s0[3:0], s1[3:0], seg_expected[6:0], select0, select1, led[4:0], led_expected[4:0]}
            {s0, s1, seg_expected, select0, select1, led, led_expected} = testvectors[vectornum];
        end
    end
    
    // Check results on falling edge of 100 Hz test clock
    always @(negedge test_clk) begin
        if (~reset) begin
            // Check LED output
            if (led !== led_expected) begin
                $display("Error at vector %0d: s0=%b s1=%b | led out %b expected %b", 
                          vectornum, s0, s1, led, led_expected);
                errors = errors + 1;
            end
            
            // Check seven-segment output (multiplexed)
            if (seg !== seg_expected) begin
                $display("Error at vector %0d: s0=%b s1=%b select0=%b select1=%b | seg out %b expected %b", 
                          vectornum, s0, s1, select0, select1, seg, seg_expected);
                errors = errors + 1;
            end
            
            // Check PNP control signals (phase relationship)
            if (select0 === select1) begin
                $display("Error at vector %0d: select0 and select1 should be opposite phases! select0=%b select1=%b", 
                          vectornum, select0, select1);
                errors = errors + 1;
            end
            
            vectornum = vectornum + 1;
            if (testvectors[vectornum] === 27'bx) begin
                $display("%d tests completed with %d errors", vectornum, errors);
                $stop;
            end
        end
    end
endmodule
