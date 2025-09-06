// Emmett Stralka estralka@hmc.edu
// 09/03/25
// 2-to-1 multiplexer: selects between two 7-bit inputs based on select signal

module MUX2 (
    input  logic [6:0] d0, d1, 
    input  logic       select, 
    output logic [6:0] y
);

  assign y = select ? d1 : d0; 
endmodule