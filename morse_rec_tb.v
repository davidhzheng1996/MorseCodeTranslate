`timescale 1ns/100ps

`include "timer/morse_rec.v"
module tb;
parameter wid=32;
reg reset,clk,sig_in;
// wire ctrl_stored, ischanged,reset;
wire [wid-1:0] out,next;
wire [wid-1:0] result,res, nres;
wire [5*wid-1:0] value;
wire n,done, m_end, valid;
integer j, k;
integer inte;
wire [wid-1:0] value0,value1,value2,value3,value4;
assign value0 = value[31:0];
assign value1 = value[63:32];
assign value2 = value[3*wid-1:2*wid];
assign value3 = value[4*wid-1:3*wid];
assign value4 = value[5*wid-1:4*wid];
morse_rec mr(clk, sig_in, reset, m_end, valid);
assign value = mr.value;
wire [4:0] decoded_sig_ct;
assign decoded_sig_ct = mr.decoded_sig_ct;
// j=out;
initial begin
	$dumpfile("morse_recorder_tb.vcd");
	$dumpvars(0, tb);

	#10
	$display($time, " << Starting the Simulation >>");
	// $monitor("t=%3d clk=%d, sig_in=%d, value0=%d, value1=%d\n",$time, clk, sig_in,value[31:0],value[63:32]);
	// $monitor("t=%3d value0=%3d, value1=%3d,value2=%3d, value3=%3d, value4=%3d\n",$time,value0,value1,value2,value3,value4);
	// $monitor("t=%3d value0=%3d, value1=%3d,value2=%3d, value3=%3d, value4=%3d, m_end=%d, ct=%b\n",$time,value0,value1,value2,value3,value4,m_end,decoded_sig_ct);
	$monitor("t=%3d value0=%3d, value1=%3d,value2=%3d, value3=%3d, value4=%3d, m_end=%d\n",$time,value0,value1,value2,value3,value4,m_end);

	clk=0;
	reset=0;
	sig_in=0;
	#100
	//value 0
	sig_in=1;
	#135
	sig_in=0;
	#100
	//value 1
	sig_in=1;
	#140
	sig_in=0;
	#100

	//value 2
	sig_in=1;
	#180
	// sig_in=0;
	// #100
	sig_in=0;
	#100

	//value 3
	sig_in=1;
	#150
	sig_in=0;
	#100
	//value 4
	sig_in=1;
	#180
	sig_in=0;
	#100
	$display("resetting");
	reset=1;
	#5
	reset=0;

	sig_in=0;
	#100
	//value 0
	sig_in=1;
	#135
	sig_in=0;
	#100
	//value 1
	sig_in=1;
	#180
	sig_in=0;
	#100
	//value 2
	sig_in=1;
	#145
	sig_in=0;
	#350
	//value 3
	sig_in=1;
	#150
	sig_in=0;
	#340
	$display($time, " end of Simulation");
	$finish;
end

always
    #5     clk = ~clk;
endmodule


//tim_counter
//registers of values
//delay sig
//needs rst
//there's a bit race condition


//behavior
//after first triggering (signal high)
//if there is a low time greater than delay_max (hardcoded)
//then this module signals the end and pauses until reset is asserted(&deserted).