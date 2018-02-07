module asciitomorse(morse_ascii, morsecode);
	input [31:0] morse_ascii;
	output [9:0] morsecode;
	
	assign morsecode = 	((morse_ascii===32'd48)) ? 10'd1010101010:
								((morse_ascii===32'd49)) ? 10'd1010101001:
								((morse_ascii===32'd50)) ? 10'd1010100101:
								((morse_ascii===32'd51)) ? 10'd1010010101:
								((morse_ascii===32'd52)) ? 10'd1001010101:
								((morse_ascii===32'd53)) ? 10'd0101010101:
								((morse_ascii===32'd54)) ? 10'd0101010110:
								((morse_ascii===32'd55)) ? 10'd0101011010:
								((morse_ascii===32'd56)) ? 10'd0101101010:
								((morse_ascii===32'd57)) ? 10'd0110101010:
								(morse_ascii===32'd65) ? 10'd1111111001:
								(morse_ascii===32'd66) ? 10'd1101010110: 
								(morse_ascii===32'd67) ? 10'd1101100110:
								(morse_ascii===32'd68) ? 10'd1111010110:
								(morse_ascii===32'd69) ? 10'd1111111101: 
								(morse_ascii===32'd70) ? 10'd1101100101:
								(morse_ascii===32'd71) ? 10'd1111011010:
								(morse_ascii===32'd72) ? 10'd1101010101: 
								(morse_ascii===32'd73) ? 10'd1111110101:
								(morse_ascii===32'd74) ? 10'd1110101001:
								(morse_ascii===32'd75) ? 10'd1111100110: 
								(morse_ascii===32'd76) ? 10'd1101011001:
								(morse_ascii===32'd77) ? 10'd1111111010:
								(morse_ascii===32'd78) ? 10'd1111110110: 
								(morse_ascii===32'd79) ? 10'd1111101010:
								(morse_ascii===32'd80) ? 10'd1101101001:
								(morse_ascii===32'd81) ? 10'd1110011010: 
								(morse_ascii===32'd82) ? 10'd1111011001:
								(morse_ascii===32'd83) ? 10'd1111010101:
								(morse_ascii===32'd84) ? 10'd1111111110: 
								(morse_ascii===32'd85) ? 10'd1111100101:
								(morse_ascii===32'd86) ? 10'd1110010101: 
								(morse_ascii===32'd87) ? 10'd1111101001:
								(morse_ascii===32'd88) ? 10'd1110010110:
								(morse_ascii===32'd89) ? 10'd1110100110: 
								(morse_ascii===32'd90) ? 10'd1101011010:
								10'd1111111111;

endmodule
