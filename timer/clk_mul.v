//a clock multiplier that multiplier the clock period with a number
`ifndef clk_multiplier_H
`define clk_multiplier_H//to prevent repeated include
`include "paramd_reg/reg_n.v"
module clk_mul(clk_in, multiplier, clk_out);//32 counter

parameter wid=5;//need to be large enough to hold multiplier

     input clk_in;
     output clk_out;
     input[wid-1:0] multiplier;
     wire clk;
     assign clk = clk_in;

     reg clk_out,rst;
     wire [wid-1:0] next,ct;
     wire nrst;
     assign nrst = ~rst;
     //reg_n use nrst
     reg_n #(.N(wid)) a32(clk,nrst,1'b1,next, ct);
     
     assign next = ct+1;
     initial begin
          clk_out=0;
          rst=0;
     end


     always @(posedge clk or negedge clk) begin
          if (ct>=multiplier-1) begin
               rst=1;
               clk_out=~clk_out;
          end
          else if(~clk) begin
               rst=0;
          end
     end
endmodule
`endif