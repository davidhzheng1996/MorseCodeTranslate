module ps2toascii(ps2_out, morse_asciiout);
	input [7:0] ps2_out;
	reg [31:0] morse_ascii;
	output [31:0] morse_asciiout;

	always @(*)
	begin
	if((ps2_out===8'h45)|(ps2_out===8'h70))//0
	morse_ascii = 32'd48;
	else if((ps2_out===8'h16)|(ps2_out===8'h69))//1
	morse_ascii = 32'd49;
	else if((ps2_out===8'h1E)|(ps2_out===8'h72))//2
	morse_ascii = 32'd50;
	else if((ps2_out===8'h26)|(ps2_out===8'h7A))//3
	morse_ascii = 32'd51;
	else if((ps2_out===8'h25)|(ps2_out===8'h6B))//4
	morse_ascii = 32'd52;
	else if((ps2_out===8'h2E)|(ps2_out===8'h73))//5
	morse_ascii = 32'd53;
	else if((ps2_out===8'h36)|(ps2_out===8'h74))//6
	morse_ascii = 32'd54;
	else if((ps2_out===8'h3D)|(ps2_out===8'h6C))//7
	morse_ascii = 32'd55;
	else if((ps2_out===8'h3E)|(ps2_out===8'h75))//8
	morse_ascii = 32'd56;
	else if((ps2_out===8'h46)|(ps2_out===8'h7D))//9
	morse_ascii = 32'd57;
	else if(ps2_out===8'h1C)//A
	morse_ascii = 32'd65;
	else if(ps2_out===8'h32)//B
	morse_ascii = 32'd66;
	else if(ps2_out===8'h21)//C
	morse_ascii = 32'd67;
	else if(ps2_out===8'h23)//D
	morse_ascii = 32'd68;
	else if(ps2_out===8'h24)//E
	morse_ascii = 32'd69;
	else if(ps2_out===8'h2B)//F
	morse_ascii = 32'd70;
	else if(ps2_out===8'h34)//G
	morse_ascii = 32'd71;
	else if(ps2_out===8'h33)//H
	morse_ascii = 32'd72;
	else if(ps2_out===8'h43)//I
	morse_ascii = 32'd73;
	else if(ps2_out===8'h3B)//J
	morse_ascii = 32'd74;
	else if(ps2_out===8'h42)//K
	morse_ascii = 32'd75;
	else if(ps2_out===8'h4B)//L
	morse_ascii = 32'd76;
	else if(ps2_out===8'h3A)//M
	morse_ascii = 32'd77;
	else if(ps2_out===8'h31)//N
	morse_ascii = 32'd78;
	else if(ps2_out===8'h44)//O
	morse_ascii = 32'd79;
	else if(ps2_out===8'h4D)//P
	morse_ascii = 32'd80;
	else if(ps2_out===8'h15)//Q
	morse_ascii = 32'd81;
	else if(ps2_out===8'h2D)//R
	morse_ascii = 32'd82;
	else if(ps2_out===8'h1B)//S
	morse_ascii = 32'd83;
	else if(ps2_out===8'h2C)//T
	morse_ascii = 32'd84;
	else if(ps2_out===8'h3C)//U
	morse_ascii = 32'd85;
	else if(ps2_out===8'h2A)//V
	morse_ascii = 32'd86;
	else if(ps2_out===8'h1D)//W
	morse_ascii = 32'd87;
	else if(ps2_out===8'h22)//X
	morse_ascii = 32'd88;
	else if(ps2_out===8'h35)//Y
	morse_ascii = 32'd89;
	else if(ps2_out===8'h1A)//Z
	morse_ascii = 32'd90;
	else
	morse_ascii = 32'd0;
	end
	
	assign morse_asciiout = morse_ascii;
endmodule
