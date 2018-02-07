module isZero(dataiszero, data);
	input[31:0] data;
	output dataiszero;
	wire[31:0] zeroes;
	
	genvar i;
		generate
			for(i=0;i<32; i = i + 1) begin: loopzeroes
				and(zeroes[i], data[i], 1'b0);
			end
		endgenerate
		
	and(dataiszero, zeroes[0], zeroes[1], zeroes[2], zeroes[3], zeroes[4], zeroes[5], zeroes[6], zeroes[7], zeroes[8], zeroes[9],
	zeroes[10], zeroes[11], zeroes[12], zeroes[13], zeroes[14], zeroes[15], zeroes[16], zeroes[17], zeroes[18], zeroes[19],
	zeroes[20], zeroes[21], zeroes[22], zeroes[23], zeroes[24], zeroes[25], zeroes[26], zeroes[27], zeroes[28], zeroes[29],
	zeroes[30], zeroes[31]);

endmodule
