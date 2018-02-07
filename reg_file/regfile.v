`ifndef regfile_H
`define regfile_H//to prevent repeated include
//`include "common/"
`include "reg_file/decoder32bits.v"
`include "reg_file/mux.v"
`include "reg_file/reg32bits.v"
`include "reg_file/dffe1.v"
`include "reg_file/equal5bits.v"
`include "reg_file/isZero.v"

module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB, data_r30, dataout_29
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg, data_r30;

   output [31:0] data_readRegA, data_readRegB, dataout_29;
	wire [31:0] decodeWriteWire, WEwire, r30datawrite;
	wire [31:0] wireOut [31:0];
	
	decoder32bits decodeW(decodeWriteWire, ctrl_writeReg);

	genvar i;
	generate
		for(i=0; i<29; i=i+1) begin:loop1
			and(WEwire[i], ctrl_writeEnable, decodeWriteWire[i]);
			reg32bits my_reg(data_writeReg, clock, ctrl_reset, WEwire[i], wireOut[i]);
		end
	endgenerate
	
	//r29
	and(WEwire[29], ctrl_writeEnable, decodeWriteWire[29]);
	reg32bits my_reg29(data_writeReg, clock, ctrl_reset, WEwire[29], wireOut[29]);
	assign dataout_29 = wireOut[29];
	//r31
	and(WEwire[31], ctrl_writeEnable, decodeWriteWire[31]);
	reg32bits my_reg31(data_writeReg, clock, ctrl_reset, WEwire[31], wireOut[31]);
	
	//r30 or rstatus
	wire r30zero, r30write, enabler30;
	isZero checkrstatus0(.dataiszero(r30zero), .data(data_r30));
	assign r30datawrite = r30zero ? data_writeReg : data_r30;
	equal5bits checkr30(r30write, ctrl_writeReg, 5'b11110);
	and(WEwire[30], ctrl_writeEnable, r30write);
	or(enabler30, WEwire[30], ~r30zero);
	reg32bits my_reg30(r30datawrite, clock, ctrl_reset, WEwire[30], wireOut[30]);
	

	mux my_mux1(data_readRegA, ctrl_readRegA, wireOut[0], wireOut[1], wireOut[2], wireOut[3],
	wireOut[4], wireOut[5], wireOut[6], wireOut[7], wireOut[8], wireOut[9], 
	wireOut[10], wireOut[11], wireOut[12], wireOut[13],
	wireOut[14], wireOut[15], wireOut[16], wireOut[17], wireOut[18], wireOut[19],
	wireOut[20], wireOut[21], wireOut[22], wireOut[23],
	wireOut[24], wireOut[25], wireOut[26], wireOut[27], wireOut[28], wireOut[29],
	wireOut[30], wireOut[31]);
	
	mux my_mux2(data_readRegB, ctrl_readRegB, wireOut[0], wireOut[1], wireOut[2], wireOut[3],
	wireOut[4], wireOut[5], wireOut[6], wireOut[7], wireOut[8], wireOut[9], 
	wireOut[10], wireOut[11], wireOut[12], wireOut[13],
	wireOut[14], wireOut[15], wireOut[16], wireOut[17], wireOut[18], wireOut[19],
	wireOut[20], wireOut[21], wireOut[22], wireOut[23],
	wireOut[24], wireOut[25], wireOut[26], wireOut[27], wireOut[28], wireOut[29],
	wireOut[30], wireOut[31]);
	
endmodule
`endif