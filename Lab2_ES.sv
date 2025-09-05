// Emmett Stralka estralka@hmc.edu
// 09/03/25
// Lab2


module Lab2_ES (
    input  logic        clk,    
    input  logic [3:0]  s0,
    input  logic [3:0]  s1,      
    output logic [6:0]  seg,    // Multiplexed seven-segment signal
    output logic [4:0]  led,    // LEDs show sum of s0 + s1
    output logic        select  // Power multiplexing control (PNP transistor control)
);

    // Internal signals
    logic [4:0] sum;

    // --- Seven-segment display decoders ---
    logic [6:0] seg0_internal, seg1_internal;
    
    seven_segment seven_segment0 (
        s0,             // First display shows s0
        seg0_internal   // Internal signal for first display
    );

    seven_segment seven_segment1 (
        s1,             // Second display shows s1
        seg1_internal   // Internal signal for second display
    );

    // Multiplexer for signal multiplexing
    MUX2 signal_mux (
        seg0_internal,  // d0: first display segments
        seg1_internal,  // d1: second display segments
        select,         // sel: multiplexing control
        seg             // y: multiplexed output to both displays
    );

    // Five-bit adder for LED display
    five_bit_adder adder(
        s0,
        s1,
        sum
    );

    // Output assignments
    assign led = sum;      // LEDs show sum of s0 + s1




    // --- Power Multiplexing at 100 Hz ---
    // This controls which display is powered on
    localparam int HALF_PERIOD = 60_000; // for 12 MHz input clock
    logic [23:0] divcnt = 0;
    logic        display_select = 0;

    always_ff @(posedge clk) begin
        if (divcnt == HALF_PERIOD - 1) begin
            divcnt <= 0;
            display_select <= ~display_select; // toggle between displays
        end else begin
            divcnt <= divcnt + 1;
        end
    end

    // Power multiplexing control
    // select = 0: Display 1 (s0) is powered on
    // select = 1: Display 2 (s1) is powered on
    assign select = display_select;



endmodule
