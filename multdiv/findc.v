//find the 2 bit used for booth selection
`ifndef findc_H
`define findc_H//to prevent repeated include
`include "common/decoder32.v"
module findc(B,ct,B_c1_c);//B_c1_c=B[ct+1:ct], 0 somewhere
     input [31:0] B;
     input [4:0] ct;
     output [1:0] B_c1_c;//current count
	  wire c1,c;
     assign B_c1_c = {c1,c};
     wire [32:0] B0;//just B with a 0 bit to the right of B's 0th bit
     assign B0 ={B,1'b0};
     wire[31:0] d_ct;//decoded ct
     decoder32 de(ct,d_ct);
     genvar i;
          generate
          for (i = 0; i <= 31; i = i + 1) begin: loop1
                   assign c1=d_ct[i]?B0[i+1]:1'bz;
                   assign c=d_ct[i]?B0[i]:1'bz;
          end
     endgenerate     

endmodule
`endif