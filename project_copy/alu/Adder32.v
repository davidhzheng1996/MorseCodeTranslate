`ifndef Adder32_H
`define Adder32_H//to prevent repeated include
`include "common/CLA8bit.v"
module Adder32(a,b,c_in,sum,c_out);
input [31:0] a,b;
input c_in;
output [31:0] sum;
output c_out;

//implement 32bit adder using 4 8-bit CLA, 
//if cout of CLA block i is 1, then select the CLA adder that has cin as 1
//(a,b,c_in,sum,c_out);
wire[3:0] c_temp;
CLA8bit cla0(a[7:0],b[7:0],c_in,sum[7:0],c_temp[0]);

wire[3:0] c0,c1;//carry out from 0 block and 1 block
wire[23:0] sum0,sum1;
genvar  i;
generate
	for (i=1;i<4;i=i+1)//execute 3 times
	begin: loop0
		//if cout from previous block produces 1 then propagate block1,
		//otherwise use results from block0
		assign sum[i*8+7:i*8]=c_temp[i-1]?sum1[(i-1)*8+7:(i-1)*8]:sum0[(i-1)*8+7:(i-1)*8];
		assign c_temp[i]=c_temp[i-1]?c1[i-1]:c0[i-1];
		//calculate the sum of the 8ith bit to (8i+7)th bit with 0 carryin
		CLA8bit cla1(a[i*8+7:i*8],b[i*8+7:i*8],1'b0,
			sum0[(i-1)*8+7:(i-1)*8],c0[i-1]);
		//calculate the sum of the 8ith bit to (8i+7)th bit with 1 carryin
		CLA8bit cla2(a[i*8+7:i*8],b[i*8+7:i*8],1'b1,
			sum1[(i-1)*8+7:(i-1)*8],c1[i-1]);
	end
endgenerate

assign c_out = c_temp[3];

endmodule
`endif