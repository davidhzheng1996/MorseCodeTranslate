module reg32bits(d, clock, ctrl_reset, ctrl_writeReg, q);
	input clock, ctrl_reset, ctrl_writeReg;
	input [31:0] d;
	output [31:0] q;
	wire reset1;
	
	assign reset1 = ~ctrl_reset;
	
	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1) begin: loop1
			dffe1 my_dffe(d[i], clock, reset1, ctrl_writeReg, q[i]);
		end
		
	endgenerate
endmodule
