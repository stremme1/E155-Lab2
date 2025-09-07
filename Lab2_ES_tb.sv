// Emmett Stralka estralka@hmc.edu
// 09/03/25
// TESTBENCH2=CLK: Clock testbench for Lab2_ES module

module Lab2_ES_tb();
    logic reset, clk;
    logic clk_signal, clk_signal_expected;
    logic [23:0] counter; 
  
    // Instantiate device under test
    justclk dut(reset, clk, clk_signal);
    
    // Generate clock
    always begin
        clk = 1; #20830; 
        clk = 0; #20830;
    end
    
    initial begin
        reset = 0; 
        #23830 
        reset = 1;
    end

    always_ff @(posedge clk, negedge reset) begin
        if(reset == 0) begin
            counter <= 0;
            clk_signal_expected <= 0;
        end else begin           
            if(counter == 23'd1_999) begin  //5M cycles to flip the LED
                counter <= 0;
                clk_signal_expected <= ~clk_signal_expected; //flip the LED
            end else begin
                counter <= counter + 1;
            end
        end 
    end 
    
    always_ff @(*) begin
        // Apply test vectors on rising edge
        assert (clk_signal == clk_signal_expected) else $error("Assertion failed clk_signal: %b %b", clk_signal, clk_signal_expected);
    end

endmodule

module justclk(
    input logic reset, clk,
    output logic clk_signal
);
    //Lab1 starter code: Blink at 2.4Hz

    logic [23:0] counter; //initializing counter
  
    // Counter
    always_ff @(posedge clk, negedge reset) begin
        if(reset == 0) begin
            counter <= 0;
            clk_signal <= 0;
        end else begin           
            if(counter == 23'd1_999) begin  //5M cycles to flip the LED
                counter <= 0;
                clk_signal <= ~clk_signal; //flip the LED
            end else begin
                counter <= counter + 1;
            end
        end
    end 
endmodule
