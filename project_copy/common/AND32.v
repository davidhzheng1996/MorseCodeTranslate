`ifndef AND32_H
`define AND32_H//to prevent repeated include
// `include "Adder32.v"
module AND32(a,b,result);//gives result of a-b
//implement a 32-bit AND calculatAND
input [31:0] a,b;
output [31:0] result;

wire[31:0] a,b,result;

genvar  i;
generate
	for (i=0;i<32;i=i+1) begin: loop		
		and a(result[i],a[i],b[i]);
	end
endgenerate


endmodule
`endif