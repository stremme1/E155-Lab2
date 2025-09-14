// Emmett Stralka estralka@hmc.edu
// 09/03/25
// HSOC: High-Speed Oscillator Clock module for iCE40 FPGA
// This module provides a high-frequency internal oscillator

module HSOC (
    input  logic CLKHFEN,    // Clock enable signal
    input  logic CLKHFPU,    // Clock power-up signal
    output logic CLKHF       // High-frequency clock output
);

    // Parameter for clock division (2'b01 = divide by 2)
    parameter CLKHF_DIV = 2'b01;

    // Internal oscillator implementation
    // Note: This is a simplified model for simulation
    // In actual iCE40 FPGA, this would use the internal HF oscillator
    logic internal_clk;
    
    // Generate internal clock (simplified for simulation)
    always begin
        if (CLKHFEN && CLKHFPU) begin
            internal_clk = 1'b1;
            #1;  // 1ns high time
            internal_clk = 1'b0;
            #1;  // 1ns low time
        end else begin
            internal_clk = 1'b0;
            #2;  // Wait when disabled
        end
    end
    
    // Apply clock division if needed
    generate
        if (CLKHF_DIV == 2'b01) begin
            // Divide by 2
            logic div_clk;
            always_ff @(posedge internal_clk) begin
                div_clk <= ~div_clk;
            end
            assign CLKHF = div_clk;
        end else begin
            // No division
            assign CLKHF = internal_clk;
        end
    endgenerate

endmodule
