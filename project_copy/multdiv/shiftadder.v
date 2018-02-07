//shiftadder
//for multiply
//when reset signal is high, current result is reset
//thus use rst
`ifndef shiftadder_H
//shftadder for multiplication
`define shiftadder_H//to prevent repeated include
// `include "mydffe.v"
`include "alu/Adder32.v"
`include "multdiv/reg32.v"
`include "common/SLL32.v"
`include "multdiv/findc.v"
module shiftadder(A,B,ct,result,clk,rst,ovf);
//A, multiplicand
//B, multiplier
////res_old, result from previous cycle
//ct, value for counter
//result, result produced
//clk, clock signal
//rst, reset signal resets 
    input [31:0] A, B;
    input clk,rst;
    input [4:0] ct;
    output [31:0] result;
    output ovf;
    // output ready;
    wire [31:0] result;
    // output ischanged, ctrl_stored,reset;
    wire ctrl,clrn,prn,ena,ctrl_stored,ctrl_stored_mid,reset;
    wire nrst;
    assign nrst = ~rst;
    //2bit in B used to select A/-A/0,B[c+1:c]
    wire[1:0] B_c1_c;//B_c1_c=B[c+1:c], c+1 starts from 0th bit
    wire c1,c;
    findc fc(B,ct,{c1,c});//find the 2 selection bits in B for booth

    //negA
    wire[31:0] negA,A_inv;//negA=-A in 2s complement
    genvar  i;
    generate
        for (i=0;i<32;i=i+1)//loop a from 0 to 31
        begin:loop1
            not(A_inv[i],A[i]);
        end
    endgenerate
    Adder32 complement(32'b0,A_inv,1'b1,negA,);//-A, negA for later operation
    
    //value to be shifted
    wire[31:0] to_shft;//value to be shifted&added determined by booth
//use 2 bit booth
//B[C+1:C]	value to shft
//c1,c
//10    	negA
//01    	A
//00/11 	0
	assign to_shft = c1?(c?32'b0:negA):(c?A:32'b0);

	//value to be added
	wire [31:0] to_add;//val_add=to_shft<<shft_amt
	SLL32 shifter(to_shft,ct,to_add);
	
	//next result to be stored
	wire[31:0] next_res;
	//current result stored
	wire[31:0] cur_res;
	assign result = cur_res;
	//calculated next value to be stored
    wire cout_next;
	Adder32 add_next(cur_res,to_add,1'b0,next_res,cout_next);
	//store values in a 32-bit register
    reg32 r(clk,nrst,next_res,cur_res);


    wire A31,nA31,B31,nB31,r31,nr31;//wires that would be used for overflow
    assign A31 = cur_res[31];
    assign B31 = to_add[31];
    assign r31 = next_res[31];
    not na(nA31,A31);
    not nb(nB31,B31);
    not nr(nr31,r31);
        // overflow for add
    wire ovfadd;
    wire ovfadd0,ovfadd1;
    assign ovf=ovfadd;
    //overflow if either add case produces overflow
    or ovf_add(ovfadd,ovfadd0,ovfadd1);
    // if A[31]==0,B[31]==0
    // (A+B)[31]==1
    //so ovfadd0=A[31]'&B[31]'&r31
    and aovfa0(ovfadd0,nA31,nB31,r31);
    // if A[31]==1,B[31]==1
    // (A+B)[31]==0
    //so ovfadd1=A[31]&B[31]&r31'
    and aovfa1(ovfadd1,A31,B31,nr31);
endmodule
`endif