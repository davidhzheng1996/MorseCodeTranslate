//N-width register with enable
//use low reset, so should be nrst being the reset sig
//syntax to call
//reg_n #($width) (clk,nrst,D,Q);
//reg_n #(.N(parameter width)) a32(clk,rst,A, result);
//reg_n #(parameter width) a32(clk,rst,A, result);
`ifndef reg_n_H
`define reg_n_H
`include "common/mydffe.v"
// `include "dir_name/mydffe.v"
module reg_n #(parameter N=32)
(clk,nrst,en,D,Q);
//parameter N indicates the width
input clk,nrst,en;
input [N-1:0] D;
output [N-1:0] Q;
	genvar c;
      generate
      for (c = 0; c <= N-1; c = c + 1) begin: loop1
        mydffe a_dff(.d(D[c]), .clk(clk),.clrn(nrst), .prn(1'b1), .ena(en),.q(Q[c]));
//how do u write prn as always high
      end
    endgenerate

endmodule
`endif
