//aligner module
//assume A,B positive, always exist, so this can be memoryless
//*shift B to left until the first 1 in B aligned with first 1 in A
//*shift amount recorded in shftamt
////shift in to left so that the second bit is 1, 
////shift amount recorded in shftamt
`ifndef aligner_H
`define aligner_H//to prevent repeated include
`include "common/SLL32.v"
`include "common/SRA32.v"
`include "common/CLA8bit.v"
module aligner(A,B,out,shftamt);
    input [31:0] A,B;
    output [31:0] out;//aligned output
    output [4:0]shftamt;//represent a number up to 30, needs 5 bits

    wire[31:0] A,B,out,tmp;
    wire[4:0] shftamt;
    wire[4:0] shftamtA,shftamtB;
    wire[160:0] buffer;
    assign shftamtB = buffer[4:0];
    //out=in>>shftamt
    SLL32 sf(B,shftamtB,tmp);
//detect first 1
    genvar  i;
    generate
        for (i=0;i<=30;i=i+1)//loop a from 0 to 31
        begin: loopi
        //find first 1
            assign buffer[i*5+4:i*5] = B[30-i]?i:buffer[(i+1)*5+4:(i+1)*5];
        end
    endgenerate//try to align B with A
//now shift the other way
    wire[160:0] buffer1;
    assign shftamtA = buffer1[4:0];
    //out=in>>shftamt
    SRA32 sfr(tmp,shftamtA,out);
    genvar  i1;
    generate
        for (i1=0;i1<=30;i1=i1+1)//loop a from 0 to 31
        begin: loopi1
            assign buffer1[i1*5+4:i1*5] = A[30-i1]?i1:buffer1[(i1+1)*5+4:(i1+1)*5];
        end
    endgenerate

    //calculate shftamt=shftamtB-shftamtA
    wire[4:0] nshftamtA;
    assign nshftamtA = ~shftamtA;
    wire[7:0] dummy;

    assign shftamt = dummy[4:0];
    CLA8bit cla8({3'b1,nshftamtA},{3'b0,shftamtB},1'b1,dummy,);


endmodule
`endif