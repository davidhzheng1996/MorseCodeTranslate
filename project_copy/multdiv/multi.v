//multiplier module
//want to make asynchronous multi, independent of outside clk
`ifndef multi_H
`define multi_H//to prevent repeated include
`include "alu/Adder32.v"
// `include "changed.v"
`include "multdiv/reg32.v"
`include "multdiv/shiftadder.v"
`include "multdiv/counter.v"
`include "common/mydffe.v"
`include "multdiv/div_debug.v"
module multi(data_operandA, data_operandB, ctrl_MULT, clk, data_result, 
    data_exception, data_resultRDY);
    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, clk;
    output [31:0] data_result;
    output data_exception, data_resultRDY;
    reg[300:0] x;
    wire[31:0] data_operandA, data_operandB,A,B,
            data_result,result;

    wire[4:0] ct_div,shftamt;
    wire [31:0] div_res_mult,A_abs,B_org,
            cur_rem,to_store,
            next_rem,to_sub,divisor;

    wire myctrl,s_ctrl,s_ctrl1,done_div,div0, div_rdy;

    div div_debug(data_operandA, data_operandB, ctrl_MULT, clk, div_res_mult, 
    div0, div_rdy, ct_div,A_abs,B_org,shftamt,myctrl,s_ctrl,cur_rem,done_div,to_store,next_rem,to_sub,divisor);


// ovf
// maxint:
// 2147483647
// minint:
// -2147483648
    wire [31:0] MAX_POS,MIN_NEG,max_over,min_over,min1y,max1y,min2y,max2y;
    wire exc_1,exc_2,xneg,max_rdy,min_rdy;
    assign MAX_POS = 32'd2147483647;
    assign MIN_NEG = -32'd2147483647;
    // div div_max_pos(MAX_POS,x,ctrl_MULT,clk,max_over,,div_rdy ,,, ,,,,,,,,,,,);
// minneg<=x*y<=maxpos
// 1.if x<0
// maxpos/x<=y<=minneg/x
//min1y=maxpos/x max1y=minneg/x
//max_over<=y<=min_over
//exc_1=1 if (~ltmin&~eqmin)||(ltmax)


// 2.if x>0
// minneg/x<=y<=maxpos/x
//min2y=minneg/x max2y=maxpos/x
//min_over<=y<=max_over
//exc_2=1, if (ltmin)||(~ltmax&~eqmax)
    //A,B,res_in,res_out are used in operations
    //negA is -A in 2's complemnet
    //res_in is the input (D) to the 32-bit reg that stores result
    //res_out is the output (Q) to the 32-bit reg that stores result
    wire [4:0] ct;//ct for counter
    wire done,ready,ready1,ctrl_MULT,nctrl_MULT,nrst,rst;
    assign nctrl_MULT = ~ctrl_MULT;
    assign rst = ctrl_MULT;
    assign nrst = nctrl_MULT;
//use 2 bit booth
//dictionary
//10    sub
//01    add
//00/11 nothing
    wire ovf,booth_ovf;
    wire ppn;
    //ppn Apos Bpos,result neg
    assign  ppn=~A[31]&~B[31]&result[31];
    shiftadder sa(A, B,ct,result,clk,rst,ovf);
    counter c(clk, rst, ct, done);
    mydffe dff0(done,clk,nrst, , 1'b1, ready);
    mydffe dff1(ready,clk,nrst, , 1'b1, data_resultRDY);
    reg32 r(clk|data_resultRDY,nrst,result,data_result);
    mydffe dff1_exc(ovf,clk|ready,nrst,,1'b1,booth_ovf);
    assign data_exception = booth_ovf|ppn;
    //*will go with using just ctrl signal for reset
    //if_change_then_reset module for this control
    // wire reg_reset;
    // changed changed_reset(ctrl_MULT,clk,reg_reset);
    //reg_reset assert for 1~1.5 period when ctrl_mult rises high

    wire manual_clk,manual_clr,manual_nclr;//clk/clr signals toggled by me
    assign manual_clk=0,manual_clr=0;
    assign manual_nclr = ~manual_clr;
    //store A,B,Result first in a 32bit register
    //we can use reset to trigger register that stores the operands
    reg32 regA(ctrl_MULT,,data_operandA,A);//use A instead for operation
    reg32 regB(ctrl_MULT,,data_operandB,B);//use B instead for operation
    // reg32 reg_res(clk,~ctrl_MULT,result,fin_res);//use A instead for operation
    //the clk/clr shouldn't be necessary tho
    //could be helpful if I can detect/tell completion myself
    //operand A as multiplicand probably doesn't need storage, just in case tho
    //when ctrl is asserted, regA stores A,regB stores B, reg_res refresh
       






    
//edge_case if 10000000;

    // wire A31,nA31,B31,nB31,r31,nr31;//wires that would be used for overflow
    // assign A31 = A[31];
    // assign B31 = B[31];
    // assign r31 = result[31];
    // not na(nA31,A[31]);
    // not nb(nB31,B[31]);
    // not nr(nr31,result[31]);
    //     // overflow for add
    // wire ovfadd;
    // wire ovfadd0,ovfadd1;
    // assign data_exception=ovfadd;
    // //overflow if either add case produces overflow
    // or ovf_add(ovfadd,ovfadd0,ovfadd1);
    // // if A[31]==0,B[31]==0
    // // (A+B)[31]==1
    // //so ovfadd0=A[31]'&B[31]'&r31
    // and aovfa0(ovfadd0,nA31,nB31,r31);
    // // if A[31]==1,B[31]==1
    // // (A+B)[31]==0
    // //so ovfadd1=A[31]&B[31]&r31'
    // and aovfa1(ovfadd1,A31,B31,nr31);

//**not needed
    // wire[31:0] negA,A_inv;
    // genvar  i;
    // generate
    //     for (i=0;i<32;i=i+1)//loop a from 0 to 31
    //     begin:loop1
    //         not(A_inv[i],A[i]);
    //     end
    // endgenerate
    // Adder32 complement(32'b0,A_inv,1'b1,negA,);//-A, negA for later operation
    
    //use B to select if it's A/-A/0 to be shift_Add to product

    // wire cycle_completion;

    //decode LSB for operation
    //the 0th is the LSB



endmodule
`endif