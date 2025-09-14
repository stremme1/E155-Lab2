// Emmett Stralka estralka@hmc.edu
// 09/03/25
// Lab2_ES: Main module implementing a dual seven-segment display system with power multiplexing
module Lab2_ES (
    input  logic        clk,      // External clock input (12 MHz)
    input  logic        reset,    // Active-low reset signal
    input  logic [3:0]  s0,       // First 4-bit input number
    input  logic [3:0]  s1,       // Second 4-bit input number
    output logic [6:0]  seg,      // Multiplexed seven-segment signal
    output logic [4:0]  led,      // LEDs show sum of s0 + s1
    output logic        select0,  // Power multiplexing control for display 0 (PNP transistor)
    output logic        select1   // Power multiplexing control for display 1 (PNP transistor)
);

    // Internal signals
    logic [4:0] sum;                    // 5-bit sum from adder (s0 + s1)
    logic [3:0] muxed_input;            // Multiplexed input to seven-segment decoder
    logic display_select;               // Current display selection (0 or 1)
    logic [22:0] divcnt;                // Clock divider counter

    // 2-to-1 multiplexer for input selection to seven-segment decoder
    // Note: Using direct assignment since MUX2 is designed for 7-bit signals
    assign muxed_input = display_select ? s1 : s0;

    // seven-segment display decoder
    seven_segment seven_segment_decoder (
        .num(muxed_input),     // Input: multiplexed 4-bit number
        .seg(seg)              // Output: 7-segment pattern
    );

    // Five-bit adder to compute sum for LED display
    five_bit_adder adder(
        .s1(s0),    // First 4-bit input
        .s2(s1),    // Second 4-bit input
        .sum(sum)   // 5-bit sum output (handles carry)
    );

    // Output assignments
    assign led = sum;      // LEDs display the sum of s0 + s1 (5 bits)

    // --- Power Multiplexing at ~1 kHz ---
    // This controls which display is powered on to create the illusion of both being on
    localparam HALF_PERIOD = 6_000;   // Half period for 12 MHz input clock (1 kHz switching - much faster)

    // Clock divider for power multiplexing
    always @(posedge clk or negedge reset) begin
        if (~reset) begin              // Async active-low reset
            divcnt <= 0;
            display_select <= 0;
        end else if (divcnt >= HALF_PERIOD - 1) begin
            divcnt <= 0;
            display_select <= ~display_select; // Toggle between displays
        end else begin
            divcnt <= divcnt + 1;      // Increment counter
        end
    end

    // Power multiplexing control for PNP transistors
    // Use registered outputs to ensure proper phase relationship
    logic select0_reg, select1_reg;
    
    always_ff @(posedge clk or negedge reset) begin
        if (~reset) begin
            select0_reg <= 1'b0;
            select1_reg <= 1'b1;
        end else begin
            select0_reg <= display_select;
            select1_reg <= ~display_select;
        end
    end
    
    assign select0 = select0_reg;   // Controls PNP for Display 0 (shows s0)
    assign select1 = select1_reg;   // Controls PNP for Display 1 (shows s1), opposite phase

endmodule
