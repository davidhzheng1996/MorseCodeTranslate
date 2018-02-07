`ifndef Comparer0_H
`define Comparer0_H//to prevent repeated include
module Comparer0(a,is0,Positive);
//compare a 32-bit number stictly to 0
input[31:0] a;
output is0,Positive;
wire[31:0] a;
wire is0,Positive;
//temperary wire that decide whether a is postive
wire tbd_pos,tbd_0;

//first rule out the possiblity of a being negative
//if a[MSB]==1, a<0 and a!=0
assign Positive=a[31]?1'b0:tbd_pos;//a is negative if the MSB is 1
assign is0=a[31]?1'b0:tbd_0;//a is not 0 if a is negative

//tbd part only works if a[MSB]==0, when a is positive
assign tbd_pos=is0?1'b0:1'b1;//if a!=0,then a>0

//if any bit is 1, a is not 0
wire[30:0] temp;
assign tbd_0=temp[30];//is 1 if every bit from 0 to 30 is 0
assign temp[0]=a[0]?1'b0:1'b1;
genvar  i;
generate
	for (i=1;i<31;i=i+1)//loop a from 1 to 30
	begin: loop0
		assign temp[i]=a[i]?1'b0:temp[i-1];
	end
endgenerate

endmodule
`endif