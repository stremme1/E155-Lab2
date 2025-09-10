// Emmett Stralka estralka@hmc.edu
// 09/03/25
// Lab2_ES: Main module implementing a dual seven-segment display system with power multiplexing
module Lab2_ES (
    input  logic        clk,      // External clock input
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
    logic clk;                          // Internal high-speed oscillator clock

    // Internal high-speed oscillator
    HSOSC #(.CLKHF_DIV(2'b01)) 
          hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

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

    // --- Power Multiplexing at 100 Hz ---
    always_ff @(posedge clk or negedge reset) begin
        if (~reset) begin                    // Async active-low reset
            display_select <= 0;
        end else begin
            display_select <= ~display_select; // Toggle between displays
        end
    end

    // Power multiplexing control for PNP transistors
    assign select0 = display_select;       // Controls PNP for Display 0 (shows s0)
    assign select1 = ~display_select;      // Controls PNP for Display 1 (shows s1), opposite phase

endmodule
