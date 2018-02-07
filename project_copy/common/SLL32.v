`ifndef SLL32_H
`define SLL32_H//to prevent repeated include
module SLL32(a,shiftamt,result);//gives result of a-b
//implement a 32-bit SLL calculatSLL
input [31:0] a;
input [4:0] shiftamt;
output [31:0] result;

wire[31:0] a,result;
wire [4:0] shiftamt;
wire[31:0] y4,y3,y2,y1,y0;//shifted
//logical shift to left, fill with 0
//if shiftamt[4]==1
//shift 16 bit
assign y4=shiftamt[4]?{a[15:0],16'b0}:a;
//if shiftamt[3]==1
//shift 8 bit
assign y3=shiftamt[3]?{y4[23:0],8'b0}:y4;
//if shiftamt[2]==1
//shift 4 bit
assign y2=shiftamt[2]?{y3[27:0],4'b0}:y3;
//if shiftamt[1]==1
//shift 2 bit
assign y1=shiftamt[1]?{y2[29:0],2'b0}:y2;
//if shiftamt[0]==1
//shift 1 bit
assign result=shiftamt[0]?{y1[30:0],1'b0}:y1;

endmodule
`endif