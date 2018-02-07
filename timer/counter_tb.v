`timescale 1ns/100ps

`include "timer/tim_counter.v"
module tb;
parameter wid=3;
reg reset,clk;
// wire ctrl_stored, ischanged,reset;
wire [wid-1:0] out,next;
wire [wid-1:0] result,res, nres;
wire n,done;
integer j, k;
integer inte;

tim_counter c8(clk, reset, out);
// j=out;
initial begin
	$dumpfile("counter_tb.vcd");
	$dumpvars(0, tb);

	#8
	$display($time, " << Starting the Simulation >>");
	$monitor("t=%3d clk=%d, out=%d, end/done=%d\n",$time, clk, out,done);
	clk=0;
	#100
	reset=1;
	#100
	reset=0;
	#340
	$display($time, " end of Simulation");
	$finish;
end

always
    #5     clk = ~clk;
endmodule