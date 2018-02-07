module ascii_to_seven_seg(ascii, seg8, seg7, seg6, seg5, seg4);
	input[32:0] ascii;
	output [6:0] seg8, seg7, seg6, seg5, seg4;

	wire [6:0] dot, dash, zero;
	assign dot = 7'b1000000;
	assign dash = 7'b0111111;
	assign zero = 7'b1111111;
	wire dot1, dot2, dot3, dot4, dot5;
	wire dash1, dash2, dash3, dash4, dash5;
	assign dot1 = ((ascii===32'd65)|(ascii===32'd69)|(ascii===32'd70)|
						(ascii===32'd72)|(ascii===32'd73)|(ascii===32'd74)
						|(ascii===32'd76)|(ascii===32'd80)|(ascii===32'd82)|
						(ascii===32'd83)|(ascii===32'd85)|(ascii===32'd86)|
						(ascii===32'd87)|(ascii===32'd49)|(ascii===32'd50)|
						(ascii===32'd51)|(ascii===32'd52)|(ascii===32'd53));
						
	assign dot2 = ((ascii===32'd66)|(ascii===32'd67)|(ascii===32'd68)|
	(ascii===32'd70)|(ascii===32'd72)|(ascii===32'd73)|(ascii===32'd75)|
	(ascii===32'd78)|(ascii===32'd83)|(ascii===32'd85)|(ascii===32'd86)|
	(ascii===32'd88)|(ascii===32'd89)|(ascii===32'd54)|(ascii===32'd50)|
	(ascii===32'd51)|(ascii===32'd52)|(ascii===32'd53));
	
	assign dot3 = ((ascii===32'd66)|(ascii===32'd68)|(ascii===32'd71)|
	(ascii===32'd72)|(ascii===32'd76)|(ascii===32'd81)|(ascii===32'd82)|
	(ascii===32'd83)|(ascii===32'd85)|(ascii===32'd86)|(ascii===32'd88)|
	(ascii===32'd90)|(ascii===32'd54)|(ascii===32'd55)|(ascii===32'd51)|
	(ascii===32'd52)|(ascii===32'd53));
	
	assign dot4 = ((ascii===32'd66)|(ascii===32'd67)|(ascii===32'd70)|
	(ascii===32'd72)|(ascii===32'd76)|(ascii===32'd80)|(ascii===32'd90)|
	(ascii===32'd54)|(ascii===32'd55)|(ascii===32'd56)|(ascii===32'd52)|
	(ascii===32'd53));
	
	assign dot5 = ((ascii===32'd54)|(ascii===32'd55)|(ascii===32'd56)|
	(ascii===32'd57)|(ascii===32'd53));
	
	assign dash1 = ((ascii===32'd66)|(ascii===32'd67)|(ascii===32'd68)|
	(ascii===32'd71)|(ascii===32'd75)|(ascii===32'd77)|(ascii===32'd78)|
	(ascii===32'd79)|(ascii===32'd81)|(ascii===32'd84)|(ascii===32'd88)|
	(ascii===32'd89)|(ascii===32'd90)|(ascii===32'd54)|(ascii===32'd55)|
	(ascii===32'd56)|(ascii===32'd57)|(ascii===32'd58));
	
	assign dash2 = ((ascii===32'd74)|(ascii===32'd76)|(ascii===32'd77)|
	(ascii===32'd79)|(ascii===32'd80)|(ascii===32'd81)|(ascii===32'd82)|
	(ascii===32'd87)|(ascii===32'd90)|(ascii===32'd55)|(ascii===32'd56)|
	(ascii===32'd57)|(ascii===32'd58)|(ascii===32'd49));
	
	assign dash3 = ((ascii===32'd67)|(ascii===32'd70)|(ascii===32'd74)|
	(ascii===32'd75)|(ascii===32'd79)|(ascii===32'd80)|(ascii===32'd85)|
	(ascii===32'd87)|(ascii===32'd89)|(ascii===32'd56)|(ascii===32'd57)|
	(ascii===32'd58)|(ascii===32'd49)|(ascii===32'd50));
	
	assign dash4 = ((ascii===32'd74)|(ascii===32'd81)|(ascii===32'd86)|
	(ascii===32'd88)|(ascii===32'd89)|(ascii===32'd57)|(ascii===32'd58)|
	(ascii===32'd49)|(ascii===32'd50)|(ascii===32'd51));
	
	assign dash5 = ((ascii===32'd58)|(ascii===32'd49)|(ascii===32'd50)|
	(ascii===32'd51)|(ascii===32'd52));
	
	assign seg8 = dot1 ? dot:
					  dash1 ? dash : zero;
	assign seg7 = dot2 ? dot:
					  dash2 ? dash: zero;
	assign seg6 = dot3 ? dot:
					  dash3 ? dash: zero;
	assign seg5 = dot4 ? dot:
					  dash4 ? dash: zero;
	assign seg4 = dot5 ? dot:
					  dash5 ? dash: zero;
	
endmodule


