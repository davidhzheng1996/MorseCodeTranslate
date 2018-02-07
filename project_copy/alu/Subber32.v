`ifndef Subber32_H
`define Subber32_H//to prevent repeated include
`include "alu/Adder32.v"
module Subber32(a,b,difference,c_out);//gives result of a-b
//implement a 32-bit subbtractor using an adder module
input [31:0] a,b;
output [31:0] difference;
output c_out;
wire[31:0] a,b,difference,b_invert0;//,b_invert;//,b_invert1,b_comp;
reg[31:0] b_invert;
//invert b
//invert very bit in B

//this does not
genvar  i;
generate
	for (i=0;i<32;i=i+1)//loop a from 0 to 31
	begin: loop0
		
		not(b_invert0[i],b[i]);
	end
endgenerate

//this works
always @(*) begin
	b_invert=~b;
end

// not n(b_invert0,b);
//inefficiency
Adder32 complement(a,b_invert0,1'b1,difference,c_out);
//need to think about overflow

//b_invert=b[31]?b_invert1:b_invert0;
//b<0, b[31]==1
//b_invert1
//b>0, b[31]==0
//b_invert0

endmodule
`endif