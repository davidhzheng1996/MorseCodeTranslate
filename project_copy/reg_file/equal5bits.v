module equal5bits(equal, in1, in2);
	output equal;
	input [4:0] in1, in2;
	wire [4:0] temp, nottemp, equalbits;
	
	
	genvar i;
		generate
			for(i = 0; i < 5; i = i + 1) begin: loop102
				and(temp[i], in1[i], in2[i]);
				and(nottemp[i], ~in1[i], ~in2[i]);
				or(equalbits[i], temp[i], nottemp[i]);
			end
		endgenerate
		
	and(equal, equalbits[0], equalbits[1], equalbits[2], equalbits[3], equalbits[4]);
	
endmodule
