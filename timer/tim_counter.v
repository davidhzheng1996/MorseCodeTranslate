//$(wid)-bit looping counter
//ct increases from 0 to the biggest number represented by the wid parameter
//high "reset" resets the counter 
`ifndef tim_counter_H
`define tim_counter_H//to prevent repeated include
`include "paramd_reg/reg_n.v"
module tim_counter(clk, reset, ct);//32 counter
parameter wid=32;
     input clk, reset;
     output [wid-1:0] ct;//current count
     
     wire [wid-1:0] next;
     reg c_end;

     //reg_n use nrst
     reg_n #(.N(wid)) a32(clk,~reset,1'b1,next, ct);

     assign next = ct+1;

endmodule
`endif