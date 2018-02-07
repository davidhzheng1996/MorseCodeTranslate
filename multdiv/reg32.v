//a 32 bit register using d-flipflop IN parallel
//low rst trigger reset
`ifndef reg32_H
`define reg32_H
`include "common/mydffe.v"
module reg32 (CLK,nrst,D,Q);
    input CLK, nrst;
    input [31:0] D;
    output [31:0] Q;

    genvar c;
      generate
      for (c = 0; c <= 31; c = c + 1) begin: loop1
        mydffe a_dff(.d(D[c]), .clk(CLK),.clrn(nrst), .prn(1'b1), .ena(1'b1),.q(Q[c]));
//how do u write prn as always high
      end
    endgenerate

endmodule
`endif