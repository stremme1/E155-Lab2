// Emmett Stralka estralka@hmc.edu
// 09/03/25
// Lab2


module Lab1_ES (
    input  logic        clk,    
    input  logic [3:0]  s0,
    input  logic [3:0]  s1,      
    output logic [6:0]  seg,    
    output logic [4:0]  led,
    output logic        select    
);


    logic [6:0] seg1, seg2, seg_out;


    // --- Seven-segment display decoder ---
    seven_segment seven_segment0 (
        s0,   // connects to num
        seg1  // connects to seg output
    );

    seven_segment seven_segment1 (
        s1,   // connects to num
        seg2  // connects to seg output
    );

    2xMUX 2xMUX (
        s0, s1, 
        select, 
        y
    );

    five_bit_adder five_bit_adder(
        s0,
        s1,
        sum
    );

    logic led = sum;

    // --- LEDs based on switch logic ---
    assign led[0] = sum[0];
    assign led[1] = sum[1];
    assign led[2] = sum[2];
    assign led[3] = sum[3];
    assign led[4] = sum[4];




    // --- Segments to Switch at 100 Hz ---
    localparam int HALF_PERIOD = 60_000; // for 12 MHz input clock
    logic [23:0] divcnt = 0;
    logic        blink_state = 0;

    always_ff @(posedge clk) begin
        if (divcnt == HALF_PERIOD - 1) begin
            divcnt <= 0;
            blink_state <= ~blink_state; // toggle LED
        end else begin
            divcnt <= divcnt + 1;
        end
    end

    assign select = blink_state;



endmodule
