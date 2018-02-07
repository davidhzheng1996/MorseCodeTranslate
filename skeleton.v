
module skeleton(resetn,
	ps2_clock, ps2_data, // ps2 related I/O
	debug_data_in, debug_addr, leds, // extra debugging ports
	lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon,// LCD info
	seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8, // seven segements
	VGA_CLK,
	// VGA Clock
	VGA_HS,
	// VGA H_SYNC
	VGA_VS,
	// VGA V_SYNC
	VGA_BLANK,
	// VGA BLANK
	VGA_SYNC,
	// VGA SYNC
	VGA_R, // VGA Red[9:0]
	VGA_G, // VGA Green[9:0]
	VGA_B, // VGA Blue[9:0]
	CLOCK_50,
	morse,
	asciiout,
	cpuclock, pcout, decodeend);
// 50 MHz clock
//////////////////////// VGA ////////////////////////////
	output VGA_CLK; // VGA Clock
	output VGA_HS; // VGA H_SYNC
	output VGA_VS; // VGA V_SYNC
	output VGA_BLANK; // VGA BLANK
	output VGA_SYNC; // VGA SYNC
	output [7:0] VGA_R; // VGA Red[9:0]
	output [7:0] VGA_G; // VGA Green[9:0]
	output [7:0] VGA_B; // VGA Blue[9:0]
	input CLOCK_50, cpuclock, decodeend;
	output [31:0] asciiout, pcout;
//////////////////////// PS2 ////////////////////////////
	input resetn;
	inout ps2_data, ps2_clock;
	input morse;
//////////////////////// LCD and Seven Segment ////////////////////////////
	output lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon;
	output [7:0] leds, lcd_data;
	output [6:0] seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8;
	output [31:0] debug_data_in;
	output [11:0] debug_addr;
	wire clock;
	wire [31:0] cpuascii;
	wire lcd_write_en;
	wire [31:0] lcd_write_data;
	wire [7:0] ps2_key_data;
	reg [7:0] toSeven;
	wire [31:0] morse_ascii;
	wire ps2_key_pressed;
//	wire decodeend;
	wire [7:0] ps2_out;
// clock divider (by 5, i.e., 10 MHz)
	pll div(CLOCK_50,inclock);
	assign clock = CLOCK_50;
// UNCOMMENT FOLLOWING LINE AND COMMENT ABOVE LINE TO RUN AT 50 MHz
//	assign clock = inclock;
// your processor
	processor myprocessor(cpuclock, ~resetn, /*ps2_key_pressed, ps2_out, lcd_write_en,
lcd_write_data,*/ morse, cpuascii, decodeend, pcout);
// keyboard controller
	PS2_Interface myps2(clock, resetn, ps2_clock, ps2_data, ps2_key_data, ps2_key_pressed,
	ps2_out);
//	reg ctrl;
//	always @(posedge clock)
//	begin
//	if(ps2_key_pressed==1'b1)
//		ctrl<=1'b1;
//	else
//		ctrl<=1'b0;
//	end	
// lcd controller
//	lcd mylcd(clock, ~resetn, ps2_key_pressed, lcd_in, lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon);
	reg [7:0] lcd_in;
//	reg [31:0] morse_ascii;
//	assign morse_ascii = 32'd86;
//	assign morse_ascii = cpuascii;
	ps2toascii myps2toascii(ps2_out, morse_ascii);
	assign asciiout = cpuascii;
//		always @(*)
//	begin
//	if((ps2_out===8'h45)|(ps2_out===8'h70))//0
//	morse_ascii = 32'd48;
//	else if((ps2_out===8'h16)|(ps2_out===8'h69))//1
//	morse_ascii = 32'd49;
//	else if((ps2_out===8'h1E)|(ps2_out===8'h72))//2
//	morse_ascii = 32'd50;
//	else if((ps2_out===8'h26)|(ps2_out===8'h7A))//3
//	morse_ascii = 32'd51;
//	else if((ps2_out===8'h25)|(ps2_out===8'h6B))//4
//	morse_ascii = 32'd52;
//	else if((ps2_out===8'h2E)|(ps2_out===8'h73))//5
//	morse_ascii = 32'd53;
//	else if((ps2_out===8'h36)|(ps2_out===8'h74))//6
//	morse_ascii = 32'd54;
//	else if((ps2_out===8'h3D)|(ps2_out===8'h6C))//7
//	morse_ascii = 32'd55;
//	else if((ps2_out===8'h3E)|(ps2_out===8'h75))//8
//	morse_ascii = 32'd56;
//	else if((ps2_out===8'h46)|(ps2_out===8'h7D))//9
//	morse_ascii = 32'd57;
//	else if(ps2_out===8'h1C)//A
//	morse_ascii = 32'd65;
//	else if(ps2_out===8'h32)//B
//	morse_ascii = 32'd66;
//	else if(ps2_out===8'h21)//C
//	morse_ascii = 32'd67;
//	else if(ps2_out===8'h23)//D
//	morse_ascii = 32'd68;
//	else if(ps2_out===8'h24)//E
//	morse_ascii = 32'd69;
//	else if(ps2_out===8'h2B)//F
//	morse_ascii = 32'd70;
//	else if(ps2_out===8'h34)//G
//	morse_ascii = 32'd71;
//	else if(ps2_out===8'h33)//H
//	morse_ascii = 32'd72;
//	else if(ps2_out===8'h43)//I
//	morse_ascii = 32'd73;
//	else if(ps2_out===8'h3B)//J
//	morse_ascii = 32'd74;
//	else if(ps2_out===8'h42)//K
//	morse_ascii = 32'd75;
//	else if(ps2_out===8'h4B)//L
//	morse_ascii = 32'd76;
//	else if(ps2_out===8'h3A)//M
//	morse_ascii = 32'd77;
//	else if(ps2_out===8'h31)//N
//	morse_ascii = 32'd78;
//	else if(ps2_out===8'h44)//O
//	morse_ascii = 32'd79;
//	else if(ps2_out===8'h4D)//P
//	morse_ascii = 32'd80;
//	else if(ps2_out===8'h15)//Q
//	morse_ascii = 32'd81;
//	else if(ps2_out===8'h2D)//R
//	morse_ascii = 32'd82;
//	else if(ps2_out===8'h1B)//S
//	morse_ascii = 32'd83;
//	else if(ps2_out===8'h2C)//T
//	morse_ascii = 32'd84;
//	else if(ps2_out===8'h3C)//U
//	morse_ascii = 32'd85;
//	else if(ps2_out===8'h2A)//V
//	morse_ascii = 32'd86;
//	else if(ps2_out===8'h1D)//W
//	morse_ascii = 32'd87;
//	else if(ps2_out===8'h22)//X
//	morse_ascii = 32'd88;
//	else if(ps2_out===8'h35)//Y
//	morse_ascii = 32'd89;
//	else if(ps2_out===8'h1A)//Z
//	morse_ascii = 32'd90;
//	else
//	morse_ascii = 32'd0;
//	end
	
//		always @(*)
//	begin
//	if((ps2_out===8'h45)|(ps2_out===8'h70))//0
//	lcd_in=8'h30;
//	else if((ps2_out===8'h16)|(ps2_out===8'h69))//1
//	lcd_in=8'h31;
//	else if((ps2_out===8'h1E)|(ps2_out===8'h72))//2
//	lcd_in=8'h32;
//	else if((ps2_out===8'h26)|(ps2_out===8'h7A))//3
//	lcd_in=8'h33;
//	else if((ps2_out===8'h25)|(ps2_out===8'h6B))//4
//	lcd_in=8'h34;
//	else if((ps2_out===8'h2E)|(ps2_out===8'h73))//5
//	lcd_in=8'h35;
//	else if((ps2_out===8'h36)|(ps2_out===8'h74))//6
//	lcd_in=8'h36;
//	else if((ps2_out===8'h3D)|(ps2_out===8'h6C))//7
//	lcd_in=8'h37;
//	else if((ps2_out===8'h3E)|(ps2_out===8'h75))//8
//	lcd_in=8'h38;
//	else if((ps2_out===8'h46)|(ps2_out===8'h7D))//9
//	lcd_in=8'h39;
//	else if(ps2_out===8'h1C)//A
//	lcd_in=8'h41;
//	else if(ps2_out===8'h32)//B
//	lcd_in=8'h42;
//	else if(ps2_out===8'h21)//C
//	lcd_in=8'h43;
//	else if(ps2_out===8'h23)//D
//	lcd_in=8'h44;
//	else if(ps2_out===8'h24)//E
//	lcd_in=8'h45;
//	else if(ps2_out===8'h2B)//F
//	lcd_in=8'h46;
//	else if(ps2_out===8'h34)//G
//	lcd_in=8'h47;
//	else if(ps2_out===8'h33)//H
//	lcd_in=8'h48;
//	else if(ps2_out===8'h43)//I
//	lcd_in=8'h49;
//	else if(ps2_out===8'h3B)//J
//	lcd_in=8'h4A;
//	else if(ps2_out===8'h42)//K
//	lcd_in=8'h4B;
//	else if(ps2_out===8'h4B)//L
//	lcd_in=8'h4C;
//	else if(ps2_out===8'h3A)//M
//	lcd_in=8'h4D;
//	else if(ps2_out===8'h31)//N
//	lcd_in=8'h4E;
//	else if(ps2_out===8'h44)//O
//	lcd_in=8'h4F;
//	else if(ps2_out===8'h4D)//P
//	lcd_in=8'h50;
//	else if(ps2_out===8'h15)//Q
//	lcd_in=8'h51;
//	else if(ps2_out===8'h2D)//R
//	lcd_in=8'h52;
//	else if(ps2_out===8'h1B)//S
//	lcd_in=8'h53;
//	else if(ps2_out===8'h2C)//T
//	lcd_in=8'h54;
//	else if(ps2_out===8'h3C)//U
//	lcd_in=8'h55;
//	else if(ps2_out===8'h2A)//V
//	lcd_in=8'h56;
//	else if(ps2_out===8'h1D)//W
//	lcd_in=8'h57;
//	else if(ps2_out===8'h22)//X
//	lcd_in=8'h58;
//	else if(ps2_out===8'h35)//Y
//	lcd_in=8'h59;
//	else if(ps2_out===8'h1A)//Z
//	lcd_in=8'h5A;
//	else
//	lcd_in<=ps2_out;
//	end
	
	always @(posedge clock)
	begin
	if(morse_ascii===32'd48)//0
	lcd_in=8'h30;
	else if(morse_ascii===32'd49)//1
	lcd_in=8'h31;
	else if(morse_ascii===32'd50)//2
	lcd_in=8'h32;
	else if(morse_ascii===32'd51)//3
	lcd_in=8'h33;
	else if(morse_ascii===32'd52)//4
	lcd_in=8'h34;
	else if(morse_ascii===32'd53)//5
	lcd_in=8'h35;
	else if(morse_ascii===32'd54)//6
	lcd_in=8'h36;
	else if(morse_ascii===32'd55)//7
	lcd_in=8'h37;
	else if(morse_ascii===32'd56)//8
	lcd_in=8'h38;
	else if(morse_ascii===32'd57)//9
	lcd_in=8'h39;
	else if(morse_ascii===32'd65)//A
	lcd_in=8'h41;
	else if(morse_ascii===32'd66)//B
	lcd_in=8'h42;
	else if(morse_ascii===32'd67)//C
	lcd_in=8'h43;
	else if(morse_ascii===32'd68)//D
	lcd_in=8'h44;
	else if(morse_ascii===32'd69)//E
	lcd_in=8'h45;
	else if(morse_ascii===32'd70)//F
	lcd_in=8'h46;
	else if(morse_ascii===32'd71)//G
	lcd_in=8'h47;
	else if(morse_ascii===32'd72)//H
	lcd_in=8'h48;
	else if(morse_ascii===32'd73)//I
	lcd_in=8'h49;
	else if(morse_ascii===32'd74)//J
	lcd_in=8'h4A;
	else if(morse_ascii===32'd75)//K
	lcd_in=8'h4B;
	else if(morse_ascii===32'd76)//L
	lcd_in=8'h4C;
	else if(morse_ascii===32'd77)//M
	lcd_in=8'h4D;
	else if(morse_ascii===32'd78)//N
	lcd_in=8'h4E;
	else if(morse_ascii===32'd79)//O
	lcd_in=8'h4F;
	else if(morse_ascii===32'd80)//P
	lcd_in=8'h50;
	else if(morse_ascii===32'd81)//Q
	lcd_in=8'h51;
	else if(morse_ascii===32'd82)//R
	lcd_in=8'h52;
	else if(morse_ascii===32'd83)//S
	lcd_in=8'h53;
	else if(morse_ascii===32'd84)//T
	lcd_in=8'h54;
	else if(morse_ascii===32'd85)//U
	lcd_in=8'h55;
	else if(morse_ascii===32'd86)//V
	lcd_in=8'h56;
	else if(morse_ascii===32'd87)//W
	lcd_in=8'h57;
	else if(morse_ascii===32'd88)//X
	lcd_in=8'h58;
	else if(morse_ascii===32'd89)//Y
	lcd_in=8'h59;
	else if(morse_ascii===32'd90)//Z
	lcd_in=8'h5A;
	else
	lcd_in=8'h0;
	end
	
	always @(*)
	begin
	if(morse_ascii===32'd48)//0
	toSeven = 8'h48;
	else if(morse_ascii===32'd49)//1
	toSeven = 8'h49;
	else if(morse_ascii===32'd50)//2
	toSeven = 8'h50;
	else if(morse_ascii===32'd51)//3
	toSeven = 8'h51;
	else if(morse_ascii===32'd52)//4
	toSeven = 8'h52;
	else if(morse_ascii===32'd53)//5
	toSeven = 8'h53;
	else if(morse_ascii===32'd54)//6
	toSeven = 8'h54;
	else if(morse_ascii===32'd55)//7
	toSeven = 8'h55;
	else if(morse_ascii===32'd56)//8
	toSeven = 8'h56;
	else if(morse_ascii===32'd57)//9
	toSeven = 8'h57;
	else if(morse_ascii===32'd65)//A
	toSeven = 8'h65;
	else if(morse_ascii===32'd66)//B
	toSeven = 8'h66;
	else if(morse_ascii===32'd67)//C
	toSeven = 8'h67;
	else if(morse_ascii===32'd68)//D
	toSeven = 8'h68;
	else if(morse_ascii===32'd69)//E
	toSeven = 8'h69;
	else if(morse_ascii===32'd70)//F
	toSeven = 8'h70;
	else if(morse_ascii===32'd71)//G
	toSeven = 8'h71;
	else if(morse_ascii===32'd72)//H
	toSeven = 8'h72;
	else if(morse_ascii===32'd73)//I
	toSeven = 8'h73;
	else if(morse_ascii===32'd74)//J
	toSeven = 8'h74;
	else if(morse_ascii===32'd75)//K
	toSeven = 8'h75;
	else if(morse_ascii===32'd76)//L
	toSeven = 8'h76;
	else if(morse_ascii===32'd77)//M
	toSeven = 8'h77;
	else if(morse_ascii===32'd78)//N
	toSeven = 8'h78;
	else if(morse_ascii===32'd79)//O
	toSeven = 8'h79;
	else if(morse_ascii===32'd80)//P
	toSeven = 8'h80;
	else if(morse_ascii===32'd81)//Q
	toSeven = 8'h81;
	else if(morse_ascii===32'd82)//R
	toSeven = 8'h82;
	else if(morse_ascii===32'd83)//S
	toSeven = 8'h83;
	else if(morse_ascii===32'd84)//T
	toSeven = 8'h84;
	else if(morse_ascii===32'd85)//U
	toSeven = 8'h85;
	else if(morse_ascii===32'd86)//V
	toSeven = 8'h86;
	else if(morse_ascii===32'd87)//W
	toSeven = 8'h87;
	else if(morse_ascii===32'd88)//X
	toSeven = 8'h88;
	else if(morse_ascii===32'd89)//Y
	toSeven = 8'h89;
	else if(morse_ascii===32'd90)//Z
	toSeven = 8'h90;
	else
	toSeven = 8'h0;
	end
	
//	always @(*)
//	begin
//	if((ps2_out===8'h45)|(ps2_out===8'h70))//0
//	lcd_in=8'h30;
//	else if((ps2_out===8'h16)|(ps2_out===8'h69))//1
//	lcd_in=8'h31;
//	else if((ps2_out===8'h1E)|(ps2_out===8'h72))//2
//	lcd_in=8'h32;
//	else if((ps2_out===8'h26)|(ps2_out===8'h7A))//3
//	lcd_in=8'h33;
//	else if((ps2_out===8'h25)|(ps2_out===8'h6B))//4
//	lcd_in=8'h34;
//	else if((ps2_out===8'h2E)|(ps2_out===8'h73))//5
//	lcd_in=8'h35;
//	else if((ps2_out===8'h36)|(ps2_out===8'h74))//6
//	lcd_in=8'h36;
//	else if((ps2_out===8'h3D)|(ps2_out===8'h6C))//7
//	lcd_in=8'h37;
//	else if((ps2_out===8'h3E)|(ps2_out===8'h75))//8
//	lcd_in=8'h38;
//	else if((ps2_out===8'h46)|(ps2_out===8'h7D))//9
//	lcd_in=8'h39;
//	else if(ps2_out===8'h1C)//A
//	lcd_in=8'h41;
//	else if(ps2_out===8'h32)//B
//	lcd_in=8'h42;
//	else if(ps2_out===8'h21)//C
//	lcd_in=8'h43;
//	else if(ps2_out===8'h23)//D
//	lcd_in=8'h44;
//	else if(ps2_out===8'h24)//E
//	lcd_in=8'h45;
//	else if(ps2_out===8'h2B)//F
//	lcd_in=8'h46;
//	else if(ps2_out===8'h34)//G
//	lcd_in=8'h47;
//	else if(ps2_out===8'h33)//H
//	lcd_in=8'h48;
//	else if(ps2_out===8'h43)//I
//	lcd_in=8'h49;
//	else if(ps2_out===8'h3B)//J
//	lcd_in=8'h4A;
//	else if(ps2_out===8'h42)//K
//	lcd_in=8'h4B;
//	else if(ps2_out===8'h4B)//L
//	lcd_in=8'h4C;
//	else if(ps2_out===8'h3A)//M
//	lcd_in=8'h4D;
//	else if(ps2_out===8'h31)//N
//	lcd_in=8'h4E;
//	else if(ps2_out===8'h44)//O
//	lcd_in=8'h4F;
//	else if(ps2_out===8'h4D)//P
//	lcd_in=8'h50;
//	else if(ps2_out===8'h15)//Q
//	lcd_in=8'h51;
//	else if(ps2_out===8'h2D)//R
//	lcd_in=8'h52;
//	else if(ps2_out===8'h1B)//S
//	lcd_in=8'h53;
//	else if(ps2_out===8'h2C)//T
//	lcd_in=8'h54;
//	else if(ps2_out===8'h3C)//U
//	lcd_in=8'h55;
//	else if(ps2_out===8'h2A)//V
//	lcd_in=8'h56;
//	else if(ps2_out===8'h1D)//W
//	lcd_in=8'h57;
//	else if(ps2_out===8'h22)//X
//	lcd_in=8'h58;
//	else if(ps2_out===8'h35)//Y
//	lcd_in=8'h59;
//	else if(ps2_out===8'h1A)//Z
//	lcd_in=8'h5A;
//	else
//	lcd_in<=ps2_out;
//	end
// example for sending ps2 data to the first two seven segment displays
	Hexadecimal_To_Seven_Segment hex1(toSeven[3:0], seg1);
	Hexadecimal_To_Seven_Segment hex2(toSeven[7:4], seg2);
// the other seven segment displays are currently set to 0
//	Hexadecimal_To_Seven_Segment hex3(4'b0, seg3);
	assign seg3 = 7'b1111111;
	ascii_to_seven_seg my_sevenseg(morse_ascii, seg8, seg7, 
	seg6, seg5, seg4);
//	Hexadecimal_To_Seven_Segment hex4(4'b0, seg4);
//	Hexadecimal_To_Seven_Segment hex5(4'b0, seg5);
//	Hexadecimal_To_Seven_Segment hex6(4'b0, seg6);
//	Hexadecimal_To_Seven_Segment hex7(4'b0, seg7);
//	Hexadecimal_To_Seven_Segment hex8(4'b0, seg8);
// some LEDs that you could use for debugging if you wanted
assign leds = 8'b00101011;
lcd mylcd(clock, ~resetn, 1'b1, lcd_in, lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon);
// VGA
Reset_Delay r0 (.iCLK(CLOCK_50),.oRESET(DLY_RST) );
VGA_Audio_PLL p1
(.areset(~DLY_RST),.inclk0(CLOCK_50),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)
);
vga_controller vga_ins(.iRST_n(DLY_RST),
.iVGA_CLK(VGA_CLK),
.oBLANK_n(VGA_BLANK),
.oHS(VGA_HS),
.oVS(VGA_VS),
.b_data(VGA_B),
.g_data(VGA_G),
.r_data(VGA_R),
.morse(morse_ascii));
endmodule
