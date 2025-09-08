// Emmett Stralka estralka@hmc.edu
// 09/03/25
// Expected select0 and select1 signals module - generates the exact expected waveforms

module select_signals_expected(
    input  logic clk,                    // Clock input
    output logic select0_expected,       // Expected select0 signal
    output logic select1_expected        // Expected select1 signal
);
    
    // Generate select0 and select1 signals at 100Hz
    // 100Hz = 10ms period, so 5ms high, 5ms low
    // With 100MHz clock: 5ms = 500,000 clock cycles
    localparam int HALF_PERIOD = 500_000;  // 5ms at 100MHz
    
    logic [19:0] counter;                  // Counter for 100Hz generation
    
    always_ff @(posedge clk) begin
        if (counter == HALF_PERIOD - 1) begin
            counter <= 0;
            select0_expected <= ~select0_expected;  // Toggle select0
        end else begin
            counter <= counter + 1;
        end
    end
    
    // select1 is always opposite of select0 (180-degree phase shift)
    assign select1_expected = ~select0_expected;
    
    // Initialize select0 to 0 (so select1 starts at 1)
    initial begin
        select0_expected = 1'b0;
        counter = 0;
    end

endmodule
