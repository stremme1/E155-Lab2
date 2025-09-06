// Emmett Stralka estralka@hmc.edu
// 09/03/25
// Five bit adder: adds two 4-bit inputs to produce a 5-bit sum

module five_bit_adder (
  input  [3:0] s1,
  input  [3:0] s2,
  output [4:0] sum
);
  assign sum = s1 + s2;
endmodule
