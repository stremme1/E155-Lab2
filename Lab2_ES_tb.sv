// Emmett Stralka estralka@hmc.edu
// 09/03/25
// TESTBENCH2=CLK: Clock testbench for Lab2_ES module


module Lab2_ES_tb();
    logic reset, clk;
    logic [3:0] s0, s1;
    logic [6:0] seg, seg_expected;
    logic [4:0] led, led_expected;
    logic select0, select1;
    logic [23:0] counter; //initializing counter
  
    // Instantiate device under test
    Lab2_ES dut(reset, clk, s0, s1, seg, led, select0, select1);
    
    // Generate clock
    always begin
        clk = 1; #41.67; 
        clk = 0; #41.67;
    end
	
    initial begin
        reset = 0; 
        s0 = 4'b0000;
        s1 = 4'b0000;
        #100; 
        reset = 1;
    end

    always_ff @(posedge clk, negedge reset) begin
        if(reset == 0) begin
            counter <= 0;
            seg_expected <= 7'b1000000;
            led_expected <= 5'b00000;
        end else begin           
            if(counter == 23'd1_999) begin  //5M cycles to flip the LED
                counter <= 0;
                seg_expected <= ~seg_expected; //flip the segment
                led_expected <= ~led_expected; //flip the LED
            end else begin
                counter <= counter + 1;
            end
        end 
    end 
	
    always_ff @(*) begin
        // Apply test vectors on rising edge
        assert (seg == seg_expected) else $error("Assertion failed seg: %b %b", seg, seg_expected);
        assert (led == led_expected) else $error("Assertion failed led: %b %b", led, led_expected);
        assert (select0 !== select1) else $error("Assertion failed select signals: %b %b", select0, select1);
    end

endmodule
