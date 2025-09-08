// Emmett Stralka estralka@hmc.edu
// 09/03/25
// Five bit adder: adds two 4-bit inputs to produce a 5-bit sum

module five_bit_adder (
  input  [3:0] s1,    // First 4-bit input number
  input  [3:0] s2,    // Second 4-bit input number
  output [4:0] sum    // 5-bit sum output (handles carry from 4+4 bit addition)
);
  // Simple addition: s1 + s2, result can be up to 5 bits due to carry
  assign sum = s1 + s2;
endmodule
