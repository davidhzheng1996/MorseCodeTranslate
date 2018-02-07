//shiftdiver for division
//A,B doesn't have to remain
////when reset signal is high, current result is reset
////thus use rst
`ifndef shiftdiv_H
`define shiftdiv_H//to prevent repeated include
`include "alu/Subber32.v"
`include "common/mydffe.v"
`include "common/SLL32.v"
`include "common/OR32.v"
`include "common/decoder32.v"
`include "common/Comparer.v"
`include "multdiv/reg32.v"
`include "multdiv/aligner.v"

module shiftdiver(A_dum,B_dum,ctrl,ct,rem,clk,quoti,to_store,next_rem,to_sub,divisor);
// module shiftdiver(A,B_dum,ctrl,ct,rem,clk,to_sub,next_rem);
//B, the number to be shifted
//divisor=B<<ct
//ct, value for counter, representing the amt to shft
//result, result produced
//clk, clock signal
//rst, reset signal resets 
    input [31:0] A_dum,B_dum;
    input clk,ctrl;
    input [4:0] ct;
    output [31:0] rem,quoti,to_store,next_rem,to_sub,divisor;

//alignment done outside
    // //alignment
    // wire[31:0] shftedB;//not needed
    // wire[4:0] shftamt;
    // aligner al(A,B,shftedB,shftamt);

//register for remainder
    // reg32 Acopy(ctrl,,)
    wire [31:0] A,B,cur_rem,next_rem,to_store,to_sub,to_store_quo,next_quo,cur_quo;//current remainder value
    reg32 A_copy(ctrl,,A_dum,A);


    reg32 remainder(clk,1'b1,to_store,cur_rem);

    reg32 B_copy(ctrl,,B_dum,B);
    //need to retain ctrl for one more cycle
    wire s_ctrl,s_ctrl1,s_ctrl2,chooseA;
//*******interesting here,~s_ctrl
    reg32 quotient(clk,,to_store_quo,cur_quo);
    mydffe a_dff(ctrl, clk,,,1'b1,s_ctrl);
    mydffe b_dff(s_ctrl, clk,,,1'b1,s_ctrl1);
    mydffe c_dff(s_ctrl1, clk,,,1'b1,s_ctrl2);
    //store A at the beginning and new remainder in the middle
    or a_or(chooseA,ctrl,s_ctrl);//ctrl|s_ctrl|s_ctrl1
    assign to_store = (chooseA)?A_dum:next_rem;
    // assign to_store = (~chooseA)?next_rem:A;
//store A until ct comes in, at which point of time, next_rem is valid
    assign rem = cur_rem;
    assign quoti = cur_quo;
//to sub
    //to sub is shifted B or 0
    wire[31:0] divisor;
    wire NE,LT;
    SLL32 shftleft(B,ct,divisor);
    Comparer cmp(divisor,cur_rem,NE,LT);
    //to sub shftB if d<=rem
    assign to_sub = ((~NE)|LT)?divisor:32'b0;
//to add 1s to quotient
    //to_store_quo,next_quo,cur_quo
    wire[31:0] cur_bit;
    decoder32 decode(ct,cur_bit);
    OR32 or32er(cur_bit,cur_quo,next_quo);
    assign to_store_quo = (chooseA)?32'b0:((~NE)|LT)?next_quo:cur_quo;

//subber iteration
    Subber32 sb(cur_rem,to_sub,next_rem,);
    //value to be shifted


endmodule
`endif