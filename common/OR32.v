`ifndef OR32_H
`define OR32_H//to prevent repeated include
// `include "Adder32.v"
module OR32(a,b,result);//gives result of a-b
//implement a 32-bit or calculator
input [31:0] a,b;
output [31:0] result;

wire[31:0] a,b,result;

genvar  i;
generate
	for (i=0;i<32;i=i+1) begin: loop		
		or(result[i],a[i],b[i]);
		// $display($time, " I made an or gate");
	end
endgenerate


endmodule
`endif