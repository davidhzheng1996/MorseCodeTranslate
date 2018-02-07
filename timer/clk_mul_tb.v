`timescale 1ns/100ps

`include "timer/clk_mul.v"
module tb;
parameter wid=5;
reg reset,clk;
// wire ctrl_stored, ischanged,reset;
wire [wid-1:0] out,next;
wire [wid-1:0] result,res, nres;
wire n,done;
integer j, k;
integer inte;

clk_mul c8(clk, 5'd5, out);

// j=out;
initial begin
	$dumpfile("clk_mul_tb.vcd");
	$dumpvars(0, tb);

	#8
	$display($time, " << Starting the Simulation >>");
	$monitor("t=%3d clk=%d, out=%b, end/done=%d\n",$time, clk, out,done);
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