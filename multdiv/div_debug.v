//divisor module
//debug version, worked as of 1018
`ifndef div_H
`define div_H//to prevent repeated include
`include "multdiv/shftdiv_debug.v"
`include "multdiv/div_counter.v"
`include "multdiv/aligner.v"
`include "multdiv/reg32.v"
`include "common/mydffe.v"
`include "common/Comparer0.v"
`include "alu/Adder32.v"
module div(A_dum, B_dum, ctrl_DIV, clk, result, 
    data_exception, RDY, ct,A,B_org,shftamt,myctrl,s_ctrl,cur_rem,done,to_store,next_rem,to_sub,divisor);
    
    input [31:0] A_dum, B_dum;
    input ctrl_DIV, clk;
    output [31:0] result,A,B_org;
    //debug port
    output [31:0] to_store,next_rem,cur_rem,to_sub,divisor;
    // output [4:0] ct;
    output data_exception, RDY;
    output [4:0] ct,shftamt;
    output myctrl,s_ctrl,done;
    wire[31:0] A_dum, B_dum,A,B,
            result,tmp_res;
    wire clk,ctrl_DIV,myctrl,data_exception, RDY;
    mydffe latch_dff(ctrl_DIV, clk,,,1'b1,myctrl);
    wire[31:0] A_org,B_org;
    //exact copies of A,B input
    reg32 A_copy_ex(ctrl_DIV,,A_dum,A_org);
    reg32 B_copy_ex(ctrl_DIV,,B_dum,B_org);

    //threw exception if b=0
    wire is0,isPos;
    Comparer0 c1(B_org,is0,isPos);
    assign data_exception=is0?1'b1:1'b0;
    //determine if A,B are negative
    wire is0A,isPosA;
    Comparer0 ca(A_org,is0A,isPosA);

    ////if a<b, return 0
    //if a/b>=0, a/b=|a|/|b|
    //if a<0,b<0, a/b=|a|/|b|
    //if a/b<0, a/b=-|a|/|b|
    wire[31:0] A_abs,B_abs,A_pos,B_pos,Am1,Bm1;
//if A<0
//A_pos=-A=~(A+(-1)),-1=32{1'b1}
    Adder32 absA(A_org,{32{1'b1}},1'b0,Am1,);
    assign A_pos = ~Am1;
    Adder32 absB(B_org,{32{1'b1}},1'b0,Bm1,);
    assign B_pos = ~Bm1;
    //calculate A_pos,B_pos, assuming they are negative
    assign A_abs = A_org[31]?A_pos:A_org;
    assign B_abs = B_org[31]?B_pos:B_org;

    wire s_ctrl,s_ctrl1,s_ctrl2,s_ctrl3,done,ready,ready1;//stored ctrl
    mydffe a_dff(myctrl, clk,,,1'b1,s_ctrl);
    mydffe a1_dff(s_ctrl, clk,,,1'b1,s_ctrl1);
    mydffe a2_dff(s_ctrl1, clk,,,1'b1,s_ctrl2);
    mydffe a3_dff(s_ctrl2, clk,,,1'b1,s_ctrl3);
    reg32 A_copy(s_ctrl,,A_abs,A);
    reg32 B_copy(s_ctrl,,B_abs,B);


    wire[4:0] shftamt,ct;
    wire[31:0] shftedB,rem,to_store,to_sub,next_rem,quoti,to_store_quo,sfa,divisor;
    aligner al(A,B,shftedB,shftamt);

    wire ct_ctrl;
    // nand n_gate(ct_ctrl,ctrl|s_ctrl,ct_ctrl);
    div_counter c8(clk, s_ctrl2,shftamt, ct,done);
    mydffe r_dff(done, clk,,,1'b1,ready);
    mydffe r2_dff(ready, clk,,,1'b1,ready1);
    wire c_clk;
    assign c_clk = (s_ctrl1|s_ctrl2)?clk:(ready?1'b1:clk);
    shiftdiver sd(A,B,s_ctrl1,ct,cur_rem,c_clk,quoti,to_store,next_rem,to_sub,divisor);
    // shiftdiver sd(A,B,s_ctrl,ct,rem,clk|ready,quoti,to_store);
    
    //quoti=|a|/|b|
    //if a/b<0, a/b=-|a|/|b|
    wire [31:0] nquoti,inv_quo;//negative version of quotient
    assign inv_quo = ~quoti;
    Adder32 neg_quo(inv_quo,32'b1,1'b0,nquoti,);
    wire neg_res;
    // assign neg_res = A_org[31]^B_org[31];
    xor an_xor(neg_res,A_org[31],B_org[31]);
    // xor an_xor(neg_res,~(is0A|isPosA),~(is0|isPos));
    //if n<0, ~(n=0||n>0)
    assign result = data_exception?32'b0:(neg_res?nquoti:quoti);
    assign RDY = ready;
    // mydffe df(ready,clk,,,1'b1,RDY);
//extreme case is when a/b=min_sign_int




//A, B,result,tmp_res;
//t0+0 cycle

//     //store A,B,Result first in a 32bit register
//     //we can use reset to trigger register that stores the operands
//     reg32 regA(myctrl,,A_dum,A);//use A instead for operation
//     reg32 reg_pos_B(myctrl,,B_dum,B);//use B instead for operation
// //A,B;
// //t0+0 cycle

//     //align B with A
//     wire[31:0] shftedB;
//     wire[4:0] shftamt;
//     aligner al(A,B,shftedB,shftamt);//shfted B is the aligned B initial
// //shftedB,shftamt;
// //t0+0++ cycle

// //shift divisor
// //need a counter that counts how many more cycles left
//     //shift divisor
//     //takes in shftamt,set quoti[shftamt] if q>d
//     //shftamt changes each clock cycle
// //start working after t0+1
// //finish first iteration at t0+2

//     //the iteration block
//     wire[31:0] cur_rem,next_rem;


//     //store remainder,quotient
//     wire[31:0] remai,quoti;
//     reg32 regA(clk,,A,remai);//
//     reg32 reg_pos_B(clk,,B,quoti);//
// //remai,quoti;
// //t0+1 cycle


endmodule
`endif