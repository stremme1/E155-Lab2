// Emmett Stralka [estralka@hmc.edu]
// 09/03/25
// Lab2
module Lab2_ES (
    input  logic        reset,    
    input  logic [3:0]  s0,
    input  logic [3:0]  s1,      
    output logic [6:0]  seg,    // Multiplexed seven-segment signal
    output logic [4:0]  led,    // LEDs show sum of s0 + s1
    output logic        select0,
    output logic        select1  // Power multiplexing control (PNP transistor control)
);

    // Clock signal
    logic clk;
    // Internal high-speed oscillator
    HSOSC #(.CLKHF_DIV(2'b01)) 
          hf_osc (
              .CLKHFPU(1'b1),
              .CLKHFEN(1'b1),
              .CLKHF(clk)
          );

    // Internal signals
    logic [4:0] sum;
    logic [6:0] seg0_internal, seg1_internal;
    logic display_select;
    logic [23:0] divcnt;

    // Seven-segment display decoders (submodule ports: .num, .seg)
    seven_segment seven_segment0 (
        .num(s0),
        .seg(seg0_internal)
    );
    seven_segment seven_segment1 (
        .num(s1),
        .seg(seg1_internal)
    );

    // Multiplexer for signal multiplexing 
    // (submodule ports: .d0, .d1, .select, .y)
    MUX2 signal_mux (
        .d0(seg0_internal),
        .d1(seg1_internal),
        .select(display_select),
        .y(seg)
    );

    // Five-bit adder for LED display
    // (submodule ports: .s1, .s2, .sum)
    five_bit_adder adder(
        .s1(s0),
        .s2(s1),
        .sum(sum)
    );

    // Output assignments
    assign led = sum;      // LEDs show sum of s0 + s1

    // --- Power Multiplexing at 100 Hz ---
    // This controls which display is powered on
    localparam int HALF_PERIOD = 60_000; // for 12 MHz input clock

    always_ff @(posedge clk or negedge reset) begin
        if (~reset) begin            // Async active-low reset
            divcnt <= 0;
            display_select <= 0;
        end else if (divcnt == HALF_PERIOD - 1) begin
            divcnt <= 0;
            display_select <= ~display_select; // toggle between displays
        end else begin
            divcnt <= divcnt + 1;
        end
    end

    // Power multiplexing control for PNP resistors
    assign select0 = display_select;       // Controls PNP for Display 1 (s0)
    assign select1 = ~display_select;      // Controls PNP for Display 2 (s1), opposite phase

endmodule
