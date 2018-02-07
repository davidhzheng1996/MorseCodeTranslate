`ifndef OPdecoder_H
`define OPdecoder_H//to prevent repeated include
module OPdecoder(opcode,ctrl_sig);
input[4:0] opcode;
output[5:0] ctrl_sig;
wire[5:0] ctrl_sig;//there are 6 operations right now
wire[4:0] nopcode;//negate of opcode
//the 0th is the LSB
genvar  i;
generate
	for (i=0;i<5;i=i+1)
	begin: loop0
		not (nopcode[i],opcode[i]);
	end
endgenerate
and ADD(ctrl_sig[0],nopcode[4],nopcode[3],nopcode[2],nopcode[1],nopcode[0]);
and SUB(ctrl_sig[1],nopcode[4],nopcode[3],nopcode[2],nopcode[1], opcode[0]);
and AND(ctrl_sig[2],nopcode[4],nopcode[3],nopcode[2], opcode[1],nopcode[0]);
and  OR(ctrl_sig[3],nopcode[4],nopcode[3],nopcode[2], opcode[1], opcode[0]);
and SLL(ctrl_sig[4],nopcode[4],nopcode[3], opcode[2],nopcode[1],nopcode[0]);
and SRA(ctrl_sig[5],nopcode[4],nopcode[3], opcode[2],nopcode[1], opcode[0]);

endmodule
`endif