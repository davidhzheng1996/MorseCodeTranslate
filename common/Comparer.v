`ifndef Comparer_H
`define Comparer_H//to prevent repeated include
`include "alu/Subber32.v"
`include "common/Comparer0.v"
module Comparer(A,B,NotEqual,LessThan);//compare 2 32-bit number
input[31:0] A,B;
output NotEqual,LessThan;
wire[31:0] A,B;
wire NotEqual,LessThan;

wire[31:0] temp0,temp1;
wire less0,less1,ne0,ne1,
	less11,ne11,less00,ne00;
wire is0_0,Pos_0,is0_1,Pos_1;

wire pl0,pl1;
//4 cases, B[31] as first index, A[31] as the second
//case 00, B>0,A>0
//case 01, B>0,A<0, B>0>A
//case 10, B<0,A>0, A>0>B
//case 11, B<0,A<0

assign LessThan=B[31] ?less1:less0;
assign NotEqual=B[31] ?ne1:ne0;

//case1, B[31]==1, B negative
	//case10, A[31]==0, A>0>B
assign less1=A[31] ?less11:1'b0;
assign ne1=A[31] ?ne11:1'b1;
//take care of subtraction later, because I don't have subtractor yet
	
	//case11, temp1=(0,A)-(0,B)
	Subber32 sub11({1'b0,A[30:0]},{1'b0,B[30:0]},temp1,pl1);
	Comparer0 c1(temp1,is0_1,Pos_1);
	//lessthan==0 iff pos==0,is0==0
	assign less11=Pos_1?1'b1:1'b0;
	assign ne11=is0_1?1'b0:1'b1;//a!=b if a-b is 0

//case0, B[31]==0
	//case01, A[31]==1, B>0>A
	assign less0=A[31]?1'b1:less00;
	assign ne0=A[31]?1'b1:ne00;

	//case00, A>0,B>0 temp0=A-B
	Subber32 sub00(A,B,temp0,pl0);
	Comparer0 c0(temp0,is0_0,Pos_0);
	//if(pos==1) A>B, A!=B
	//if(is0==1) A==B
	assign ne00=is0_0?1'b0:1'b1;//(a!=b)==0 if a-b is 0
	//A==B?notequal=false:notequal=true
	//lessthan==1 iff pos==0,is0==0, i.e. A-B<0
	assign less00=Pos_0?1'b0:(ne00?1'b1:1'b0);

/*
	if(B[31]==1){//less1,ne1;
		if(A[31]==0) A>B;//LessThan=0,NotEqual=1
		temp=(0,A)-(0,B);
		if(temp)>0 //is0=0,pos=1
			A<B;//LessThan=1,NotEqual=1
		if(temp==0) //is0=1,pos=0
			A==b;//LessThan=0,NotEqual=0
	}else if(B[31]==0){//less0,ne0;
		temp=A-B;
		if(temp>0) A>B;//LessThan=0,NotEqual=1
		if(temp!>0&&temp!=0) A<B;//LessThan=1,NotEqual=1
		if(temp==0) A==b;//LessThan=0,NotEqual=0
	}		
*/

//if B>=0, meaning B[MSB]==0;
//A-B>0
//then A>B
//if B<0, meaning B[MSB]==1;
//A[MSB-1:0]-B[MSB-1:0]>0
//then A<B
endmodule
`endif