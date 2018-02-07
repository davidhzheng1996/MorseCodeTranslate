`ifndef ALU_H
`define ALU_H//to prevent repeated include
`include "alu/Subber32.v"
`include "alu/Adder32.v"
`include "alu/OPdecoder.v"

`include "common/OR32.v"
`include "common/AND32.v"
`include "common/Comparer.v"
`include "common/SLL32.v"
`include "common/SRA32.v"
module alu(data_operandA, data_operandB, ctrl_ALUopcode, 
	ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

   // YOUR CODE HERE //
   //an ineffecient thing here is I have multiple adder subtractor
   //for calculating signals, but it prevents overflow
   //calculate everything in parallel and use the select sig to select
   
   Comparer comp(data_operandA,data_operandB,isNotEqual,isLessThan);
   //decode opcode signal wires, only one sig turns on at a time
   wire sra_sig,sll_sig,or_sig,and_sig,sub_sig,add_sig;
   OPdecoder decoder(ctrl_ALUopcode,{sra_sig,sll_sig,
      or_sig,and_sig,sub_sig,add_sig});

   //wires that handle the result
   wire [31:0] sra_res,sll_res,or_res,and_res,sub_res,add_res;

   //assign result with control signals controlling which result to output
   assign data_result=sra_sig?sra_res:32'bz;
   assign data_result=sll_sig?sll_res:32'bz;
   assign data_result=or_sig?or_res:32'bz;
   assign data_result=and_sig?and_res:32'bz;
   assign data_result=sub_sig?sub_res:32'bz;
   assign data_result=add_sig?add_res:32'bz;

   wire adder_cout,subber_cout;//not really used
   //calculation module
   Adder32 adder(data_operandA,data_operandB,1'b0,add_res,adder_cout);
   Subber32 subber(data_operandA,data_operandB,sub_res,subber_cout);
   OR32 orer(data_operandA,data_operandB,or_res);
   AND32 ander(data_operandA,data_operandB,and_res);
   SLL32 sller(data_operandA,ctrl_shiftamt,sll_res);
   SRA32 sraer(data_operandA,ctrl_shiftamt,sra_res); 

   wire A31,nA31,B31,nB31,r31,nr31;//wires that would be used for overflow
   assign A31 = data_operandA[31];
   assign B31 = data_operandB[31];
   assign r31 = data_result[31];
   not na(nA31,data_operandA[31]);
   not nb(nB31,data_operandB[31]);
   not nr(nr31,data_result[31]);
   //overflow RULE: If signs of operands match
   //and differ from sign of answer, OVERFLOW!
   //impossible if adding a pos & a neg produces overflow
   wire ovfadd,ovfsub;
   assign overflow=add_sig?ovfadd:(sub_sig?ovfsub:1'bx);
   
   // overflow for add
   wire ovfadd0,ovfadd1;
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

   // overflow for sub
   // A-B=A+(-B)
   wire ovfsub0,ovfsub1;
   //overflow if either sub case produces overflow
   or ovf_sub(ovfsub,ovfsub0,ovfsub1);  
   // if A[31]==0,(-B)[31]==0,B[31]==1
   // (A+B)[31]==1
   //so ovfsub0=nA31&B31&r31
   and sovfa0(ovfsub0,nA31,B31,r31);
   // if A[31]==1,(-B)[31]==1,B[31]==0
   // (A+B)[31]==0
   //so ovfsub0=A31&nB31&nr31
   and sovfa1(ovfsub1,A31,nB31,nr31);
endmodule
`endif