// Emmett Stralka estralka@hmc.edu
// 09/03/25
// Mux with two input ont output

module 2xMUX ()
             (input  logic [6:0] d0, d1, 
              input  logic       sel, 
              output logic [6:0] y);

  assign y = sel ? d1 : d0; 
endmodule