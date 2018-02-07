`ifndef CLA8bit_H
`define CLA8bit_H
module CLA8bit//CarryLookaheadAdder
(a,b,c_in,sum,c_out);

input [7:0] a,b;
input c_in;
output [7:0] sum;
output c_out;

wire [7:0] sum, p, g, P, G;
wire [8:0] c;
wire c_out;
//or (out,in1,in2,in3)
integer N=8;
//for a full adder
//s=a^b^c, odd parity check
//cout=(a^b)&cin+a&b
genvar  i;
generate
	for (i=0;i<8;i=i+1)
	begin: loop1
		// Generate all ps and gs
		xor (p[i], a[i], b[i]);//p[i]=a[i]^b[i]
		and (g[i], a[i], b[i]);//g[i]=a[i]&b[i]
	end
endgenerate

wire[7:0] inter;

assign P[0] = p[0];
assign G[0] = g[0];
generate
for (i=1; i<8; i=i+1)
begin: loop2
	and (P[i], p[i], P[i-1]);
	//P[i]=p[i]P[i-1]
	and (inter[i],p[i], G[i-1]);
	or (G[i], g[i],inter[i]) ;
	//G[i]=g[i]+p[i]g[i-1]+p[i]p[i-1]G[i-2]
	//    =g[i]+pi(g[i-1]+p[i-1]&G[i-2])
	//    =g[i]|(p[i]&G[i-1]) 
end
endgenerate

wire[7:0] inter1;

//Generate all carries and sum
assign c[0]=c_in;
generate
for(i=0;i<8;i=i+1)
begin: loop3
	//c[i+1]=G[i]+P[i]c[0]
	and (inter1[i],P[i] , c[0]);
	or (c[i+1], G[i],inter1[i]);
	//sum[i]=p[i]^c[i]
	xor (sum[i],p[i], c[i]);
end
assign c_out = c[8];
endgenerate
endmodule
`endif