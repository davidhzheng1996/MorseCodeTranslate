module mux(out, s, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12,
in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27,
in28, in29, in30, in31);

wire [31:0] wire0, wire1, wire2, wire3, wire4, wire5, wire6, wire7, wire8, wire9;
wire [31:0] wire10, wire11, wire12, wire13, wire14, wire15, wire16, wire17, wire18, wire19;
wire [31:0] wire20, wire21, wire22, wire23, wire24, wire25, wire26, wire27, wire28, wire29;
wire [31:0] wire30, wire31;
input [31:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9;
input [31:0] in10, in11, in12, in13, in14, in15, in16, in17, in18, in19;
input [31:0] in20, in21, in22, in23, in24, in25, in26, in27, in28, in29;
input [31:0] in30, in31;
input [4:0] s;
wire [31:0] s1;
output [31:0] out;

decoder32bits decodeSelect(s1, s);

	genvar i;
	generate
		for ( i = 0; i < 32; i = i + 1) begin: getWire
			and(wire0[i], in0[i], s1[0]);
			and(wire1[i], in1[i], s1[1]);
			and(wire2[i], in2[i], s1[2]);
			and(wire3[i], in3[i], s1[3]);
			and(wire4[i], in4[i], s1[4]);
			and(wire5[i], in5[i], s1[5]);
			and(wire6[i], in6[i], s1[6]);
			and(wire7[i], in7[i], s1[7]);
			and(wire8[i], in8[i], s1[8]);
			and(wire9[i], in9[i], s1[9]);
			and(wire10[i], in10[i], s1[10]);
			and(wire11[i], in11[i], s1[11]);
			and(wire12[i], in12[i], s1[12]);
			and(wire13[i], in13[i], s1[13]);
			and(wire14[i], in14[i], s1[14]);
			and(wire15[i], in15[i], s1[15]);
			and(wire16[i], in16[i], s1[16]);
			and(wire17[i], in17[i], s1[17]);
			and(wire18[i], in18[i], s1[18]);
			and(wire19[i], in19[i], s1[19]);
			and(wire20[i], in20[i], s1[20]);
			and(wire21[i], in21[i], s1[21]);
			and(wire22[i], in22[i], s1[22]);
			and(wire23[i], in23[i], s1[23]);
			and(wire24[i], in24[i], s1[24]);
			and(wire25[i], in25[i], s1[25]);
			and(wire26[i], in26[i], s1[26]);
			and(wire27[i], in27[i], s1[27]);
			and(wire28[i], in28[i], s1[28]);
			and(wire29[i], in29[i], s1[29]);
			and(wire30[i], in30[i], s1[30]);
			and(wire31[i], in31[i], s1[31]);
			end
	endgenerate
	
	genvar k;
	generate
		for (k = 0; k < 32; k = k + 1) begin: getOutput
			or(out[k], wire0[k], wire1[k], wire2[k], wire3[k], wire4[k], wire5[k], wire6[k], wire7[k], wire8[k], wire9[k],
				wire10[k], wire11[k], wire12[k], wire13[k], wire14[k], wire15[k], wire16[k], wire17[k], wire18[k], wire19[k],
				wire20[k], wire21[k], wire22[k], wire23[k], wire24[k], wire25[k], wire26[k], wire27[k], wire28[k], wire29[k], 
				wire30[k], wire31[k]);
			end
	endgenerate

endmodule