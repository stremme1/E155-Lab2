// Emmett Stralka estralka@hmc.edu
// 09/03/25
// Testbench for Lab2_ES module: Tests clock generation and power multiplexing functionality

module Lab2_ES_tb();
    // Test signals
    logic reset, clk;                      // Reset and clock signals
    logic clk_signal, clk_signal_expected; // Actual and expected clock output
    logic [23:0] counter;                  // Counter for clock division 
  
    // Instantiate device under test
    justclk dut(reset, clk, clk_signal);
    
    // Generate test clock (approximately 24 kHz)
    always begin
        clk = 1; #20830;  // Clock high for half period
        clk = 0; #20830;  // Clock low for half period
    end
    
    // Initialize reset sequence
    initial begin
        reset = 0;        // Start with reset asserted
        #23830            // Wait for initial setup
        reset = 1;        // Release reset
    end

    // Expected behavior model for verification
    always_ff @(posedge clk, negedge reset) begin
        if(reset == 0) begin
            counter <= 0;
            clk_signal_expected <= 0;
        end else begin           
            if(counter == 23'd1_999) begin  // 2000 cycles to toggle the output
                counter <= 0;
                clk_signal_expected <= ~clk_signal_expected; // Toggle the output
            end else begin
                counter <= counter + 1;
            end
        end 
    end 
    
    // Continuous assertion checking
    always_ff @(*) begin
        // Verify that actual output matches expected output
        assert (clk_signal == clk_signal_expected) else $error("Assertion failed clk_signal: %b %b", clk_signal, clk_signal_expected);
    end

endmodule

module justclk(
    input logic reset, clk,     // Reset and clock inputs
    output logic clk_signal     // Output clock signal
);
    // Clock divider module: Divides input clock to create slower output signal
    // Based on Lab1 starter code: Blink at 2.4Hz

    logic [23:0] counter;       // Counter for clock division
  
    // Clock divider: Counts input clock cycles and toggles output
    always_ff @(posedge clk, negedge reset) begin
        if(reset == 0) begin
            counter <= 0;
            clk_signal <= 0;
        end else begin           
            if(counter == 23'd1_999) begin  // 2000 cycles to toggle output
                counter <= 0;
                clk_signal <= ~clk_signal; // Toggle the output signal
            end else begin
                counter <= counter + 1;    // Increment counter
            end
        end
    end 
endmodule
