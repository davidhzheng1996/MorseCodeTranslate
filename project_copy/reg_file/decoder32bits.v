module decoder32bits(out, in);
	input [4:0] in;
	wire not0, not1, not2, not3, not4;
	output [31:0] out;
	
	not(not0, in[0]);
	not(not1, in[1]);
	not(not2, in[2]);
	not(not3, in[3]);
	not(not4, in[4]);
	and(out[0], not4, not3, not2, not1, not0); //0
	and(out[1], not4, not3, not2, not1, in[0]); //1
	and(out[2], not4, not3, not2, in[1], not0);  //2
	and(out[3], not4, not3, not2, in[1], in[0]); //3
	and(out[4], not4, not3, in[2], not1, not0); //4 
	and(out[5], not4, not3, in[2], not1, in[0]); //5
	and(out[6], not4, not3, in[2], in[1], not0); //6
	and(out[7], not4, not3, in[2], in[1], in[0]); //7
	and(out[8], not4, in[3], not2, not1, not0); //8
	and(out[9], not4, in[3], not2, not1, in[0]); //9
	and(out[10], not4, in[3], not2, in[1], not0); //10
	and(out[11], not4, in[3], not2, in[1], in[0]); //11
	and(out[12], not4, in[3], in[2], not1, not0); //12
	and(out[13], not4, in[3], in[2], not1, in[0]); //13
	and(out[14], not4, in[3], in[2], in[1], not0); //14
	and(out[15], not4, in[3], in[2], in[1], in[0]); //15
	and(out[16], in[4], not3, not2, not1, not0); //16
	and(out[17], in[4], not3, not2, not1, in[0]); //17
	and(out[18], in[4], not3, not2, in[1], not0); //18
	and(out[19], in[4], not3, not2, in[1], in[0]); //19
	and(out[20], in[4], not3, in[2], not1, not0); //20
	and(out[21], in[4], not3, in[2], not1, in[0]); //21
	and(out[22], in[4], not3, in[2], in[1], not0); //22
	and(out[23], in[4], not3, in[2], in[1], in[0]); //23
	and(out[24], in[4], in[3], not2, not1, not0); //24
	and(out[25], in[4], in[3], not2, not1, in[0]); //25
	and(out[26], in[4], in[3], not2, in[1], not0); //26
	and(out[27], in[4], in[3], not2, in[1], in[0]); //27
	and(out[28], in[4], in[3], in[2], not1, not0); //28
	and(out[29], in[4], in[3], in[2], not1, in[0]); //29
	and(out[30], in[4], in[3], in[2], in[1], not0); //30
	and(out[31], in[4], in[3], in[2], in[1], in[0]);//31
endmodule