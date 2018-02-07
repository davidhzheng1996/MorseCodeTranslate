//test change_Reset
//ischanged is high for one clock period when ctrl is asserted at clk rises
//if ctrl asserted not at clk rise, this will take 1.5 clock period
//20171108 fixed bug of reset declaring for 2 cycles
`ifndef changed_H
`define changed_H//to prevent repeated include
`include "common/mydffe.v"
module changed(ctrl, clk,ischanged,reset);

    input ctrl, clk;
    output ischanged,reset;
    wire ctrl,clrn, prn, ena, ctrl_stored,ctrl_stored_mid,reset;

    mydffe st(ctrl,clk, , , 1'b1, ctrl_stored_mid);
    mydffe s(ctrl_stored_mid,clk, , , 1'b1, ctrl_stored);
    xor axor(ischanged,ctrl,ctrl_stored_mid);
    and rand(reset,ischanged,ctrl);

endmodule
`endif