`ifndef SRA32_H
`define SRA32_H//to prevent repeated include
module SRA32(a,shiftamt,result);//gives result of a-b
//implement a 32-bit SRA calculatSRA
input [31:0] a;
input [4:0] shiftamt;
output [31:0] result;

wire[31:0] a,result;
wire [4:0] shiftamt;
wire[31:0] y4,y3,y2,y1,y0;//shifted
wire sgn;
assign sgn=a[31];

//logical shift to right, fill with sgn
//if shiftamt[4]==1
//shift 16 bit
assign y4=shiftamt[4]?{{16{sgn}},a[31:16]}:a;
//if shiftamt[3]==1
//shift 8 bit
assign y3=shiftamt[3]?{{8{sgn}},y4[31:8]}:y4;
//if shiftamt[2]==1
//shift 4 bit
assign y2=shiftamt[2]?{{4{sgn}},y3[31:4]}:y3;
//if shiftamt[1]==1
//shift 2 bit
assign y1=shiftamt[1]?{{2{sgn}},y2[31:2]}:y2;
//if shiftamt[0]==1
//shift 1 bit
assign result=shiftamt[0]?{{1{sgn}},y1[31:1]}:y1;

endmodule
`endif